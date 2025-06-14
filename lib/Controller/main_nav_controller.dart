import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainNavController extends GetxController {
  RxInt tabIndex = 2.obs;
  late PageController pageController;
  final Map<String, dynamic> userData = Get.arguments['userData'];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: tabIndex.value);
    var userData = Get.arguments['userData'];
    log("User Name: ${userData['name']}");
  }

  void changeTab(int index) {
    tabIndex.value = index;
    pageController.jumpToPage(index);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
