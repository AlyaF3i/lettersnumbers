import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lettersnumbers/common/firebaseMethods/firebaseMethods.dart';
import 'package:lettersnumbers/common/screen/login/loginScreen.dart';
import 'package:lettersnumbers/common/widgets/button.dart';
import 'package:lettersnumbers/common/widgets/utilities.dart';

import '../../../model/sessionSingleton.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late Size size;
  bool isTeacher = false;
  bool isParent = false;

  String emailAddress = "";
  String password = "";
  String username = "";
  String userType = "";
  String profileImage = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.topCenter,
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/signup_screen.png'), // Replace with your image path
              fit: BoxFit.cover, // Adjust the fit property as needed
            ),
          ),
          child: Padding(
              padding: EdgeInsets.only(top: (size.height * 0.24)),
              child: SingleChildScrollView(child: signUpWidget())),
        ),
      ),
    );
  }

  Widget signUpWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: TextField(
                    onChanged: (value){
                      username = value;
                    },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "Enter Your Full Name"))),
              // TextField(decoration: InputDecoration(border: UnderlineInputBorder(), labelText: "Enter Email")),
              Image.asset('assets/images/people.png')
            ],
          ),
          // Divider(height: 10, color: Colors.grey,),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: TextField(
                      onChanged: (value) {
                        emailAddress = value;
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "Enter Email"))),
              Image.asset('assets/images/mail.png')
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: TextField(
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Enter Password"),
                obscureText: true,
              )),
              Image.asset('assets/images/show.png')
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                  child: TextField(
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Confirm Password"),
                obscureText: true,
              )),
              Image.asset('assets/images/show.png')
            ],
          ),
          Container(
            child: TextButton(
              onPressed: () {},
              child: Text(
                "Help?",
                textAlign: TextAlign.right,
              ),
            ),
            alignment: Alignment.centerRight,
          ),

          SizedBox(
            width: size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text("Your Account Type"),
                ),
                SizedBox(
                  width: size.width * 0.15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          // fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: isTeacher,
                          onChanged: (bool? value) {
                            setState(() {
                              isTeacher = value!;
                              isParent = false;
                            });
                            if(value!) {
                              userType = "Teacher";
                            }
                          },
                        ),
                        const Text("Teacher")
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          // fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: isParent,
                          onChanged: (bool? value) {
                            setState(() {
                              isParent = value!;
                              isTeacher = false;
                            });
                            if(value!) {
                              userType = "Parent";
                            }
                          },
                        ),
                        const Text("Parent")
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            alignment: Alignment.center,
            child: ButtonWidget(
              size: size,
              btnImage: 'assets/images/signup_button.png',
              destination: const LoginScreen(),
              function: () => signUpUser(emailAddress, password),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Row(
              children: [
                Text(
                  "Already have an account?",
                  textAlign: TextAlign.right,
                ),
                TextButton(
                  onPressed: () {
                     Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => (LoginScreen())));
                  },
                  child: Text(
                    "Login",
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
            alignment: Alignment.centerRight,
          ),
        ],
      ),
    );
  }

  Future<bool> signUpUser(String emailAddress, String password) async {
    bool signUpStatus = false;
    circularProgressIndicatorAlert(context);

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      signUpStatus = true;

      await FirebaseAuth.instance.currentUser!.updateDisplayName(username);
      await FirebaseMethods.saveUserData(emailAddress, username, userType, profileImage);
      await FirebaseMethods.fetchData();
      SessionSingleton().setUser(FirebaseAuth.instance.currentUser!);
      SessionSingleton().setUserType(userType);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    } finally{
    Navigator.pop(context);
  }

    return signUpStatus;
  }
}
