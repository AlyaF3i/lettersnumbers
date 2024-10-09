import 'package:flutter/material.dart';
import 'package:lettersnumbers/common/screen/home/home.dart';
import 'package:lettersnumbers/common/widgets/button.dart';

class ThankyouScreen extends StatefulWidget {
  const ThankyouScreen({super.key});

  @override
  State<ThankyouScreen> createState() => __ThankyouStateState();
}

class __ThankyouStateState extends State<ThankyouScreen> {
    late Size size;

  @override
  Widget build(BuildContext context) {
        size = MediaQuery.of(context).size; 

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          
          children: [
            Image.asset("assets/images/query.png", width: size.width, fit: BoxFit.cover,),
            Text("Thankyou!", style: TextStyle(color: Color.fromARGB(255, 180, 0, 60), fontSize: 19),),
            Text("Your query is submissted successfully"),
            Text("You will be notified shortly via Email"),
            SizedBox(height: 20,),
          // Container(width: 180, child:  ButtonWidget(size: size, btnImage: "assets/images/goback.png", destination: HomeScreen()))

          ],
        ),
      ),
    );
  }
}