import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Controller/theme_controller.dart';
import 'package:nobile/Views/AppearanceScreen.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('SETTINGS',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Card(
                color: Theme.of(context).cardColor,
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    _ProfileRow(
                        icon: Icons.language, text: 'Language', onTap: () {}),
                    _ProfileRow(
                        icon: Icons.palette_outlined,
                        text: 'Appearance',
                        onTap: () {
                          Get.to(() => AppearanceScreen());
                        }),
                    _ProfileRow(
                        icon: Icons.logout, text: 'Log out', onTap: () {}),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text('SUPPORT',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Card(
                color: Theme.of(context).cardColor,
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    _ProfileRow(
                        icon: Icons.help_outline,
                        text: 'Help & FAQ',
                        onTap: () {}),
                    _ProfileRow(
                        icon: Icons.chat_bubble_outline,
                        text: 'Contact us',
                        onTap: () {}),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const _ProfileRow(
      {required this.icon, required this.text, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(text),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
