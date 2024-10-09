import 'package:flutter/material.dart';
import 'package:lettersnumbers/common/screen/home/home.dart';
import 'package:lettersnumbers/common/screen/misc-screen/thankyou.dart';
import 'package:lettersnumbers/model/sessionSingleton.dart';
import 'package:lettersnumbers/teacher/clinicForm.dart';
import 'package:lettersnumbers/common/widgets/starWidget.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropDownValue = status.first;
  }

  late String dropDownValue;
  late Size size;
  List<String> status = ["Cool", "Happy", "Joily", "Super"];
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
            child: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.only(top: 60, left: 20, right: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color.fromARGB(
                                          255, 217, 232, 245)),
                                  width: 50,
                                  height: 50,
                                  child: Image.asset(
                                    "assets/images/profileImage.png",
                                    fit: BoxFit.fill,
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Jerry John")
                            ],
                          ),
                           SizedBox(
                            height: 20,
                          ),
                          Container(
                              alignment: Alignment.topLeft,
                              child: Image.asset("assets/images/fitness.png")),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                              alignment: Alignment.topLeft,
                              child:
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(context,MaterialPageRoute(
                                    builder: (context) =>  ClinicForm(student: SessionSingleton().userData)));
                                    },
                                    child: Image.asset("assets/images/heartRate.png"))
                                  ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Prioritize wellness::",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              "Your body is your most valuable asset, invest in its health today for a vibrant tomorrow."),
                          SizedBox(
                            height: 20,
                          ),
                        ])))));
  }
}
