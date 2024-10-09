import 'package:flutter/material.dart';

void circularProgressIndicatorAlert(BuildContext context) { 
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Loading'),
            content: Container(
              height: 50,
              width: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      );
}

String getcurrentYear() {
  return DateTime.now().year.toString();
}