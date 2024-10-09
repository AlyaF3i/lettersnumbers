import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EditableBarChart extends StatefulWidget {
  @override
  _EditableBarChartState createState() => _EditableBarChartState();
}

class _EditableBarChartState extends State<EditableBarChart> {
  // List to store percentage data for each month
  List<double> attendanceData = List.generate(12, (index) => 50.0); // Default value is 50%

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Editable Chart Example'),
      ),
      body: Column(
        children: [
          // Bar Chart
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
                              style: const TextStyle(color: Colors.black, fontSize: 12),
                            );
                          },
                          interval: 20, // Interval for y-axis labels (0%, 20%, 40%, ...)
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            const monthNames = [
                              'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                              'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
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
                            toY: attendanceData[index], // Set percentage for each month
                            color: attendanceData[index] > 0 ? Colors.blue : Colors.red,
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
            scrollDirection: Axis.horizontal, // Make the row scrollable horizontally
            child: Row(
              children: List.generate(12, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Text(
                        _getMonthName(index),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                            double newPercentage = double.tryParse(value) ?? 0;
                            setState(() {
                              attendanceData[index] = newPercentage.clamp(0, 100);
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
        ],
      ),
    );
  }

  // Function to get month name by index
  String _getMonthName(int index) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[index];
  }
}
