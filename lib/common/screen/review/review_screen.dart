import 'package:flutter/material.dart';
import 'package:lettersnumbers/common/screen/home/home.dart';
import 'package:lettersnumbers/common/screen/misc-screen/thankyou.dart';
import 'package:lettersnumbers/common/widgets/starWidget.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
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
                  child: Column(children: [
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
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Reviews & Ratings",
                          style: TextStyle(fontSize: 30),
                        )),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 141, 213, 144),
                  
                      ),
                      width: size.width,
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButton(
                      isExpanded: true,
                      icon: Icon(Icons.keyboard_arrow_down),
                      value: dropDownValue,
                      dropdownColor: Color.fromARGB(255, 141, 213, 144),
                        items: status.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (changed) {
                          setState(() {
                            dropDownValue = changed ?? "";
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 30,),
                    Container(
                       decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 181, 233, 240),
                    
                      ),
                      padding: EdgeInsets.all(10),
                      width: size.width,
                      height: 200,
                      child:  TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Give feedback on daycare"
                          ),
                        
                        maxLines: null,
                        cursorColor: Colors.green,
                        
                      )
                    ),
                    SizedBox(height: 20,),
                        Container(
                          alignment: Alignment.topLeft,
                          height: 30,
                          width: size.width,
                          child:  Row(
                            children: [
                              
                              StarWidget(),
                              StarWidget(),
                              StarWidget(),
                              StarWidget(),
                              StarWidget(),
                            ],
                          ),
                        ),
                                      
                            InkWell(
                              onTap: (){
                                print("Submit pressed");
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => (ThankyouScreen())));

                              },
                              child: Container(
                              alignment: Alignment.topLeft,
                              
                              child: Container(
                                decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                                                        color: Color.fromARGB(255, 141, 213, 144),
                                                  
                                                        ),
                                alignment: Alignment.center,
                                height: 30,
                                width: 100,
                                child: Text("Submit"),
                              ),
                                                    ),
                            ),
                          Image.asset("assets/images/womenreview.png", width: size.width, height: 200,)                  
                  ]),
                ))));
  }
}
