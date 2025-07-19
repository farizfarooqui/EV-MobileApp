import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Service/UserPreferences.dart';

class MainNavController extends GetxController {
  RxInt tabIndex = 2.obs;
  late PageController pageController;

  var userData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: tabIndex.value);
    getUserData();
  }

  Future<void> getUserData() async {
    final data = await UserPreferences.getUser();
    userData.value = data ?? {};
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
