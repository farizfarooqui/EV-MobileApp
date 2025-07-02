import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nobile/Constants/Constants.dart';
import 'package:nobile/Controller/WelcomeBackController.dart';
import 'package:nobile/Views/CreateAccountScreen.dart';
import 'package:nobile/Views/Widgets/AppTextField.dart';
import 'package:nobile/Views/Widgets/GradientLoaderButton.dart';
import 'package:nobile/Views/Widgets/SmallLoader.dart';
import 'package:nobile/Views/Widgets/SocialMediaButton.dart';

class WelcomeBackScreen extends StatelessWidget {
  final WelcomeScreenController controller = Get.put(WelcomeScreenController());

  WelcomeBackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Glowing circle
                Container(
                  margin: const EdgeInsets.only(bottom: 32, top: 24),
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green,
                        blurRadius: 60,
                        spreadRadius: 10,
                      ),
                    ],
                    color: Colors.green,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Login to your\naccount",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(CreateAccountScreen());
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Email field
                      AppTextField(
                        controller: controller.emailController,
                        hintName: "Email",
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SvgPicture.asset(
                            "assets/SVG/email.svg",
                            color: Colors.white54,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      // Password field
                      Obx(() {
                        return AppTextField(
                          controller: controller.passwordController,
                          hintName: "Password",
                          style: const TextStyle(color: Colors.white),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SvgPicture.asset(
                              "assets/SVG/password.svg",
                              color: Colors.white54,
                              width: 22,
                            ),
                          ),
                          isSuffix: true,
                          suffixIcon: GestureDetector(
                            onTap: controller.togglePasswordVisibility,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: controller.isPasswordObscured.value
                                  ? SvgPicture.asset(
                                      'assets/SVG/eye-slash.svg',
                                      color: Colors.white54,
                                    )
                                  : SvgPicture.asset(
                                      'assets/SVG/eye.svg',
                                      color: Colors.white54,
                                    ),
                            ),
                          ),
                          obscureText: controller.isPasswordObscured.value,
                        );
                      }),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {/* Forgot password */},
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Login button
                      Obx(() => GradientLoaderButton(
                            isLoading: controller.isLoading.value,
                            onPressed: controller.signInWithEmailAndPassword,
                            text: "Login",
                          )),

                      const SizedBox(height: 24),
                      const Row(
                        children: [
                          Expanded(child: Divider(color: Colors.white24)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("Or login with",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white38)),
                          ),
                          Expanded(child: Divider(color: Colors.white24)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Social buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Google Button
                          Expanded(
                            child: Obx(() => Container(
                                  height: 48,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF23203B),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: controller.isGoogleLoading.value
                                        ? null
                                        : () => controller.loginWithGoogle(),
                                    child: Center(
                                      child: controller.isGoogleLoading.value
                                          ? const SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: SmallLoader(
                                                  color: Colors.white),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SvgPicture.asset(
                                                    "assets/icons/google.svg",
                                                    width: 22),
                                                const SizedBox(width: 8),
                                                const Text(
                                                  "Google",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                )),
                          ),

                          // Facebook Button
                          Expanded(
                            child: Obx(() => Container(
                                  height: 48,
                                  margin: const EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF23203B),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: controller.isLoadingFacebook.value
                                        ? null
                                        : () {
                                            controller.loginWithFacebook();
                                          },
                                    child: Center(
                                      child: controller.isLoadingFacebook.value
                                          ? const SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: SmallLoader(
                                                color: Colors.white,
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SvgPicture.asset(
                                                    "assets/icons/social/facebook.svg",
                                                    width: 22),
                                                const SizedBox(width: 8),
                                                const Text(
                                                  "Facebook",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                      // Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {/* Terms */},
                            child: const Text(
                              "Terms of use",
                              style: TextStyle(
                                  color: Colors.white38, fontSize: 13),
                            ),
                          ),
                          const Text("|",
                              style: TextStyle(color: Colors.white24)),
                          TextButton(
                            onPressed: () {/* Privacy */},
                            child: const Text(
                              "Privacy policy",
                              style: TextStyle(
                                  color: Colors.white38, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
