import 'package:flutter/material.dart';


class GalleryDetails extends StatelessWidget {
  const GalleryDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/images/dashboard.png'), // Replace with your image path
          fit: BoxFit.fill, // Adjust the fit property as needed
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
            // height: size.height * 0.6,
            children: [
              Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back_ios_new)),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset('assets/images/logout.png'),
                        ),
                      ],
                    ),
              SizedBox(height: 20,),
     
            Image.asset('assets/images/kids.jpg'),
            Text("Title of the image", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
            Text("A vibrant and joyful kids' farewell party featured lively \n decorations, fun activities, and a delightful spread of \n treats. The highlight was a heartfelt farewell ceremony with handmade cards and small gifts, capturing the essence of lasting friendships. The day ended with.")
          ],
        ),
      ),
    ),
    );
  }
}