import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:nobile/Constants/Constants.dart';
import 'package:nobile/Views/AccountScreen.dart';
import 'package:nobile/Views/ChargersScreen.dart';
import 'package:nobile/Views/HomeScreen.dart';
import 'package:nobile/Views/MyBooking.dart';
import 'package:nobile/Controller/main_nav_controller.dart';
import 'package:nobile/Views/SettingsScreen.dart';

class MainNavBar extends StatelessWidget {
  MainNavBar({super.key});
  final MainNavController navController = Get.put(MainNavController());

  final List<Widget> _screens = [
    MyBookingScreen(),
    ChargersScreen(),
    HomeScreen(),
    AccountScreen(),
    SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: navController.pageController,
        onPageChanged: (index) => navController.tabIndex.value = index,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: Obx(
        () => CircleNavBar(
          activeIcons: [
            Icon(Icons.event_repeat,
                color: Theme.of(context).colorScheme.primary),
            Icon(Icons.energy_savings_leaf_sharp,
                color: Theme.of(context).colorScheme.primary),
            Icon(Icons.home, color: Theme.of(context).colorScheme.primary),
            Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
            Icon(Icons.settings, color: Theme.of(context).colorScheme.primary),
          ],
          inactiveIcons: [
            Icon(Icons.event_repeat,
                color: Theme.of(context).hintColor.withOpacity(0.3)),
            Icon(Icons.energy_savings_leaf_sharp,
                color: Theme.of(context).hintColor.withOpacity(0.3)),
            Icon(Icons.home,
                color: Theme.of(context).hintColor.withOpacity(0.3)),
            Icon(Icons.person,
                color: Theme.of(context).hintColor.withOpacity(0.3)),
            Icon(Icons.settings,
                color: Theme.of(context).hintColor.withOpacity(0.3)),
          ],
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          height: 60,
          circleWidth: 60,
          shadowColor: Colors.black.withOpacity(0.1),
          circleShadowColor: Colors.black.withOpacity(0.1),
          activeIndex: navController.tabIndex.value,
          onTap: navController.changeTab,
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
          cornerRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(24),
            bottomLeft: Radius.circular(24),
          ),
          elevation: 10,
        ),
      ),
    );
  }
}
