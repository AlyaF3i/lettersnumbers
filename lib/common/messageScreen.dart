import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:lettersnumbers/model/userdata.dart';

import '../model/sessionSingleton.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, required this.callback});

  final void Function(int) callback;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();

 late String _selectedUserId;
  TextEditingController _messageController = TextEditingController();
  List<UserData> reciverList = []; 
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    reciverList = SessionSingleton().isTeacher ? SessionSingleton().studentList : SessionSingleton().teacherList;
    _selectedUserId = reciverList[0].uid;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            widget.callback(0);
          },
        ),
        title: Text('Instant Messaging'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          
            
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
        
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 244, 150, 150),
                  ),
                  child: Center(child: Text(SessionSingleton().currentUserName)),
                  height: 55,
                ),
                Container(
                   padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 153, 222, 155),
                  ),
                  child: DropdownButton<String>(
                    
                    value: _selectedUserId,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedUserId = newValue!;
                      });
                    },
                    items: reciverList // Populate with user IDs
                        .map<DropdownMenuItem<String>>((UserData value) {
                      return DropdownMenuItem<String>(
                        value: value.uid,
                        child: Text(value.username),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(SessionSingleton().sessionId) // Replace with current user's ID
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
        
                  Map<String, dynamic> chats = snapshot.data?.data() == null ? <String, dynamic>{} : snapshot.data?.data() as Map<String, dynamic>;
        
                  if (chats == null || chats.isEmpty || chats[_selectedUserId] == null) {
                    return Center(
                      child: Text('No chats yet!'),
                    );
                  }
        
                  List<Map<String, dynamic>> chatList = (chats[_selectedUserId] as List<dynamic> ?? []).cast<Map<String, dynamic>>();
        
                  return ListView.builder(
                    itemCount: chatList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> chat = chatList[index];
                      return ListTile(
                        title: Text(chat['text']),
                        subtitle: Text(chat['sender']),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Enter your message...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      _sendMessage();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
  String messageText = _messageController.text.trim();
  if (messageText.isNotEmpty && _selectedUserId != null) {
    String senderId = SessionSingleton().sessionId; // Replace with current user's ID
    String senderName = SessionSingleton().currentUserName;
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Update sender's document
    DocumentReference senderDocRef = FirebaseFirestore.instance.collection('chats').doc(senderId);
    batch.set(
      senderDocRef,
      {
        _selectedUserId: FieldValue.arrayUnion([
          {
            'text': messageText,
            'sender': senderName,
            'timestamp': Timestamp.now(),
          }
        ])
      },
      SetOptions(merge: true),
    );

    // Update receiver's document
    DocumentReference receiverDocRef = FirebaseFirestore.instance.collection('chats').doc(_selectedUserId);
    batch.set(
      receiverDocRef,
      {
        senderId: FieldValue.arrayUnion([
          {
            'text': messageText,
            'sender': senderName,
            'timestamp': Timestamp.now(),
          }
        ])
      },
      SetOptions(merge: true),
    );

    batch.commit();

    _messageController.clear();
  }
}


}
