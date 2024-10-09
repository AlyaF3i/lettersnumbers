import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lettersnumbers/common/firebaseMethods/firebaseMethods.dart';
import 'package:lettersnumbers/model/attendanceData.dart';
import 'package:lettersnumbers/model/userdata.dart';
import 'package:lettersnumbers/common/screen/home/home.dart';
import 'package:lettersnumbers/common/screen/misc-screen/thankyou.dart';
import 'package:lettersnumbers/common/widgets/starWidget.dart';
import 'package:intl/intl.dart';

import '../../common/widgets/utilities.dart';

class StudentAttendanceScreen extends StatefulWidget {
  const StudentAttendanceScreen({super.key, required this.student});
  final UserData student;
  @override
  State<StudentAttendanceScreen> createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  late UserData newStudent;
  late bool attendanceMarked;
  late List<double> attendanceData = List.filled(12, 0.0);
  late List<AttendanceModel> attendanceRecord;
  final ScrollController _scrollController = ScrollController();
  final Map<String, TextEditingController> absenceControllers = {};
  late int currentDay;
  String currentPercentage = "";

  @override
  void initState() {
    super.initState();
    newStudent = widget.student;
    attendanceMarked = false;
    _fetchAttendanceData();
    _scrollToCurrentDate();
    currentDay = DateTime.now().day;
    attendanceRecord = newStudent.attendance;
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
          currentPercentage =
              newAttendanceData[DateTime.now().month - 1].toString();
        });

        print(newAttendanceData);
      }
    } catch (e) {
      print('Error fetching attendance data: $e');
    }
  }

  void _scrollToCurrentDate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        (currentDay - 1) * 60.0, // Assume each item has a width of 60
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> updateAbsenceReason(
      String status, String studentId, BuildContext context) async {
    String currentDate =
        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
    circularProgressIndicatorAlert(context);

    try {
      // Fetch the current attendance data
      DocumentSnapshot studentDoc = await FirebaseFirestore.instance
          .collection('userData')
          .doc(studentId)
          .get();

      List<dynamic> attendanceList = studentDoc['attendance'] ?? [];

      // Flag to track if the date exists in the attendance
      bool dateExists = false;

      // Create a new list to hold the updated attendance
      List<Map<String, dynamic>> updatedAttendanceList = [];

      // Iterate over the existing attendance list
      for (var attendanceEntry in attendanceList) {
        // Check if the current date exists in the attendance record
        if (attendanceEntry.containsKey(currentDate)) {
          // If the current date is found, update the status and reset reasonOfAbsence
          updatedAttendanceList.add({
            currentDate: {
              'status': status,
              'reasonOfAbsence': '',
            }
          });
          dateExists = true;
        } else {
          // If not the current date, retain the existing record
          updatedAttendanceList.add(attendanceEntry);
        }
      }

      // If the date was not found, add a new attendance entry for the current date
      if (!dateExists) {
        updatedAttendanceList.add({
          currentDate: {
            'status': status,
            'reasonOfAbsence': '',
          }
        });
      }

      // Update the Firestore document with the updated attendance list
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(studentId)
          .update({
        'attendance': updatedAttendanceList,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Attendance marked successfully for today"),
        ),
      );
    } catch (error) {
      // Show error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to mark attendance: $error"),
        ),
      );
    } finally {
      // Remove progress indicator
      Navigator.pop(context);
    }
  }

  Future<void> updateReasonOfAbsence(
      String date, String reasonOfAbsence, BuildContext context) async {
    circularProgressIndicatorAlert(context);

    String studentId = newStudent.uid;

    try {
      // Fetch the current attendance data
      DocumentSnapshot studentDoc = await FirebaseFirestore.instance
          .collection('userData')
          .doc(studentId)
          .get();

      List<dynamic> attendanceList = studentDoc['attendance'] ?? [];

      // Flag to track if the date exists in the attendance
      bool dateExists = false;

      // Create a new list to hold the updated attendance
      List<Map<String, dynamic>> updatedAttendanceList = [];

      // Iterate over the existing attendance list
      for (var attendanceEntry in attendanceList) {
        // Check if the date exists in the attendance record
        if (attendanceEntry.containsKey(date)) {
          // If the date is found, update the reasonOfAbsence, retain the status
          updatedAttendanceList.add({
            date: {
              'status': attendanceEntry[date]
                  ['status'], // Retain the current status
              'reasonOfAbsence': reasonOfAbsence, // Update the reasonOfAbsence
            }
          });
          dateExists = true;
        } else {
          // If not the given date, retain the existing record
          updatedAttendanceList.add(attendanceEntry);
        }
      }

      // If the date was not found, show an error message
      if (!dateExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No attendance record found for the date: $date."),
          ),
        );
      } else {
        // Update the Firestore document with the updated attendance list
        await FirebaseFirestore.instance
            .collection('userData')
            .doc(studentId)
            .update({
          'attendance': updatedAttendanceList,
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Reason of absence updated successfully for $date"),
          ),
        );
      }
    } catch (error) {
      // Show error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update reason of absence: $error"),
        ),
      );
    } finally {
      // Remove progress indicator
      Navigator.pop(context);
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
              Text(
                "$currentPercentage % Attendance of current month", // Subtract 1 because month is 1-based (Jan is 1, but index is 0)
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
                              getTitlesWidget: (double value, TitleMeta meta) {
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
              // Horizontal scroll for daily attendance
              SizedBox(
                height: 150,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: attendanceRecord
                      .length, // Assuming max 30 days in a month
                  itemBuilder: (context, index) {
                    final date = attendanceRecord[index].date;
                    final attendanceStatus = attendanceRecord[index].status;
                    final reasonOfAbsence =
                        attendanceRecord[index].reasonOfAbsence ??
                            ''; // Fetch reason of absence

                    // Determine color based on attendance status
                    Color cardColor;
                    if (attendanceStatus == 'Present') {
                      cardColor = Colors.green;
                    } else if (attendanceStatus == 'Absent' &&
                        reasonOfAbsence.isEmpty) {
                      cardColor = Colors.red; // Absent without reason
                    } else if (attendanceStatus == 'Absent' &&
                        reasonOfAbsence.isNotEmpty) {
                      cardColor = Colors.blue; // Absent with reason
                    } else {
                      cardColor =
                          Colors.grey; // Default for any other condition
                    }

                    return Container(
                      width: 120,
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$date'),
                          const SizedBox(height: 10),
                          Text(attendanceStatus),
                          if (attendanceStatus == 'Absent')
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller:
                                    absenceControllers[date.toString()] ??=
                                        TextEditingController(
                                  text:
                                      reasonOfAbsence, // Pre-fill with existing reason
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Enter reason',
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(),
                                ),
                                onSubmitted: (value) {
                                  updateReasonOfAbsence(
                                      date.toString(), value, context);
                                },
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
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
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 217, 232, 245)),
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
        Text("A student who values every second as a step towards success."),
      ],
    );
  }
}
