import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lettersnumbers/common/firebaseMethods/firebaseMethods.dart';
import 'package:lettersnumbers/model/sessionSingleton.dart';

class NewsUpdatePage extends StatefulWidget {
  @override
  _NewsUpdatePageState createState() => _NewsUpdatePageState();
}

class _NewsUpdatePageState extends State<NewsUpdatePage> {
  final TextEditingController _newsUpdateController = TextEditingController();

  String newsUpdate = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter News Update'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: (value) {
                newsUpdate = value;
              } ,
              decoration: InputDecoration(labelText: 'Enter News Update'),
              maxLines: null,
            ),
            SizedBox(height: 100.0),
            ElevatedButton(
              onPressed: () {
                FirebaseMethods.saveNewsUpdate(newsUpdate, context);
              },
              child: Text('Save News Update'),
            ),
          ],
        ),
      ),
    );
  }
}
