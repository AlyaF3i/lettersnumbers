import 'package:flutter/material.dart';
import 'package:lettersnumbers/student/gallery/galleryDetails.dart';

import '../../common/widgets/captionImage.dart';
import 'photoListScreen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  late Size size;
  List<String> items = List<String>.generate(100, (index) => "Item $index");

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/images/dashboard.png'), // Replace with your image path
          fit: BoxFit.fill, // Adjust the fit property as needed
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
        child: Column(
            // height: size.height * 0.6,
            children: [
              Row(
                      mainAxisAlignment: MainAxisAlignment.end,
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
              Text("Gallery", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

              Expanded(
                child: GalleryList()
              ),
            ]),
      ),
    ));
  }

  
}
