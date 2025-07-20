import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Controller/theme_controller.dart';

class AppearanceScreen extends StatelessWidget {
  AppearanceScreen({super.key});
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final theme =
        Get.context != null ? Theme.of(Get.context!) : ThemeData.dark();
    return Scaffold(
      backgroundColor: theme.brightness == Brightness.dark
          ? Color(0xFF121212)
          : Colors.white,
      appBar: AppBar(
        title: const Text('APPEARANCE',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: theme.brightness == Brightness.dark
            ? const Color(0xFF1F1F1F)
            // ? Colors.black
            : Colors.white,
        elevation: 0,
        leading: BackButton(color: Theme.of(context).iconTheme.color),
      ),
      body: Obx(() => ListView(
            children: [
              const SizedBox(height: 24),
              SwitchListTile.adaptive(
                title: Text(themeController.isDarkMode.value
                    ? 'Dark Mode'
                    : 'Light Mode'),
                value: themeController.isDarkMode.value,
                onChanged: themeController.toggleTheme,
                secondary: Icon(themeController.isDarkMode.value
                    ? Icons.dark_mode
                    : Icons.light_mode),
                activeColor: Theme.of(context).colorScheme.primary,
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              ),
            ],
          )),
    );
  }
}
