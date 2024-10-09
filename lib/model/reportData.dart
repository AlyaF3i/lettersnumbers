class Report {
  final String reportUrl;
  final String reportTitle;
  final String date;

  Report({
    required this.reportUrl,
    required this.reportTitle,
    required this.date,
  });

  // Method to create Report from a map (Firebase)
  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      reportUrl: map.values.first,
      reportTitle: map['reportTitle'] ?? '',
      date: map.keys.first,
    );
  }

  // Method to convert Report model to a Map
  Map<String, dynamic> toMap() {
    return {
      date: reportUrl,
      'reportTitle': reportTitle,
    };
  }
}
