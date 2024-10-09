import 'package:flutter/material.dart';

import 'onboardingScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    // Simulate a delay for the splash screen (you can replace this with actual data loading or other initializations)
    Future.delayed(Duration(seconds: 3), () {
      // Navigate to the home screen after the splash screen duration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  OnboardingScreen()),
      );
    });
    
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_screen.png'), // Replace with your image path
            fit: BoxFit.cover, // Adjust the fit property as needed
          ),
        ),
        // child: Center(
        //   child: FlutterLogo(size: 150, colors: Colors.white),
        // ),
      ),
    );
  }
}