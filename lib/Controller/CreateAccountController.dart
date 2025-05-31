// ignore_for_file: unnecessary_null_comparison
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Constants/Utils.dart';
import 'package:nobile/Views/HomeScreen.dart';
import 'package:nobile/Views/MainNavBar.dart';
import 'package:nobile/Views/WelcomeBackScreen.dart';

class CreateAccountController extends GetxController {
  var isPasswordObscured = true.obs;
  var isRememberMeChecked = false.obs;
  var isloading = false.obs;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  void goToLogin() {
    Get.to(() => WelcomeBackScreen(), transition: Transition.rightToLeft);
  }

  void toggleRememberMe() {
    isRememberMeChecked.value = !isRememberMeChecked.value;
  }

  void handleContinue() {
    if (emailController.text.isEmpty && passwordController.text.isEmpty) {
      Utils.showError("Ah Snap!", "Please provide credentials");
    } else if (emailController.text.isEmpty) {
      Utils.showError('Missing Email', 'Please enter your email address.');
      return;
    } else if (passwordController.text.isEmpty) {
      Utils.showError('Missing Password', 'Please enter a password.');
      return;
    } else if (isRememberMeChecked.value == false) {
      Utils.showError("Privacy Policy not selected",
          "Please accept the privacy policy to proceed.");
    } else {
      signUpWithEmailAndPassword();
    }
  }

  Future<void> signUpWithEmailAndPassword() async {
    log("[signUpWithEmailAndPassword] : ");
    log("Email : ${emailController.text}");
    log("Password : ${passwordController.text}");
    try {
      isloading(true);
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Get the user's ID token
      final String? token = await userCredential.user?.getIdToken();

      if (token != null) {
        log("[Email Create Account] $token");
        onSuccess(token);
      } else {
        throw Exception('Token is null');
      }
    } catch (e) {
      isloading(false);
      log('Error signing up with email and password: $e');
      if (e is FirebaseAuthException) {
        // ErrorHandlerText.firebaseError(e);
      } else {
        Utils.showError(
            'Signu Failed', 'There was an error while processing the request.');
      }
    }
  }

  void onSuccess(String token) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User not found after sign up.");
      }

      // Prepare user data
      final userData = {
        'uid': user.uid,
        'email': user.email,
        'createdAt': Timestamp.now(),
        'isVerified': user.emailVerified,
      };

      // Save user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userData);

      // Navigate to home screen
      Get.offAll(() => MainNavBar(),
          transition: Transition.rightToLeft,
          arguments: {
            'userData': userData,
          });
    } catch (error) {
      log('[SignUp] Error occurred: $error');
      Utils.showError(
          "Signup Failed", "There was an error while processing the request.");
    } finally {
      isloading(false);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
