import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nobile/Constants/Constants.dart';
import 'package:nobile/Controller/WelcomeBackController.dart';
import 'package:nobile/Views/LoginWithEmail.dart';
import 'package:nobile/Views/Widgets/SmallLoader.dart';
import 'package:nobile/Views/Widgets/CustomElevatedButton.dart';
import 'package:nobile/Views/Widgets/SocialMediaButton.dart';

class WelcomeBackScreen extends StatelessWidget {
  final WelcomeScreenController controller = Get.put(WelcomeScreenController());

  WelcomeBackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorSecondary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Text(
                "Welcome Back",
                style: TextStyle(
                    color: colorBlack,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              const Text(
                "login with phone text",
                style: TextStyle(
                    color: colorBlack,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48.0),
              CustomElevatedButton(
                  text: "login_with_email",
                  onpress: () {
                    Get.to(() => LoginWithEmailScreen());
                  }),
              const SizedBox(height: 16.0),
              CustomElevatedButton(
                  backgroundColor: colorNavBar,
                  text: "login_with_phone",
                  textColor: colorBlack,
                  onpress: () {
                    // Get.to(() => LoginWithPhoneScreen());
                  }),
              if (Platform.isIOS) ...[
                const SizedBox(height: 16.0),
                Obx(
                  () => CustomElevatedButton(
                    backgroundColor: colorBlack,
                    text: "Login with Apple ID",
                    iconPath: "assets/SVG/iphoneicon.svg",
                    textColor: Colors.black,
                    loading: controller.isAppleLoading.value,
                    onpress: controller.signInWithApple,
                  ),
                ),
              ],
              const SizedBox(height: 32.0),
              const Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      color: colorBlack,
                      thickness: 1, // Set the thickness of the divider
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10), // Space around the 'or' text
                    child: Text(
                      "or",
                      style: TextStyle(
                          color: colorBlack, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: colorBlack,
                      thickness: 1, // Set the thickness of the divider
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SocialMediaButton(
                    assetName: "assets/SVG/facebook.svg",
                    onTap: () {
                      // controller.loginWithFacebook();
                    },
                  ),
                  SocialMediaButton(
                    assetName: "assets/icons/google.svg",
                    onTap: () {
                      controller.loginWithGoogle();
                    },
                  ),
                  // ElevatedButton(
                  //     onPressed: () {},
                  //     child: Row(
                  //       children: [
                  //         const Text('Login with Google'),
                  //         SvgPicture.asset(
                  //           'assets/icons/google.svg',
                  //           color: colorPrimary,
                  //           height: 30,
                  //         )
                  //       ],
                  //     ))
                  // Obx(
                  //   () => controller.isLoading.value
                  //       ? const SmallLoader()
                  //       : SocialMediaButton(
                  //           assetName: "assets/SVG/google.svg",
                  //           onTap: () {
                  //             controller.loginWithGoogle();
                  //           },
                  //         ),
                  // ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
