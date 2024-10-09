import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lettersnumbers/model/userdata.dart';
import 'package:lettersnumbers/common/screen/Attendence/attendence.dart';
import 'package:lettersnumbers/teacher/gallery/galleryScreen.dart';
import 'package:lettersnumbers/common/firebaseMethods/firebaseMethods.dart';
import 'package:lettersnumbers/model/newsData.dart';
import 'package:lettersnumbers/model/sessionSingleton.dart';
import 'package:lettersnumbers/student/gallery/gallery.dart';
import 'package:lettersnumbers/common/screen/health/health.dart';
import 'package:lettersnumbers/common/screen/progress/progress_list.dart';
import 'package:lettersnumbers/common/screen/progress/progress_screen.dart';
import 'package:lettersnumbers/common/screen/review/review_screen.dart';
import 'package:lettersnumbers/teacher/userList/participantList.dart';

import '../../../student/studentAttendance/attendance.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late SessionSingleton userdata;
  late String attendance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNews();
     
  }
  late List<NewsData> newsList = [];

  Future<void> fetchNews() async {
    List<NewsData> news = await FirebaseMethods.fetchNews();
    setState(() {
      newsList = news;
    });

    print(SessionSingleton().studentList);
  }

  late Size size;


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
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
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      SessionSingleton().clearData();
                      Navigator.pop(context);
                    },
                    child: Image.asset('assets/images/logout.png'),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Dashboard",
                      style: TextStyle(fontSize: 30),
                    )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: size.height * 0.2,
                      width: size.width,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/news.png'), // Replace with your image path
                          fit: BoxFit.fill, // Adjust the fit property as needed
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("NEWS UPDATE", style: TextStyle(fontSize: 20),),
                            SizedBox(height: 20,),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: newsList.map((news) {
                                  return Container(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      children: [

                                      Text(news.newsUpdate),
                                      SizedBox(height: 10,),
                                      Text(news.newsTime, style: TextStyle(fontSize: 10),)
                                    ],),
                                  );
                                  
                                }).toList()
            
                              ),

                              )
                               
                            
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SessionSingleton().isTeacher ? const ParticipantList(isAttendaceList: true,) :  StudentAttendanceScreen(student:  SessionSingleton().userData as UserData)));
                          },
                          child: Container(
                            height: size.height * 0.15,
                            width: size.width * 0.42,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/attendance.png'), // Replace with your image path
                                fit: BoxFit
                                    .fill, // Adjust the fit property as needed
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Attendance",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                      SessionSingleton().isTeacher
                                          ? "Take Attendance"
                                          : "View Attendance",
                                      style: TextStyle(fontSize: 12))
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  SessionSingleton().isTeacher ? AdminGalleryScreen() : GalleryScreen()));
                          },
                          child: Container(
                            height: size.height * 0.15,
                            width: size.width * 0.42,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/gallery.png'), // Replace with your image path
                                fit: BoxFit
                                    .fill, // Adjust the fit property as needed
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Gallery",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                      SessionSingleton().isTeacher
                                          ? "Upload Moments"
                                          : "View Moments",
                                      style: TextStyle(fontSize: 12))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: size.height * 0.15,
                          width: size.width * 0.42,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/messaging.png'), // Replace with your image path
                              fit: BoxFit
                                  .fill, // Adjust the fit property as needed
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Messaging",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                    SessionSingleton().isTeacher
                                        ? "Contact students"
                                        : "Contact Teacher",
                                    style: TextStyle(fontSize: 12))
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                         SessionSingleton().isTeacher ? const ParticipantList(isAttendaceList: false,) :  ProgressScreen(student: SessionSingleton().userData as UserData)));

                              },
                              child: Container(
                                height: size.height * 0.07,
                                width: size.width * 0.42,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/progress.png'), // Replace with your image path
                                    fit: BoxFit
                                        .fill, // Adjust the fit property as needed
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Progress",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                          SessionSingleton().isTeacher
                                              ? "Update Progress"
                                              : "Track Progress",
                                          style: TextStyle(fontSize: 10))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HealthScreen()));
                              },
                              child: Container(
                                height: size.height * 0.07,
                                width: size.width * 0.42,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/health.png'), // Replace with your image path
                                    fit: BoxFit
                                        .fill, // Adjust the fit property as needed
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Health Records",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                          SessionSingleton().isTeacher
                                              ? "Update Health"
                                              : "Track Health",
                                          style: TextStyle(fontSize: 10))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => (ReviewScreen())));
                      },
                      child: Container(
                        height: size.height * 0.15,
                        width: size.width,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/review_rating.png'), // Replace with your image path
                            fit: BoxFit
                                .fill, // Adjust the fit property as needed
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30, left: 20),
                          child: Column(
                            children: [
                              Text(
                                "Reviews & Ratings",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              Text("Submit Valuable Reviews",
                                  style: TextStyle(fontSize: 12))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
