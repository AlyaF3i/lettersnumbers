import 'package:flutter/material.dart';

class StarWidget extends StatelessWidget {
  const StarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 30,
      decoration: BoxDecoration(
        image:  DecorationImage(
            
            image: AssetImage("assets/images/star.png"),
            fit: BoxFit.contain, // Adjust the fit property as needed
          ),
      ),
    );
  }
}