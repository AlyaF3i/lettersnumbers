import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lettersnumbers/common/firebaseMethods/firebaseMethods.dart';
import 'package:lettersnumbers/model/userdata.dart';
import 'package:lettersnumbers/common/screen/home/home.dart';
import 'package:lettersnumbers/common/screen/misc-screen/thankyou.dart';
import 'package:lettersnumbers/common/widgets/starWidget.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key, required this.student});
  final UserData student;
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {

 late UserData newStudent;
  late bool attendanceMarked;
late List<double> attendanceData =
      List.filled(12, 0.0);
    String currentPercentage = "";

  @override
  void initState() {
    super.initState();
    newStudent = widget.student;
    attendanceMarked = false;
    _fetchAttendanceData();
  }

  Future<void> _fetchAttendanceData() async {
    try {
      final documentId =
         "${newStudent.uid}_${DateTime.now().year}"; // Combine student ID and current year

      final snapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .doc(documentId)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data()!;
        List<double> newAttendanceData = List.filled(12, 0.0);

        // Assuming that Firebase stores the percentage keyed by month names or indexes
        for (int monthIndex = 0; monthIndex < 12; monthIndex++) {
          String monthKey =
              (monthIndex + 1).toString(); // Months as '1', '2', ..., '12'
          if (data.containsKey(monthKey)) {
            newAttendanceData[monthIndex] = data[monthKey]?.toDouble() ?? 0.0;
          }
        }

        setState(() {
          attendanceData = newAttendanceData;
          currentPercentage = newAttendanceData[DateTime.now().month - 1].toString();

        });
      }
    } catch (e) {
      print('Error fetching attendance data: $e');
    }
  }


  late String dropDownValue;
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/dashboard.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 20),
              _buildProfile(),
              const SizedBox(height: 10),
              Text(DateFormat('MMMM d yyyy').format(DateTime.now())),
              const SizedBox(height: 20),
               Text( "$currentPercentage % Attendance of current month", // Subtract 1 because month is 1-based (Jan is 1, but index is 0)
                style: TextStyle(color: Colors.green, fontSize: 15),
              ),
              const SizedBox(height: 10),

                SizedBox(
                  height: 300,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: size.width * 1.5,
                      child: BarChart(
                        BarChartData(
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  // Y-axis percentage labels
                                  return Text(
                                    '${value.toInt()}%', // Convert value to percentage
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  );
                                },
                                interval:
                                    20, // Interval for y-axis labels (0%, 20%, 40%, ...)
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  const monthNames = [
                                    'Jan',
                                    'Feb',
                                    'Mar',
                                    'Apr',
                                    'May',
                                    'Jun',
                                    'Jul',
                                    'Aug',
                                    'Sep',
                                    'Oct',
                                    'Nov',
                                    'Dec'
                                  ];
                                  return Text(monthNames[value.toInt()]);
                                },
                              ),
                            ),
                          ),
                          maxY: 100, // Maximum Y value for percentage
                          minY: 0, // Minimum Y value for percentage
                          barGroups: List.generate(12, (index) {
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: attendanceData[
                                      index], // Set percentage for each month
                                  color: attendanceData[index] > 0
                                      ? Colors.blue
                                      : Colors.red,
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              _buildMotivationalText(),
              const SizedBox(height: 20),
              const Text(
                "Mark Attendance",
                style: TextStyle(
                    color: Color.fromARGB(255, 102, 181, 245), fontSize: 20),
              ),
              const SizedBox(height: 20),
              _buildAttendanceButtons(),
            ],
          ),
        ),
      ),
    ));
  }

  Row _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset('assets/images/logout.png'),
        ),
      ],
    );
  }

  Row _buildProfile() {
    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: Color.fromARGB(255, 217, 232, 245)),
          width: 50,
          height: 50,
          child: Image.asset(
            "assets/images/profileImage.png",
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(newStudent.username),
      ],
    );
  }

  Widget _buildMotivationalText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Mastering the art of punctuality:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Text(
            "A student who values every second as a step towards success."),
      ],
    );
  }

  Widget _buildAttendanceButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          child: Card(
            color: attendanceMarked
                ? Colors.grey
                : const Color.fromARGB(255, 136, 230, 140),
            child: Container(
              alignment: Alignment.center,
              width: size.width * .35,
              height: 30,
              child: const Text("Present"),
            ),
          ),
          onTap: () async {
            await FirebaseMethods.updateAttendance(
                "Present", newStudent.uid, context);
            setState(() {
              attendanceMarked = true;
            });
          },
        ),
        InkWell(
          child: Card(
            color: attendanceMarked
                ? Colors.grey
                : const Color.fromARGB(255, 174, 217, 243),
            child: Container(
              alignment: Alignment.center,
              width: size.width * .35,
              height: 30,
              child: const Text("Absent"),
            ),
          ),
          onTap: () async {
            await FirebaseMethods.updateAttendance(
                "Absent", newStudent.uid, context);
            setState(() {
              attendanceMarked = true;
            });
          },
        ),
      ],
    );
  }
}
