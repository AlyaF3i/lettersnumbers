import 'package:flutter/material.dart';

class CaptionImage extends StatelessWidget {
   CaptionImage(
      {super.key, required this.imageName, required this.caption, required this.width});
  
  final String imageName;
  final String caption;
  
 final double width;

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
           shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
          elevation: 10,
          child: Image.asset(
            imageName, height: 200, width: width,
            fit: BoxFit.fill,
            ), 
        ),
        SizedBox(height: 10),
        Text("Kids having fun")
      ],
    );
  }
}
