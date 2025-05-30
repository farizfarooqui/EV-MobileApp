import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as Math;
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nobile/Constants/Utils.dart';
import 'package:nobile/Views/HomeScreen.dart';
import 'package:nobile/Views/MainNavBar.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class WelcomeScreenController extends GetxController {
  RxBool isLoading = false.obs;
  var isAppleLoading = false.obs;

  var isPasswordObscured = true.obs;
  var isRememberMeChecked = false.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  void goToSignupScreen() {
    // Get.to(() => CreateAccountScreen(), transition: Transition.rightToLeft);
  }

  void goToForgetScreen() {
    // Get.to(() => ForgotPasswordScreen(), transition: Transition.rightToLeft);
  }

  void toggleRememberMe() {
    isRememberMeChecked.value = !isRememberMeChecked.value;
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      isLoading(true);

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      final String? token = await userCredential.user?.getIdToken();
      if (token != null) {
        // onSuccess(token);
        Get.offAll(HomeScreen());
      } else {
        throw Exception('Token is null');
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        // ErrorHandlerText.firebaseError(e);
      } else {
        Utils.showError('Login Failed', 'An unexpected error occurred.');
      }
      isLoading(false);
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      isLoading(true);
      log('Attempting Google Sign-In...');

      if (await GoogleSignIn().isSignedIn()) {
        await GoogleSignIn().signOut();
      }

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        isLoading(false);
        log('Google Sign-In canceled.');
        return;
      }

      log('Google Sign-In successful. User: ${googleUser.displayName}');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      log('Obtained Google authentication details.');

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      log('Firebase credential created.');

      var user = await FirebaseAuth.instance.signInWithCredential(credential);
      var token = await user.user?.getIdToken();
      // onSuccess(token);
      Get.offAll(MainNavBar());

      log('Firebase Sign-In successful. User UID: ${user.user!.uid}');
    } catch (error) {
      if (error is FirebaseAuthException) {
        log('[Google Login] Login with Google failed: $error');
      }
      isLoading(false);
      log('[Google Login] Login with Google failed: $error');
      Utils.showError(
          "Login Failed", "Google Sign-In failed. Please try again.");
      // isLoading.value = false;
    } finally {
      isLoading(false);
    }
  }

  Future<void> signInWithApple() async {
    if (!Platform.isIOS) {
      // Utils.showToast("apple_login_error");
      Utils.showError("login_failed", "apple_login_error");
    } else {
      final rawNonce = generateNonce();
      // final nonce = sha256ofString(rawNonce);
      try {
        isAppleLoading.value = true;
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          // nonce: nonce,
        );

        final oauthCredential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          rawNonce: rawNonce,
        );

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(oauthCredential);
        String? token = await userCredential.user!.getIdToken();
        if (token != null) {
          // onSuccess(token);
        }
      } catch (e) {
        print("--------------------- Apple Error $e");
      } finally {
        isAppleLoading.value = false;
      }
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Math.Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  // String sha256ofString(String input) {
  //   final bytes = utf8.encode(input);
  //   final digest = sha256.convert(bytes);
  //   return digest.toString();
  // }

  bool isValidPhoneNumber(String? value) =>
      RegExp(r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)')
          .hasMatch(value ?? '');
}
