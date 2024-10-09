import 'package:flutter/material.dart';
import 'package:lettersnumbers/student/gallery/galleryDetails.dart';

import '../../common/widgets/captionImage.dart';

class GalleryList extends StatelessWidget {
  GalleryList({super.key});

  late Size size;
  List<String> items = List<String>.generate(100, (index) => "Item $index");

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return  Container(
                      child: Center(
                        child: InkWell(
                          onTap: (){ 
                            Navigator.push(context, MaterialPageRoute(builder: (context) => GalleryDetails()));
                          },
                          child: CaptionImage(
                            imageName: 'assets/images/kids.jpg',
                            caption: items[index],
                            width: size.width,
                          ),
                        ),
                      ),
                      width: 100,
                      height: 250,
                      margin: EdgeInsets.only(bottom: 10),
                    );
                  },
                );  
  }
}