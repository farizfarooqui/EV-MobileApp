import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nobile/Constants/Constants.dart';
import 'package:nobile/Controller/CreateAccountController.dart';
import 'package:nobile/Views/Widgets/AppTextField.dart';
import 'package:nobile/Views/Widgets/GradientLoaderButton.dart';

import 'widgets/SpringWidget.dart';

class CreateAccountScreen extends StatelessWidget {
  final controller = Get.put(CreateAccountController());

  CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: Get.height * 0.09),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Glowing circle
                Container(
                  margin: const EdgeInsets.only(bottom: 32, top: 15),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Create your account",
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
                            "Already have an account? ",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: controller.goToLogin,
                            child: const Text(
                              "Sign In",
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
                      AppTextField(
                        controller: controller.nameController,
                        hintName: 'Name',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SvgPicture.asset(
                            "assets/SVG/person.svg",
                            color: Colors.white54,
                            height: 20,
                            width: 20,
                          ),
                        ),
                        keyboardType: TextInputType.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: controller.emailController,
                        hintName: 'Email',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SvgPicture.asset(
                            "assets/SVG/email.svg",
                            color: Colors.white54,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Obx(() {
                        return AppTextField(
                          controller: controller.passwordController,
                          hintName: 'Password',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SvgPicture.asset(
                              "assets/SVG/password.svg",
                              height: 18,
                              width: 18,
                              color: Colors.white54,
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
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: controller.isPasswordObscured.value,
                          style: const TextStyle(color: Colors.white),
                        );
                      }),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Obx(() => Checkbox(
                                value: controller.isRememberMeChecked.value,
                                onChanged: (newValue) {
                                  controller.toggleRememberMe();
                                },
                                side: const BorderSide(
                                    color: Colors.white54, width: 2),
                                activeColor: Colors.green,
                                checkColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                              )),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Privacy Policy',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      Obx(() => GradientLoaderButton(
                            isLoading: controller.isloading.value,
                            onPressed: controller.handleContinue,
                            text: "Continue",
                            fontsize: 18,
                          )),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Terms of use",
                              style: TextStyle(
                                  color: Colors.white38, fontSize: 13),
                            ),
                          ),
                          const Text("|",
                              style: TextStyle(color: Colors.white24)),
                          TextButton(
                            onPressed: () {},
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
