import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/attendanceData.dart';
import '../../model/newsData.dart';
import '../../model/reportData.dart';
import '../../model/sessionSingleton.dart';
import '../../model/userdata.dart';
import '../widgets/utilities.dart';

class FirebaseMethods {
  static Future<void> fetchData() async {
    DocumentSnapshot docData = await FirebaseFirestore.instance
        .collection('userData')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (docData.exists) {
      SessionSingleton().userData = UserData.fromDocumentSnapshot(docData);
      SessionSingleton().setUserType(SessionSingleton().userData.userType);

      if (SessionSingleton().isTeacher) {
        SessionSingleton().studentList =
            await FirebaseMethods.fetchUsersByType("Parent");
      } else {
        SessionSingleton().teacherList =
            await FirebaseMethods.fetchUsersByType("Teacher");
      }
    }
  }

  static Future<void> saveUserData(String email, String username,
      String userType, String profileImage) async {
    try {
      // Get the current user ID from Firebase signup authentication
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Reference to the "userData" collection and the document with the user ID
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('userData').doc(userId);

        // Create a map containing the user data
        Map<String, dynamic> userData = {
          'email': email,
          'username': username,
          'userType': userType,
          'uid': userId,
          'profileImage': profileImage,
          'attendance': [],
          'report': []
        };

        // Save the user data to Firestore
        await userDocRef.set(userData);

        print('User data saved successfully.');
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  static Future<void> saveStudentTeacherData(String email, String username,
      String userType, String profileImage) async {
    try {
      // Get the current user ID from Firebase signup authentication
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Reference to the "userData" collection and the document with the user ID
        String collectionName = userType == "Parent" ? "studentList" : "teacherList";
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection(collectionName).doc(userId);

        // Create a map containing the user data
        Map<String, dynamic> userData = {
          'email': email,
          'username': username,
          'userType': userType,
          'uid': userId,
          'profileImage': profileImage,
          'attendance': [],
          'report': []
        };

        // Save the user data to Firestore
        await userDocRef.set(userData);

        print('User data saved successfully.');
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  static Future<List<UserData>> fetchUsersByType(String userType) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('userData')
        .where('userType', isEqualTo: userType.toString().split('.').last)
        .get();

    List<UserData> users = querySnapshot.docs.map((doc) {
      // Parse the attendance list
      List<AttendanceModel> attendanceList = (doc['attendance'] as List<dynamic>).map((item) {
        return AttendanceModel.fromMap(item as Map<String, dynamic>);
      }).toList();

      // Parse the reports list
      List<Report> reportList = (doc['report'] as List<dynamic>).map((item) {
        return Report.fromMap(item as Map<String, dynamic>);
      }).toList();

      return UserData(
        username: doc['username'],
        email: doc['email'],
        userType: userType,
        uid: doc['uid'],
        attendance: attendanceList,
        reports: reportList,
        profileImage: '', // Add appropriate profileImage parsing if needed
      );
    }).toList();

    return users;
  } catch (e) {
    print('Error fetching users: $e');
    return [];
  }
}

  static Future<void> saveNewsUpdate(
      String newsUpdate, BuildContext context) async {
    String uid = SessionSingleton().sessionId;

    try {
      dynamic timeStamp = FieldValue.serverTimestamp();

      // Create a list of maps representing the news updates
      List<Map<String, dynamic>> updatesList = [
        {'newsUpdate': newsUpdate, 'timestamp': timeStamp, 'teacherId': uid}
      ];

      await FirebaseFirestore.instance
          .collection('news')
          .doc("newsUpdates")
          .set({
        'newsList': FieldValue.arrayUnion([
          {
            'newsUpdate': newsUpdate,
            'timestamp': DateTime.now().toString(),
            'teacherId': uid
          }
        ])
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('News update saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save news update: $e')),
      );
    }
  }

  static Future<List<NewsData>> fetchNews() async {
    try {
      // Fetch the document containing news updates
      DocumentSnapshot<Map<String, dynamic>> docData = await FirebaseFirestore
          .instance
          .collection('news')
          .doc('newsUpdates')
          .get();

      // Extract news updates from the document
      List<NewsData> newsUpdates =
          (docData.data()?['newsList'] as List<dynamic>).map((doc) {
        print(doc['timestamp'].toString());
        return NewsData(
          newsUpdate: doc['newsUpdate'] ?? '',
          newsTime: doc['timestamp'] ?? '',
          postedBy: doc['teacherId'] ?? '',
        );
      }).toList();

      return newsUpdates;
    } catch (e) {
      print('Error fetching news updates: $e');
      return [];
    }
  }

  static Future<void> saveAttendance(
      String teacherUid, DateTime date, List<String> studentIds) async {
    // Format the date as a string in yyyy-MM-dd format
    String dateString = DateFormat('yyyy-MM-dd').format(date);

    // Reference to the attendance collection
    CollectionReference attendanceCollection =
        FirebaseFirestore.instance.collection('attendance');

    // Reference to the document with teacherUid
    DocumentReference teacherDocRef = attendanceCollection.doc(teacherUid);

    // Get the current data of the document
    DocumentSnapshot teacherDoc = await teacherDocRef.get();

    // Check if the document exists
    if (teacherDoc.exists) {
      // Document exists, update the data

      // Get the current data as a map
      Map<String, dynamic> data = teacherDoc.data() as Map<String, dynamic>;

      // Get the list of student ids for the current date or create a new empty list
      List<String> studentIdsForDate =
          data[dateString] != null ? List<String>.from(data[dateString]) : [];

      // Add the new student ids to the list
      studentIdsForDate.addAll(studentIds);

      // Update the data with the new list of student ids
      data[dateString] = studentIdsForDate;

      // Update the document with the new data
      await teacherDocRef.update(data);
    } else {
      // Document doesn't exist, create a new document with the data

      // Create a new map with the date as key and the list of student ids as value
      Map<String, dynamic> data = {dateString: studentIds};

      // Set the data to the document
      await teacherDocRef.set(data);
    }
  }

static Future<void> updateAttendance(
    String status, String studentId, BuildContext context) async {
  String currentDate =
      "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
  circularProgressIndicatorAlert(context);

  try {
    // Fetch the current attendance data
    DocumentSnapshot studentDoc = await FirebaseFirestore.instance
        .collection('userData')
        .doc(studentId)
        .get();

    List<dynamic> attendanceList = studentDoc['attendance'] ?? [];

    // Flag to track if the date exists in the attendance
    bool dateExists = false;

    // Create a new list to hold the updated attendance
    List<Map<String, dynamic>> updatedAttendanceList = [];

    // Iterate over the existing attendance list
    for (var attendanceEntry in attendanceList) {
      // Check if the current date exists in the attendance record
      if (attendanceEntry.containsKey(currentDate)) {
        // If the current date is found, update the status and reset reasonOfAbsence
        updatedAttendanceList.add({
          currentDate: {
            'status': status,
            'reasonOfAbsence': '',
          }
        });
        dateExists = true;
      } else {
        // If not the current date, retain the existing record
        updatedAttendanceList.add(attendanceEntry);
      }
    }

    // If the date was not found, add a new attendance entry for the current date
    if (!dateExists) {
      updatedAttendanceList.add({
        currentDate: {
          'status': status,
          'reasonOfAbsence': '',
        }
      });
    }

    // Update the Firestore document with the updated attendance list
    await FirebaseFirestore.instance
        .collection('userData')
        .doc(studentId)
        .update({
      'attendance': updatedAttendanceList,
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Attendance marked successfully for today"),
      ),
    );
  } catch (error) {
    // Show error message if something goes wrong
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Failed to mark attendance: $error"),
      ),
    );
  } finally {
    // Remove progress indicator
    Navigator.pop(context);
  }
}


  static Future<void> updateReport(String reportUrl, String reportTitle,
      String studentId, BuildContext context) async {
    String currentDate =
        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
    circularProgressIndicatorAlert(context);

    try {
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(studentId)
          .update({
        'Report': FieldValue.arrayUnion([
          {'${currentDate}': reportUrl, 'reportTitle': reportTitle}
        ])
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("New Report successfully uploaded"),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to upload report: $error"),
        ),
      );
    } finally {
      Navigator.pop(context);
    }
  }
}
