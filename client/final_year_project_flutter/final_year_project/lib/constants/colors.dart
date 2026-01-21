import 'package:flutter/material.dart';

class AppColors {
  static const cyan = Color(0xFF52FFE2);
  static const green = Color.fromARGB(255, 82, 255, 160);
  static const background = Color(0xFF1C1C1C);
  static const lightgrey = Color.fromARGB(95, 255, 255, 255);
  static const darkgrey = Color.fromARGB(110, 255, 255, 255);
  static const darkgrey2 = Color.fromARGB(180, 255, 255, 255);
  static const white = Color.fromARGB(255, 255, 255, 255);
  static const userBubble = Color(0xFF5313131);
  static const aiBubble = Color(0xFF212121);
  static const userText =  Color.fromARGB(202, 255, 255, 255);

  static const gradient = LinearGradient(
    colors: [
      cyan, // Start color
      green, // End color
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
