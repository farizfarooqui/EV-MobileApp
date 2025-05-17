import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainNavController extends GetxController {
  RxInt tabIndex = 2.obs;
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: tabIndex.value);
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
