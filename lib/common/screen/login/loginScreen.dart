import 'package:flutter/material.dart';
import 'package:lettersnumbers/common/widgets/customAlert.dart';
import 'package:lettersnumbers/model/sessionSingleton.dart';
import 'package:lettersnumbers/common/firebaseMethods/firebaseMethods.dart';
import 'package:lettersnumbers/common/screen/home/home.dart';
import 'package:lettersnumbers/common/screen/login/forgotPswdScreen.dart';
import 'package:lettersnumbers/common/widgets/button.dart';
import 'package:lettersnumbers/common/widgets/utilities.dart';
import 'signUpScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Size size;
  String emailAddress = "";
  String password = "";
  bool loginInProgress = false;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: loginInProgress
            ? Center(child: CircularProgressIndicator()) // Show loading indicator while logging in
            : Container(
                alignment: Alignment.topCenter,
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/loginscreen.png'), // Replace with your image path
                    fit: BoxFit.cover, // Adjust the fit property as needed
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: (size.height * 0.24)),
                  child: LoginWidget(),
                ),
              ),
      ),
    );
  }

  Widget LoginWidget() {
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
                      onChanged: (value) => emailAddress = value,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "Enter Email"))),
              Image.asset('assets/images/mail.png')
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: TextField(
                      onChanged: (value) => password = value,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "Enter Password"))),
              Image.asset('assets/images/show.png')
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => (ForgotPswdScreen())));
              },
              child: const Text(
                "Forgot Password?",
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: ButtonWidget(
              size: size,
              btnImage: 'assets/images/login_button.png',
              destination: HomeScreen(),
              function: () => loginUser(emailAddress, password),
            ),
          ),
          SizedBox(height: 15),
          Container(
            alignment: Alignment.centerRight,
            child: Row(
              children: [
                Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => (SignUpScreen())));
                  },
                  child: Text("Signup"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> loginUser(String emailAddress, String password) async {
    setState(() {
      loginInProgress = true; // Start login process
    });

    var loginStatus = false;
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress, password: password);
      SessionSingleton().setUser(FirebaseAuth.instance.currentUser!);
      await FirebaseMethods.fetchData();
      loginStatus = true;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showAlert(context, "No user found for this email.", "Invalid Email");
      } else if (e.code == 'wrong-password') {
        showAlert(context, "Incorrect password.", "Invalid Password");
      } else {
        showAlert(context, "Login failed. Please try again.", "Error");
      }
    } finally {
      setState(() {
        loginInProgress = false; // Stop login process
      });
    }
    return loginStatus;
  }

  // Method to show an alert dialog
  void showAlert(BuildContext context, String message, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
