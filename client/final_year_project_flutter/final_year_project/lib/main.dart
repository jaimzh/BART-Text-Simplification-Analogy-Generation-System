import 'package:final_year_project/constants/colors.dart';
import 'package:final_year_project/pages/HomePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Arial',
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
    );
  }
}
