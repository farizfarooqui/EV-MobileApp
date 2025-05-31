import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nobile/Constants/Constants.dart';
import 'package:nobile/Controller/CreateAccountController.dart';
import 'package:nobile/Views/Widgets/AppTextField.dart';
import 'package:nobile/Views/Widgets/LoaderButton.dart';

import 'widgets/SpringWidget.dart';

class CreateAccountScreen extends StatelessWidget {
  final controller = Get.put(CreateAccountController());

  CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorSecondary,
        ),
        backgroundColor: colorSecondary,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            // padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: Get.height * 0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Create an Account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: colorBlack,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Create your account in seconds. We will help you find your perfect match.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 48),
                    AppTextField(
                      controller: controller.emailController,
                      hintName: 'Email',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SvgPicture.asset(
                          "assets/icons/email.svg",
                          color: colorBlack,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      return AppTextField(
                          controller: controller.passwordController,
                          hintName: 'Password',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SvgPicture.asset(
                              "assets/icons/password.svg",
                              height: 18,
                              width: 18,
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
                          keyboardType: TextInputType.emailAddress,
                          obscureText: controller.isPasswordObscured.value);
                    }),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(() => Checkbox(
                              value: controller.isRememberMeChecked.value,
                              onChanged: (newValue) {
                                controller.toggleRememberMe();
                              },
                              side:
                                  const BorderSide(color: colorBlack, width: 2),
                              activeColor: Colors.green,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                            )),
                        // const Text(
                        //   "I agree to Apps ",
                        //   textAlign: TextAlign.start,
                        //   style: TextStyle(
                        //     color: colorGrey,
                        //     fontWeight: FontWeight.w500,
                        //     fontSize: 14,
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: () {
                            // Get.to(() => const FAQWebViewScreen(
                            //       title: "Privacy Policy",
                            //       url:
                            //           'https://api.kampuskonnect2.com/privacypolicy',
                            //     ));
                          },
                          child: const Text(
                            'Privacy Policy',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: colorBlack,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: colorGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SpringWidget(
                          onTap: controller.goToLogin,
                          child: const Text(
                            "Sign in",
                            style: TextStyle(
                              color: colorBlack,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Obx(() => LoaderButton2(
                        isLoading: controller.isloading.value,
                        isIcon: false,
                        buttonName: "Continue",
                        btnTextColor: colorSecondary,
                        buttonColor: colorBlack,
                        onPressed: () => controller.handleContinue())),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
