import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Controller/theme_controller.dart';

class AppearanceScreen extends StatelessWidget {
  AppearanceScreen({super.key});
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('APPEARANCE', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: BackButton(color: Theme.of(context).iconTheme.color),
      ),
      body: Obx(() => ListView(
            children: [
              const SizedBox(height: 24),
              SwitchListTile.adaptive(
                title: Text(themeController.isDarkMode.value ? 'Dark Mode' : 'Light Mode'),
                value: themeController.isDarkMode.value,
                onChanged: themeController.toggleTheme,
                secondary: Icon(themeController.isDarkMode.value ? Icons.dark_mode : Icons.light_mode),
                activeColor: Theme.of(context).colorScheme.primary,
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              ),
            ],
          )),
    );
  }
} 