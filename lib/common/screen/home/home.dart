import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lettersnumbers/common/messageScreen.dart';
import 'package:lettersnumbers/model/sessionSingleton.dart';
import 'package:lettersnumbers/student/followUp/dailyReport.dart';
import 'package:lettersnumbers/student/gallery/gallery.dart';
import 'package:lettersnumbers/common/screen/home/dashboard.dart';
import 'package:lettersnumbers/common/screen/profile/profile_screen.dart';

import 'package:lettersnumbers/common/messageScreen.dart';
import 'package:lettersnumbers/teacher/dailyReportPage/dailyReportPage.dart';

import '../../../teacher/userList/participantList.dart';



class HomeScreen extends StatefulWidget {
   HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreeneState();
}

class _HomeScreeneState
    extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[];


  

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  _widgetOptions = [
    const DashboardScreen(),
    const GalleryScreen(),
    ChatScreen(callback: _onItemTapped),
    SessionSingleton().isTeacher ? ParticipantList(isAttendaceList: true, isDailyReportList: true,)  : DailyReportViewPage(studentId: SessionSingleton().userData),
    const ProfileScreen()
 
  ];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
       bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, color: Colors.grey,),
            label: 'Home',
            activeIcon: Icon(Icons.home_outlined, color: Colors.black,),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image_outlined, color: Colors.grey,),
            label: 'Gallery',
            activeIcon: Icon(Icons.image_outlined, color: Colors.black,),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined, color: Colors.grey,),
            label: 'Message',
            activeIcon: Icon(Icons.message_outlined, color: Colors.black,),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books, color: Colors.grey,),
            label: 'Record',
            activeIcon: Icon(Icons.library_books, color: Colors.black,),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: Colors.grey,),
            label: 'Profile',
            activeIcon: Icon(Icons.person_outline, color: Colors.black,),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
