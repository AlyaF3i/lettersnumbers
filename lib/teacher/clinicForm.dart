import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lettersnumbers/model/userdata.dart';

class ClinicForm extends StatefulWidget {
    ClinicForm({super.key, required this.student});
    final UserData student;


  @override
  _ClinicFormState createState() => _ClinicFormState();
}

class _ClinicFormState extends State<ClinicForm> {
    late UserData newStudent;
    

  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _date = '';
  String _time = '';
  String _name = '';
  String _class = '';

  // Symptoms
  bool flu = false;
  bool fever = false;
  bool headache = false;
  bool noseBleeding = false;
  bool cough = false;
  bool rash = false;
  bool headLice = false;
  bool runnyNose = false;
  bool diarrhea = false;
  bool injuryWound = false;
  bool nasalCongestion = false;
  bool nauseaVomiting = false;
  bool othersSymptoms = false;

  // Nursing Care Provided
  bool restReassurance = false;
  bool icePackApplied = false;
  bool woundCare = false;
  bool supportiveBandage = false;
  bool tepidSpongeBath = false;
  bool otherCare = false;

  // Status
  bool returnToClass = false;
  bool nurseryClinic = false;
  bool sentHome = false;
  bool ambulanceToHospital = false;

  String _comments = '';

    @override
  void initState() {
    super.initState();
    newStudent = widget.student;
  }

  // Method to save the clinic visit to Firestore
  Future<void> _saveClinicVisit(String studentUid) async {
    // Prepare the data map
    Map<String, dynamic> clinicData = {
      'date': _date,
      'time': _time,
      'name': _name,
      'class': _class,
      'symptoms': {
        'flu': flu,
        'fever': fever,
        'headache': headache,
        'noseBleeding': noseBleeding,
        'cough': cough,
        'rash': rash,
        'headLice': headLice,
        'runnyNose': runnyNose,
        'diarrhea': diarrhea,
        'injuryWound': injuryWound,
        'nasalCongestion': nasalCongestion,
        'nauseaVomiting': nauseaVomiting,
        'othersSymptoms': othersSymptoms,
      },
      'nursingCare': {
        'restReassurance': restReassurance,
        'icePackApplied': icePackApplied,
        'woundCare': woundCare,
        'supportiveBandage': supportiveBandage,
        'tepidSpongeBath': tepidSpongeBath,
        'otherCare': otherCare,
      },
      'status': {
        'returnToClass': returnToClass,
        'nurseryClinic': nurseryClinic,
        'sentHome': sentHome,
        'ambulanceToHospital': ambulanceToHospital,
      },
      'comments': _comments,
    };

    // Save to Firestore
    try {
      await _firestore.collection('clinicVisit').doc(studentUid).set({
        _date: clinicData, // Use date as the key
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Clinic visit saved successfully!')),
      );
    } catch (e) {
      print('Error saving clinic visit: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save clinic visit')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification of Visit to the School Clinic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Date'),
                onChanged: (value) {
                  setState(() {
                    _date = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Time'),
                onChanged: (value) {
                  setState(() {
                    _time = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a time';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: newStudent.username,
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Class'),
                onChanged: (value) {
                  setState(() {
                    _class = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a class';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),

              // Child's Symptoms Section
              Container(
                height: 40,
                color: Color.fromRGBO(222, 186, 184, 1),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    ' Child’s Symptoms     :',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              CheckboxListTile(
                title: Text('Flu-like Symptoms'),
                value: flu,
                onChanged: (value) {
                  setState(() {
                    flu = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Fever'),
                value: fever,
                onChanged: (value) {
                  setState(() {
                    fever = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Headache'),
                value: headache,
                onChanged: (value) {
                  setState(() {
                    headache = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Nose Bleeding'),
                value: noseBleeding,
                onChanged: (value) {
                  setState(() {
                    noseBleeding = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Cough'),
                value: cough,
                onChanged: (value) {
                  setState(() {
                    cough = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Rash'),
                value: rash,
                onChanged: (value) {
                  setState(() {
                    rash = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Head Lice/Nits'),
                value: headLice,
                onChanged: (value) {
                  setState(() {
                    headLice = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Runny Nose'),
                value: runnyNose,
                onChanged: (value) {
                  setState(() {
                    runnyNose = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Diarrhea'),
                value: diarrhea,
                onChanged: (value) {
                  setState(() {
                    diarrhea = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Injury/Wound'),
                value: injuryWound,
                onChanged: (value) {
                  setState(() {
                    injuryWound = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Nasal Congestion'),
                value: nasalCongestion,
                onChanged: (value) {
                  setState(() {
                    nasalCongestion = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Nausea/Vomiting'),
                value: nauseaVomiting,
                onChanged: (value) {
                  setState(() {
                    nauseaVomiting = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Others'),
                value: othersSymptoms,
                onChanged: (value) {
                  setState(() {
                    othersSymptoms = value!;
                  });
                },
              ),

              SizedBox(height: 20),

              // Nursing Care Provided Section
              Container(
                height: 40,
                color: Color.fromRGBO(222, 186, 184, 1),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    ' Nursing Care Provided     :',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              CheckboxListTile(
                title: Text('Rest/Reassurance'),
                value: restReassurance,
                onChanged: (value) {
                  setState(() {
                    restReassurance = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Ice Pack Applied'),
                value: icePackApplied,
                onChanged: (value) {
                  setState(() {
                    icePackApplied = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Wound Care'),
                value: woundCare,
                onChanged: (value) {
                  setState(() {
                    woundCare = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Supportive Bandage'),
                value: supportiveBandage,
                onChanged: (value) {
                  setState(() {
                    supportiveBandage = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Tepid Sponge Bath'),
                value: tepidSpongeBath,
                onChanged: (value) {
                  setState(() {
                    tepidSpongeBath = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Other Care'),
                value: otherCare,
                onChanged: (value) {
                  setState(() {
                    otherCare = value!;
                  });
                },
              ),

              SizedBox(height: 20),

              // Status Section
              Container(
                height: 40,
                color: Color.fromRGBO(222, 186, 184, 1),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    ' Status     :',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              CheckboxListTile(
                title: Text('Return to Class'),
                value: returnToClass,
                onChanged: (value) {
                  setState(() {
                    returnToClass = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Nursery/Clinic'),
                value: nurseryClinic,
                onChanged: (value) {
                  setState(() {
                    nurseryClinic = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Sent Home'),
                value: sentHome,
                onChanged: (value) {
                  setState(() {
                    sentHome = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Ambulance to Hospital'),
                value: ambulanceToHospital,
                onChanged: (value) {
                  setState(() {
                    ambulanceToHospital = value!;
                  });
                },
              ),

              // Comments
              TextFormField(
                decoration: InputDecoration(labelText: 'Comments'),
                onChanged: (value) {
                  setState(() {
                    _comments = value;
                  });
                },
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Assuming you have the student's UID from the previous screen
                    _saveClinicVisit(newStudent.uid);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
