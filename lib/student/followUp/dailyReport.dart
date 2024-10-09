import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lettersnumbers/model/userdata.dart';
import '../../model/dailyReport.dart';
import 'package:intl/intl.dart';

class DailyReportViewPage extends StatefulWidget {
  final UserData studentId;

  const DailyReportViewPage({Key? key, required this.studentId}) : super(key: key);

  @override
  _DailyReportViewPageState createState() => _DailyReportViewPageState();
}

class _DailyReportViewPageState extends State<DailyReportViewPage> {
  bool isLoading = true;
  List<DailyReport> dailyReports = [];
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchReport();
  }

  Future<void> fetchReport() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('dailyReports')
          .doc(widget.studentId.uid)
          .get();

      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        List<dynamic> reportList = data?['reports'] ?? [];
        String currentDate = DateFormat('d-MM-yyyy').format(DateTime.now());

        List<DailyReport> reports = reportList.map((reportData) {
          if (reportData is Map<String, dynamic>) {
            return DailyReport.fromMap(reportData);
          } else {
            throw Exception("Invalid report data: expected Map<String, dynamic> but got ${reportData.runtimeType}");
          }
        }).where((report) {
          return report.date == currentDate;
        }).toList();

        if (reports.isNotEmpty) {
          setState(() {
            dailyReports = reports;
            isLoading = false;
          });
        } else {
          setState(() {
            error = 'No reports found for today ($currentDate).';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = 'No data found for this student.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Daily Report'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(
                  child: Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: dailyReports.length,
                    itemBuilder: (context, index) {
                      DailyReport report = dailyReports[index];
                      return _buildReportCard(report);
                    },
                  ),
                ),
    );
  }

  Widget _buildReportCard(DailyReport report) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionHeading('General Info', Colors.brown.shade100),
            _buildInfoRow('Name', report.name),
            _buildInfoRow('Date', report.date),

            _buildSectionHeading('I Drank', Colors.purple.shade100),
            _buildListInfo('Drinks', report.drinks),

            _buildSectionHeading('I Ate', Colors.yellow.shade100),
            _buildListInfo('Foods', report.foods),

            _buildSectionHeading('I Slept', Colors.blue.shade100),
            _buildInfoRow('Sleep', report.sleep),

            _buildSectionHeading('I Had Fun', Colors.brown.shade100),
            _buildInfoRow('Fun', report.fun),

            _buildSectionHeading('I Was', Colors.green.shade100),
            _buildMapInfo('Moods', report.moods),

            _buildSectionHeading('I Went', Colors.red.shade100),
            _buildMapInfo('Diapers', report.diapers),

            _buildSectionHeading('I Need', Colors.cyan.shade100),
            _buildListInfo('Needs', report.needs),
          ],
        ),
      ),
    );
  }

  // Widget to build section headings
  Widget _buildSectionHeading(String title, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget to build info rows for single values
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Widget to display lists (e.g., drinks, foods, needs)
  Widget _buildListInfo(String label, List<String> values) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          ...values.map((value) => Text('- $value')).toList(),
        ],
      ),
    );
  }

  // Widget to display map data (e.g., moods, diapers)
  Widget _buildMapInfo(String label, Map<String, bool> values) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          ...values.entries.map((entry) {
            return Text('- ${entry.key}: ${entry.value ? 'Yes' : 'No'}');
          }).toList(),
        ],
      ),
    );
  }
}
