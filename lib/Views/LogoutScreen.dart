import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Constants/Constants.dart';
import 'package:nobile/Controller/LogoutController.dart';
import 'package:nobile/Views/Widgets/CustomElevatedButton.dart';

class LogoutScreen extends StatelessWidget {
  LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // backgroundColor: Colors.black.withOpacity(0.04),
      appBar: AppBar(
        title: const Text("Logout"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Spacer(),
            Icon(Icons.logout_rounded, size: 80, color: colorPrimary),
            const SizedBox(height: 20),
            Text(
              "Are you sure you want to log out?",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "You will be signed out of your account.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.hintColor,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => showConfirmationDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Log Out",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> showConfirmationDialog() async {
    final LogoutController controller = Get.put(LogoutController());

    Get.dialog(
      Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Are you sure?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                const Text(
                  "This will log you out of your account. You can sign back in anytime.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        radious: 14.0,
                        text: "Cancel",
                        backgroundColor: Colors.grey[300]!,
                        textColor: Colors.black,
                        onpress: () => Get.back(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Obx(
                        () => CustomElevatedButton(
                          radious: 14.0,
                          text: "Yes, Logout",
                          loading: controller.deleteBtnLoading.value,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          onpress: () => controller.logout(),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
