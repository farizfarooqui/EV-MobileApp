import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nobile/Constants/Constants.dart';
import 'package:nobile/Controller/WelcomeBackController.dart';
import 'package:nobile/Views/LoginWithEmail.dart';
import 'package:nobile/Views/Widgets/CustomElevatedButton.dart';
import 'package:nobile/Views/Widgets/SmallLoader.dart';
import 'package:nobile/Views/Widgets/SocialMediaButton.dart';

class WelcomeBackScreen extends StatelessWidget {
  final WelcomeScreenController controller = Get.put(WelcomeScreenController());

  WelcomeBackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorSecondary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: Get.height * 0.2),
              const Text(
                "Welcome Back 👋",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: colorBlack,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Login to continue using your account",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: colorBlack,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              /// Login Options
              CustomElevatedButton(
                text: "Login with Email",
                iconPath: "assets/SVG/email.svg",
                onpress: () => Get.to(() => LoginWithEmailScreen()),
              ),
              const SizedBox(height: 16),
              CustomElevatedButton(
                backgroundColor: colorNavBar,
                text: "Login with Phone",
                iconPath: "assets/SVG/Phone.svg",
                textColor: colorBlack,
                onpress: () {
                  // Get.to(() => LoginWithPhoneScreen());
                },
              ),
              if (Platform.isIOS) ...[
                const SizedBox(height: 16),
                Obx(() => CustomElevatedButton(
                      backgroundColor: Colors.black,
                      text: "Login with Apple ID",
                      iconPath: "assets/SVG/iphoneicon.svg",
                      textColor: Colors.white,
                      loading: controller.isAppleLoading.value,
                      onpress: controller.signInWithApple,
                    )),
              ],
              const SizedBox(height: 32),

              /// Divider
              const Row(
                children: [
                  Expanded(child: Divider(color: colorBlack)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("OR",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: colorBlack)),
                  ),
                  Expanded(child: Divider(color: colorBlack)),
                ],
              ),
              const SizedBox(height: 24),

              /// Google Button
              Obx(() {
                return GestureDetector(
                  onTap: () {
                    if (!controller.isLoading.value) {
                      controller.loginWithGoogle();
                    }
                  },
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.grey.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (controller.isLoading.value)
                          const SmallLoader(color: colorPrimary)
                        else ...[
                          SvgPicture.asset("assets/icons/google.svg",
                              width: 24),
                          const SizedBox(width: 12),
                          const Text(
                            'Continue with Google',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 32),

              // /// Social Media
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     SocialMediaButton(
              //       assetName: "assets/icons/facebook.svg",
              //       onTap: () {
              //         // controller.loginWithFacebook();
              //       },
              //     ),
              //     SocialMediaButton(
              //       assetName: "assets/icons/google.svg",
              //       onTap: controller.loginWithGoogle,
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
