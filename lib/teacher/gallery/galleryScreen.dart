import 'package:flutter/material.dart';
import 'package:lettersnumbers/teacher/galleryUpdate/imageUpload.dart';
import 'package:lettersnumbers/teacher/newsUpdate/newsUpdate.dart';
import 'package:lettersnumbers/student/gallery/galleryDetails.dart';
import '../../student/gallery/photoListScreen.dart';

class AdminGalleryScreen extends StatefulWidget {
  const AdminGalleryScreen({super.key});

  @override
  State<AdminGalleryScreen> createState() => _AdminGalleryScreenState();
}

class _AdminGalleryScreenState extends State<AdminGalleryScreen> {
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                InkWell(
                  child: Card(
                    color: const Color.fromARGB(255, 136, 230, 140),
                    child: Container(
                      alignment: Alignment.center,
                      width: size.width * .35,
                      height: 30,
                      child: Text("News Updates"),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NewsUpdatePage()));
                  },
                ),
                InkWell(
                  child: Card(
                    color: Color.fromARGB(255, 174, 217, 243),
                    child: Container(
                      alignment: Alignment.center,
                      width: size.width * .35,
                      height: 30,
                      child: Text("Gallery Photos"),
                    ),
                  ),
                  onTap: () {},
                ),
                InkWell(
                  child: Container(
                      height: 30,
                      width: 30,
                      child: Image.asset(
                        'assets/images/plus.png',
                        scale: 1,
                      )),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ImageUpload()));
                  },
                ),
              ]),
              Expanded(
                child: false ? GalleryDetails() : GalleryList()
              ),
            ]),
      ),
    ));
  }

  
}
