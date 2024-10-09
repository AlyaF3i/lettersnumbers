import 'package:flutter/material.dart';
import 'package:lettersnumbers/model/sessionSingleton.dart';
import 'package:lettersnumbers/common/screen/progress/progress_screen.dart';
import 'package:lettersnumbers/student/studentAttendance/attendance.dart';
import 'package:lettersnumbers/teacher/dailyReportPage/dailyReportPage.dart';

import '../../model/userdata.dart';
import '../../common/screen/Attendence/attendence.dart';

class ParticipantList extends StatefulWidget {
  const ParticipantList({super.key, required this.isAttendaceList, this.isDailyReportList = false});

  final bool isAttendaceList;
  final bool isDailyReportList;

  @override
  State<ParticipantList> createState() => _ParticipantListState();
}

class _ParticipantListState extends State<ParticipantList> {

  bool isTeacher = false;
  late List<UserData> userList;

  @override
  void initState() {
    super.initState();
    isTeacher = SessionSingleton().isTeacher;
    userList = isTeacher ? SessionSingleton().studentList : SessionSingleton().teacherList;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.isDailyReportList == false,
        title: Text('Student List'),
      ), 
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(userList[index].profileImage),
            ),
            title: Text(userList[index].username),
            subtitle: Text(userList[index].email),
            onTap: () {
              // Handle tap on student item
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  widget.isDailyReportList ? DailyReportPage(studentId: userList[index]): widget.isAttendaceList ? AttendanceScreen(student: userList[index],) :  ProgressScreen(student: userList[index])));
            },
          );
        },
      ),
    );
  }
}