import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lettersnumbers/model/attendanceData.dart';
import 'package:lettersnumbers/model/reportData.dart';

class UserData {
  final String email;
  final String uid;
  final String userType;
  final String username;
  final String profileImage;
  final List<AttendanceModel> attendance;
  final List<Report> reports;


  UserData({
    required this.email,
    required this.uid,
    required this.userType,
    required this.username,
    required this.attendance,
    required this.reports,
    required this.profileImage

    
  });

  // Method to convert Firebase snapshot to UserData model
 factory UserData.fromDocumentSnapshot(DocumentSnapshot doc) {
  return UserData(
    profileImage: doc['profileImage'] ?? '',
    email: doc['email'] ?? '',
    uid: doc['uid'] ?? '',
    userType: doc['userType'] ?? '',
    username: doc['username'] ?? '',
    // Attendance handling as a list of maps
    attendance: (doc['attendance'] != null && (doc['attendance'] as List).isNotEmpty)
        ? (doc['attendance'] as List)
            .map((rep) => AttendanceModel.fromMap(rep as Map<String, dynamic>))
            .toList()
        : [],
    // Report handling as a list of maps
    reports: (doc['report'] != null && (doc['report'] as List).isNotEmpty)
        ? (doc['report'] as List)
            .map((rep) => Report.fromMap(rep as Map<String, dynamic>))
            .toList()
        : [],
  );
}


  // Method to convert UserData model to a Map
  Map<String, dynamic> toMap() {
    return {
      'profileImage': profileImage,
      'email': email,
      'uid': uid,
      'userType': userType,
      'username': username,
      'attendance': attendance.map((att) => att.toMap()).toList(),
      'report': reports.map((rep) => rep.toMap()).toList(),
    };
  }
}
