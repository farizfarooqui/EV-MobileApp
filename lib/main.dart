import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Service/UserPreferences.dart';
import 'package:nobile/Views/MainNavBar.dart';
import 'package:nobile/Views/WelcomeBackScreen.dart';
import 'package:nobile/firebase_options.dart';
import 'package:nobile/Controller/theme_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nobile/Constants/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  bool isLoggedIn = await UserPreferences.isLoggedIn();
  final userData = isLoggedIn ? await UserPreferences.getUser() : null;

  runApp(MyApp(
    isLogged: isLoggedIn,
    userData: userData,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLogged;

  final Map<String, dynamic>? userData;

  const MyApp({super.key, required this.isLogged, this.userData});
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    return GetMaterialApp(
      title: 'EVigo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.themeMode,
      home:
          // isLogged
          //     ? MainNavBar(
          //         userData: userData,
          //       )
          //     :
          WelcomeBackScreen(),
    );
  }
}
