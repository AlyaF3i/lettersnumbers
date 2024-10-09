class DailyReport {
  String name;
  String date;
  List<String> drinks;
  List<String> foods;
  String fun;
  Map<String, bool> moods;
  Map<String, bool> diapers;
  List<String> needs;
  String sleep;

  DailyReport({
    required this.name,
    required this.date,
    required this.drinks,
    required this.foods,
    required this.fun,
    required this.moods,
    required this.diapers,
    required this.needs,
    required this.sleep,
  });

  // Convert a DailyReport object into a Map to store in Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'drinks': drinks, // List of drinks
      'foods': foods,   // List of foods
      'fun': fun,       // Simple string
      'moods': moods,   // Map of mood booleans
      'diapers': diapers, // Map of diaper booleans
      'needs': needs,    // List of needs
      'sleep': sleep,    // Simple string
    };
  }

  // Create a DailyReport object from a Firestore Map
  factory DailyReport.fromMap(Map<String, dynamic> map) {
    return DailyReport(
      name: map['name'] ?? '',
      date: map['date'] ?? '',
      drinks: List<String>.from(map['drinks'] ?? []), // Convert dynamic to List<String>
      foods: List<String>.from(map['foods'] ?? []),   // Convert dynamic to List<String>
      fun: map['fun'] ?? '',
      moods: Map<String, bool>.from(map['moods'] ?? {}), // Convert dynamic to Map<String, bool>
      diapers: Map<String, bool>.from(map['diapers'] ?? {}), // Convert dynamic to Map<String, bool>
      needs: List<String>.from(map['needs'] ?? []),    // Convert dynamic to List<String>
      sleep: map['sleep'] ?? '',
    );
  }
}
