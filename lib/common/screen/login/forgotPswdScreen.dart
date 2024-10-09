import 'package:flutter/material.dart';
import 'package:lettersnumbers/common/screen/home/dashboard.dart';
import 'package:lettersnumbers/common/screen/login/loginScreen.dart';
import 'package:lettersnumbers/common/widgets/button.dart';

import 'onboardingScreen.dart';
import 'signUpScreen.dart';

class ForgotPswdScreen extends StatefulWidget {
  const ForgotPswdScreen({super.key});

  @override
  State<ForgotPswdScreen> createState() => _ForgotPswdScreenState();
}

class _ForgotPswdScreenState extends State<ForgotPswdScreen> {
  late Size size;

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
              image: AssetImage('assets/images/forgotpswd_screen.png'), // Replace with your image path
              fit: BoxFit.cover, // Adjust the fit property as needed
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: (size.height * 0.4)),
            child: LoginWidget()
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
              Flexible(child: TextField(decoration: InputDecoration(border: UnderlineInputBorder(), labelText: "Enter Your Email address for contact"))),
              // TextField(decoration: InputDecoration(border: UnderlineInputBorder(), labelText: "Enter Email")),
              Image.asset('assets/images/mail.png')
            ],
          ),
          // Divider(height: 10, color: Colors.grey,),
          SizedBox(height: 15,),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: TextField(decoration: InputDecoration(border: UnderlineInputBorder(), labelText: "Enter your query"))),
              // TextField(decoration: InputDecoration(border: UnderlineInputBorder(), labelText: "Enter Email")),
            ],
          ),
          Container(child: TextButton(onPressed: (){}, child: const Text("Help?", textAlign: TextAlign.right,),), alignment: Alignment.centerRight,),
          // Container(child: ButtonWidget(size: size, btnImage: 'assets/images/login_button.png', destination: LoginScreen(),), alignment: Alignment.center,),
          SizedBox(height: 15,),
          Container(child: Row(
            children: [
              Text("Proceed back to?", textAlign: TextAlign.right,),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => (LoginScreen())));
              }, child: Text("Login", textAlign: TextAlign.right,),)
            ],
          ), alignment: Alignment.centerRight,),

        ],
      ),
    );

  }
}