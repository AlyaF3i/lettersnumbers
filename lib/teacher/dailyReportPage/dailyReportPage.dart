import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lettersnumbers/model/userdata.dart';

class DailyReportPage extends StatefulWidget {
  final UserData studentId;

  const DailyReportPage({Key? key, required this.studentId}) : super(key: key);

  @override
  _DailyReportPageState createState() => _DailyReportPageState();
}

class _DailyReportPageState extends State<DailyReportPage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String date;
  List<String> drinks = ['', '', ''];
  List<String> foods = ['', '', ''];
  String sleep = '';
  String fun = '';
  Map<String, bool> moods = {
    'happy': false,
    'sad': false,
    'sweet': false,
    'quiet': false,
    'sensitive': false,
    'silly': false,
  };
  Map<String, bool> diapers = {'wet': false, 'poo': false};
  List<String> needs = [];

  @override
  void initState() {
    super.initState();
    name = widget.studentId.username;
    date = "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
  }

  void saveData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Create a new report entry as a map
        Map<String, dynamic> newReport = {
          'name': name,
          'date': date,
          'drinks': drinks,
          'foods': foods,
          'sleep': sleep,
          'fun': fun,
          'moods': moods,
          'diapers': diapers,
          'needs': needs,
        };

        DocumentReference docRef = FirebaseFirestore.instance
            .collection("dailyReports")
            .doc(widget.studentId.uid);

        DocumentSnapshot docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;

          // Retrieve the existing reports
          List<dynamic> reportList = data?['reports'] ?? [];

          bool reportExists = false;

          // Check if a report for the same date exists
          for (int i = 0; i < reportList.length; i++) {
            if (reportList[i]['date'] == date) {
              // Replace the existing report with the new data
              reportList[i] = newReport;
              reportExists = true;
              break;
            }
          }

          // If no report for the same date exists, add the new report
          if (!reportExists) {
            reportList.add(newReport);
          }

          // Save the updated report list
          await docRef.set({
            'reports': reportList,
          }, SetOptions(merge: true));
        } else {
          // If no document exists, create one with the new report
          await docRef.set({
            'reports': [newReport],
          }, SetOptions(merge: true));
        }

        // Success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Daily Report Saved for $name')),
        );
      } catch (e) {
        // Error handling
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save report: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Day Today')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name and Date section
              _buildSectionHeading('General Info', Colors.brown.shade100),
              _buildTextField('Name', onSave: (val) => name = val ?? '', initialValue: name),
              _buildTextField('Date', onSave: (val) => date = val ?? '', initialValue: date),

              // Drinks section
              _buildSectionHeading('I Drank', Colors.purple.shade100),
              ...List.generate(3, (index) {
                return _buildTextField(
                  'Drink ${index + 1} (when, how much)',
                  onSave: (val) => drinks[index] = val ?? '',
                  initialValue: drinks[index],
                );
              }),

              // Food section
              _buildSectionHeading('I Ate', Colors.yellow.shade100),
              ...List.generate(3, (index) {
                return _buildTextField(
                  'Food ${index + 1} (what, when)',
                  onSave: (val) => foods[index] = val ?? '',
                  initialValue: foods[index],
                );
              }),

              // Sleep section
              _buildSectionHeading('I Slept', Colors.blue.shade100),
              _buildTextField('I Slept (when, how long)',
                  onSave: (val) => sleep = val ?? '', initialValue: sleep),

              // Fun section
              _buildSectionHeading('I Had Fun', Colors.brown.shade100),
              _buildTextField('I Had Fun', onSave: (val) => fun = val ?? '', initialValue: fun),

              // Mood section
              _buildSectionHeading('I Was', Colors.green.shade100),
              Wrap(
                spacing: 10.0,
                children: moods.keys.map((mood) {
                  return FilterChip(
                    label: Text(mood),
                    selected: moods[mood]!,
                    onSelected: (val) {
                      setState(() {
                        moods[mood] = val;
                      });
                    },
                  );
                }).toList(),
              ),

              // Diapers section
              _buildSectionHeading('I Went', Colors.red.shade100),
              Wrap(
                spacing: 10.0,
                children: diapers.keys.map((diaper) {
                  return FilterChip(
                    label: Text(diaper),
                    selected: diapers[diaper]!,
                    onSelected: (val) {
                      setState(() {
                        diapers[diaper] = val;
                      });
                    },
                  );
                }).toList(),
              ),

              // Needs section
              _buildSectionHeading('I Need', Colors.cyan.shade100),
              _buildTextField('Needs (comma-separated)',
                  onSave: (val) => needs = val?.split(',') ?? [], initialValue: needs.join(', ')),

              // Save button
              const SizedBox(height: 16),
              ElevatedButton(onPressed: saveData, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeading(String title, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField(String label, {required FormFieldSetter<String> onSave, String initialValue = ''}) {
    TextEditingController _controller = TextEditingController(text: initialValue);

    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: label,
      ),
      onSaved: (val) => onSave(val ?? ''),
    );
  }
}
