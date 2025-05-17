import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;

  ThemeMode get themeMode => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    Get.changeThemeMode(themeMode);
  }
} 