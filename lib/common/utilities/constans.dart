import 'package:flutter/material.dart';

class Constants {
  // Constants for strings
  static const String profileUrl = 'https://firebasestorage.googleapis.com/v0/b/letters-and-numbers-24.appspot.com/o/defaultProfile.png?alt=media&token=36efeaac-6a10-400f-9e18-d2624aafe54b';
  static const String welcomeMessage = 'Welcome to MyApp!';

  // Constants for colors
  static const Color primaryColor = Color(0xFF0066FF);
  static const Color secondaryColor = Color(0xFFFF6600);

  // Constants for text styles
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // Constant constructor to prevent instantiation
  const Constants._();
  
}