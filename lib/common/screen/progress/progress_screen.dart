import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lettersnumbers/common/firebaseMethods/firebaseMethods.dart';
import 'package:lettersnumbers/common/widgets/editableChart.dart';
import 'package:lettersnumbers/common/widgets/utilities.dart';
import 'package:lettersnumbers/model/userdata.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key, required this.student});
  final UserData student;

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  PlatformFile? _reportFile;
  String _title = '';
  bool _isUploading = false;
  late UserData studentData;
  late List<double> attendanceData =
      List.filled(12, 0.0); // 12 months, default 0%

  @override
  void initState() {
    super.initState();
    studentData = widget.student;
    _fetchAttendanceData(); // Fetch attendance data when the screen is initialized
  }

  Future<void> _fetchAttendanceData() async {
    try {
      final documentId =
         "${studentData.uid}_${DateTime.now().year}"; // Combine student ID and current year

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
        });
      }
    } catch (e) {
      print('Error fetching attendance data: $e');
    }
  }

  // Inside the _ProgressScreenState class

// Method to save updated attendance data to Firestore
  Future<void> _saveAttendanceData() async {
    try {
      final documentId =
          "${studentData.uid}_${DateTime.now().year}"; // Combine student ID and current year

      // Prepare data to update in Firestore (converting percentages to month keys)
      Map<String, dynamic> updatedData = {};
      for (int i = 0; i < 12; i++) {
        updatedData[(i + 1).toString()] = attendanceData[i];
      }

      // Update Firestore document with the new attendance data
      await FirebaseFirestore.instance
          .collection('attendance')
          .doc(documentId)
          .set(updatedData, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance updated successfully!')),
      );
    } catch (e) {
      print('Error updating attendance: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update attendance.')),
      );
    }
  }

  Future<void> _uploadFile(BuildContext context, PlatformFile file) async {
    setState(() {
      _isUploading = true;
    });

    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('reports/${file.name}');
      await ref.putFile(File(file.path!));
      String fileUrl = await ref.getDownloadURL();

      await FirebaseMethods.updateReport(
          fileUrl, _title, studentData.uid, context);

      await FirebaseFirestore.instance
          .collection('reports')
          .doc(studentData.uid)
          .set({
        'reportTitle': _title,
        'reportUrl': fileUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _isUploading = false;
        _reportFile = null;
        _title = '';
      });
    } catch (e) {
      print('Error uploading file: $e');
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/dashboard.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
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
                      child: const Icon(Icons.arrow_back_ios_new),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset('assets/images/logout.png'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 217, 232, 245),
                      ),
                      width: 50,
                      height: 50,
                      child: Image.asset(
                        "assets/images/profileImage.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(studentData.username),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.topLeft,
                  child: Image.asset("assets/images/progresscent.png"),
                ),

                const SizedBox(height: 20),
                _reportFile == null
                    ? const Text('No file selected.')
                    : SizedBox(
                        height: 300,
                        child: PDFView(
                          filePath: _reportFile!.path!,
                        ),
                      ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _pickAndUploadFile();
                  },
                  child: const Text('New Report to Upload'),
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _title = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Report Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                      _reportFile == null || _title.isEmpty || _isUploading
                          ? null
                          : () => _uploadFile(context, _reportFile!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: _isUploading
                      ? const CircularProgressIndicator()
                      : const Text('Submit Report',
                          style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 40),

                const Text(
                  "Attendance Progress by Month",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

                // Scrollable Row for Editing Month Percentages
                SingleChildScrollView(
                  scrollDirection:
                      Axis.horizontal, // Make the row scrollable horizontally
                  child: Row(
                    children: List.generate(12, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Text(
                              _getMonthName(index),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 100, // Adjust width to fit in row
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter %',
                                ),
                                onChanged: (value) {
                                  // Update the attendanceData list with new input
                                  double newPercentage =
                                      double.tryParse(value) ?? 0;
                                  setState(() {
                                    attendanceData[index] =
                                        newPercentage.clamp(0, 100);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 20),

                // Save Button
                Center(
                  child: ElevatedButton(
                    onPressed: _saveAttendanceData, // Call the method on click
                    child: const Text('Save Attendance'),
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final file = result.files.first;

      setState(() {
        _reportFile = file;
      });
    } else {
      print('No file selected');
    }
  }
}

// Function to get month name by index
String _getMonthName(int index) {
  const monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  return monthNames[index];
}
