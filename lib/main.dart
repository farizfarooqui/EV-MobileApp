import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Views/HomeScreen.dart';
import 'package:nobile/Views/OnBoardingScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'EV Mobile App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashColor: Colors.blue,
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}
