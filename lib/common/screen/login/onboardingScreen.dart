import 'package:flutter/material.dart';
import 'package:lettersnumbers/common/screen/login/loginScreen.dart';
import 'package:lettersnumbers/common/screen/login/onboardingGrowScreen.dart';
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  var size;
  @override
  void initState() {
    super.initState();

    // // Simulate a delay for the splash screen (you can replace this with actual data loading or other initializations)
    // Future.delayed(Duration(seconds: 3), () {
    //   // Navigate to the home screen after the splash screen duration
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) =>  OnboardingscreenWidget()),
    //   );
    // });
    
  }

 @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size; 
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/onboarding_screen.png'), // Replace with your image path
            fit: BoxFit.cover, // Adjust the fit property as needed
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OnboardingGrowScreen())
                );
                print("continue pressed");
              },
              child: Container(
                width: size.width * 0.5,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/continue_button.png'),
                    fit: BoxFit.cover
                  )
                ),
                ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: TextButton(
                onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen())
                );
              }, child: const Text("Skip", style: TextStyle(fontSize: 20))),
            )
          ],
        )
      ),
    );
  }
}