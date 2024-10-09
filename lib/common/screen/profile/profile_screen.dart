import 'package:flutter/material.dart';
import 'package:lettersnumbers/model/sessionSingleton.dart';
import 'package:lettersnumbers/common/widgets/cardItem.dart';

import '../../widgets/horizontalList.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List items = ["Super", "Cool"];
  SessionSingleton user = SessionSingleton();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/dashboard.png'), // Replace with your image path
                fit: BoxFit.fill, // Adjust the fit property as needed
              ),
            ),
            child: SingleChildScrollView(
                child: Padding(
                    padding:
                        const EdgeInsets.only(top: 50, left: 20, right: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back_ios_new)),
                            Text("Profile", style: TextStyle(fontSize: 20),),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset('assets/images/logout.png'),
                        ),
                      ],
                    ),
              SizedBox(height: 40,),
                          Container(
                            height: 180,
                            child: _profileSection(),
                          ),
                          _buildSection(
                              "Strong side:",
                              items,
                              Color.fromARGB(255, 199, 241, 226),
                              Color.fromARGB(255, 4, 54, 37)),
                          _buildSection(
                              "Weak side:",
                              items,
                              Color.fromARGB(255, 246, 225, 228),
                              Color.fromARGB(255, 214, 81, 37)),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            "My Reports:",
                            style: TextStyle(fontSize: 25),
                          ),
                          _reportSection()

                        ])))));
  }

  Widget _buildSection(
      String title, List items, Color backColor, Color fontColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        HorizontalList(
          items: items,
          color: backColor,
          textColor: fontColor,
        ),
      ],
    );
  }

  Widget _reportSection(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              CardItem(items: ["Cool"], color: Colors.yellow, textColor: Colors.red),
              CardItem(items: ["Cool"], color: Colors.yellow, textColor: Colors.red),
          ],
        ),
        SizedBox(height: 40,),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              CardItem(items: ["Cool"], color: Colors.yellow, textColor: Colors.red,),
              CardItem(items: ["Cool"], color: Colors.yellow, textColor: Colors.red),
          ],
        )
      ],
    );
  }

  Widget _profileSection(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            _editProfileImage(),
            SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.currentUserName),
                Text("Age of person", style: TextStyle(fontSize: 11, color: Color.fromARGB(255, 149, 149, 149))),
                SizedBox(height: 10,),
                InkWell(
                  onTap: () {},
                  child:Text("Change Profile", style: TextStyle(fontSize: 11, color: const Color.fromARGB(255, 44, 44, 44))),

                  ),
                  Container(color: Colors.black, height: 1, width: 85,)
              ],
            )
          ],
        ),
      ],
    );
  }
}

Widget _editProfileImage() {
  return Container(
    child: Stack(
      alignment: Alignment(1.5, 0),
      children: [
        Image.asset('assets/images/profileImage.png', fit: BoxFit.cover ,),
        Image.asset('assets/images/editImage.png')
      ],
    ),
  );
}
