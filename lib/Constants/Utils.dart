import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Constants/Constants.dart';

class Utils {
  static void showError(
    String title,
    String message,
  ) {
    Get.showSnackbar(GetSnackBar(
      title: title,
      message: message,
      backgroundColor: Color.lerp(colorNavBar, colorBlack, 0.006)!,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.GROUNDED,
    ));
  }

  static void showSnackbar(String message) {
    Get.showSnackbar(GetSnackBar(
      snackPosition: SnackPosition.TOP,
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
        ),
      ),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      snackStyle: SnackStyle.FLOATING,
      backgroundColor: const Color(0xff2D304F).withOpacity(0.8),
    ));
  }

  static void showSnackbarCustom(Widget message, {Color? backgroundColor}) {
    Get.showSnackbar(GetSnackBar(
      snackPosition: SnackPosition.TOP,
      messageText: message,
      borderRadius: 8,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      snackStyle: SnackStyle.FLOATING,
      backgroundColor:
          backgroundColor ?? const Color(0xff2D304F).withOpacity(0.8),
    ));
  }
}
