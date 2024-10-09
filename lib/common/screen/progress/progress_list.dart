import 'package:flutter/material.dart';
import 'package:lettersnumbers/common/screen/home/home.dart';
import 'package:lettersnumbers/common/screen/misc-screen/thankyou.dart';
import 'package:lettersnumbers/common/widgets/starWidget.dart';

class ProgressStudentList extends StatefulWidget {
  const ProgressStudentList({super.key});

  @override
  State<ProgressStudentList> createState() => _ProgressStudentListState();
}

class _ProgressStudentListState extends State<ProgressStudentList> {
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
                      searchWidget(),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 10,
                         
                          itemBuilder: (context, index) {
                            return profileCard();
                          },
                        ),
                      )
                    ]))));
  }

  Widget profileCard() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 217, 232, 245)),
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
    );
  }

  Widget searchWidget() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },
            leading: const Icon(Icons.search),
            trailing: <Widget>[
              Tooltip(
                message: 'Change brightness mode',
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.person_search_outlined),
                  selectedIcon: const Icon(Icons.brightness_2_outlined),
                ),
              )
            ],
          );
        }, suggestionsBuilder:
                (BuildContext context, SearchController controller) {
          return List<ListTile>.generate(5, (int index) {
            final String item = 'item $index';
            return ListTile(
              title: Text(item),
              onTap: () {
                setState(() {
                  controller.closeView(item);
                });
              },
            );
          });
        }));
  }
}
