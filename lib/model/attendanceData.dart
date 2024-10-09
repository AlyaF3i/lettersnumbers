class AttendanceModel {
  final String date;
  final String status;
  final String? reasonOfAbsence;

  AttendanceModel({
    required this.date,
    required this.status,
    this.reasonOfAbsence,
  });

  // Method to create Attendance from a map (Firebase)

  
  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    String dateKey = map.keys.first;
    Map<String, dynamic> valueMap = map.values.first;

    return AttendanceModel(
      date: dateKey,
      status: valueMap['status'] ?? 'Present',  // Default to 'Present'
      reasonOfAbsence: valueMap['reasonOfAbsence'] ?? '', // Default empty string for reason
    );
  }

  // Method to convert Attendance model to a Map
  Map<String, dynamic> toMap() {
    return {
      date: {
        'status': status,
        'reasonOfAbsence': reasonOfAbsence ?? '',
      },
    };
  }
}