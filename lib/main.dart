import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Views/OnBoardingScreen.dart';
import 'package:nobile/supabase_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseManager.init();
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
        home: const OnboardingScreen());
  }
}
