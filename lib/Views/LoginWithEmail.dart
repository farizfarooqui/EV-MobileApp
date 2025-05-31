import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nobile/Constants/Constants.dart';
import 'package:nobile/Controller/WelcomeBackController.dart';
import 'package:nobile/Views/Widgets/AppTextField.dart';
import 'package:nobile/Views/Widgets/LoaderButton.dart';
import 'package:nobile/Views/Widgets/SpringWidget.dart';

class LoginWithEmailScreen extends StatelessWidget {
  final controller = Get.put(WelcomeScreenController());

  LoginWithEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: colorBlack,
              )),
          backgroundColor: colorSecondary,
        ),
        backgroundColor: colorSecondary,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: Get.height * 0.8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Welcome back ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: colorBlack,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please enter your email & password to signin.',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 50),
                  AppTextField(
                    controller: controller.emailController,
                    hintName: "Email",
                    cursorColor: colorBlack,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SvgPicture.asset(
                        "assets/icons/email.svg",
                        color: colorBlack,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    return AppTextField(
                      controller: controller.passwordController,
                      hintName: "Password",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SvgPicture.asset(
                          "assets/icons/password.svg",
                          color: colorBlack,
                        ),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: controller.togglePasswordVisibility,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: controller.isPasswordObscured.value
                              ? SvgPicture.asset(
                                  'assets/icons/eye-slash.svg',
                                  color: colorBlack,
                                )
                              : SvgPicture.asset(
                                  'assets/icons/eye.svg',
                                  color: colorBlack,
                                ),
                        ),
                      ),
                      obscureText: controller.isPasswordObscured.value,
                    );
                  }),
                  const SizedBox(height: 32),
                  Obx(
                    () => LoaderButton2(
                      buttonName: "Log In",
                      btnTextColor: colorSecondary,
                      buttonColor: colorBlack.withOpacity(0.6),
                      isIcon: false,
                      onPressed: controller.signInWithEmailAndPassword,
                      isLoading: controller.isLoading.value,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: controller.goToForgetScreen,
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                              color: colorBlack,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don’t have an account? ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SpringWidget(
                        onTap: controller.goToSignupScreen,
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: colorBlack,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
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
        // bottomNavigationBar: Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     const Text(
        //       "Don’t have an account? ",
        //       style: TextStyle(
        //         color: Color(0xff22172A),
        //         fontWeight: FontWeight.w500,
        //       ),
        //     ),
        //     SpringWidget(
        //       onTap: controller.goToSignupScreen,
        //       child: const Text(
        //         'Sign Up',
        //         style: TextStyle(
        //           color: colorSecondary,
        //           fontWeight: FontWeight.w800,
        //           fontSize: 14,
        //         ),
        //       ),
        //     ),
        //   ],
        // ).paddingOnly(bottom: 60),
      ),
    );
  }
}
