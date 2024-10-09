import 'package:firebase_auth/firebase_auth.dart';
import 'package:lettersnumbers/model/userdata.dart';

class SessionSingleton {
  late String sessionId;
  late String currentUserName;
  late String userEmail;
  late UserData userData;
  late UserData currentUser;
  bool isTeacher = false;
  late bool isAdmin;
  List<UserData> studentList = [];
  List<UserData> teacherList = [];

  static final SessionSingleton _instance = SessionSingleton._internal();

  factory SessionSingleton() {
    if (_instance == null) {
      _instance.sessionId = "";
      _instance.userEmail = "";
      _instance.currentUserName = "";
      _instance.isTeacher = false;
      _instance.isAdmin = false;
    }
   
    return _instance;
  }

  SessionSingleton._internal();

  void setUser(User user) {

    sessionId = user.uid;
    currentUserName = user.displayName ?? "";
    userEmail = user.email ?? "";
    userData = UserData(username: "", email: "", userType: "Parent", uid: user.uid, reports: [], attendance: [], profileImage: '');
    // You can add more profile details here if needed
  }

  void clearData() {
    sessionId = "";
    userEmail = "";
    currentUserName = "";
    isTeacher = false;
    isAdmin = false;
    userData = UserData(username: "", email: "", userType: "", uid: "", reports: [], attendance: [], profileImage: '');
  }

  void setUserType(String userType) {
    isTeacher = (userType == "Teacher");
  }

  void setStudentList(List<UserData> studentList) {
    this.studentList = studentList;
  }

  void setTeacherList(List<UserData> teacherList) {
    this.teacherList = teacherList;
  }

  String getUserId() {
    return sessionId;
  }

  String getUserName() {
    return currentUserName;
  }

  String getUserEmail() {
    return userEmail;
  }
}

// Example usage:

// Set user details after login
void setUserDetails(User user) {
  SessionSingleton().setUser(user);
}

// Access user ID throughout the app
String getUserId() {
  return SessionSingleton().getUserId();
}

// Access user name throughout the app
String getUserName() {
  return SessionSingleton().getUserName();
}

// Access user email throughout the app
String getUserEmail() {
  return SessionSingleton().getUserEmail();
}
