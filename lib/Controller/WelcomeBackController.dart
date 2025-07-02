import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as Math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nobile/Constants/Utils.dart';
import 'package:nobile/Service/UserPreferences.dart';
import 'package:nobile/Views/CreateAccountScreen.dart';
import 'package:nobile/Views/ForgotPasswordScreen.dart';
import 'package:nobile/Views/HomeScreen.dart';
import 'package:nobile/Views/MainNavBar.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class WelcomeScreenController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isGoogleLoading = false.obs;
  RxBool isLoadingFacebook = false.obs;

  var isAppleLoading = false.obs;

  var isPasswordObscured = true.obs;
  var isRememberMeChecked = false.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  void goToSignupScreen() {
    Get.to(() => CreateAccountScreen(), transition: Transition.rightToLeft);
  }

  void goToForgetScreen() {
    Get.to(() => const ForgotPasswordScreen(),
        transition: Transition.rightToLeftWithFade);
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

      final User? user = userCredential.user;

      if (user != null) {
        final String? token = await user.getIdToken();

        if (token == null) throw Exception('Token is null');

        //fetch user data from Firestore
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          throw Exception("User document does not exist.");
        }

        final userData = userDoc.data() as Map<String, dynamic>;
        Get.offAll(() => MainNavBar(), transition: Transition.fade, arguments: {
          'userData': userData,
        });
      } else {
        throw Exception("User is null after login.");
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        // ErrorHandlerText.firebaseError(e);
        Utils.showError('Login Failed', e.message ?? 'Authentication failed.');
      } else {
        Utils.showError('Login Failed', 'An unexpected error occurred.');
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> loginWithFacebook() async {
    try {
      isLoadingFacebook(true);
      log('Attempting Facebook Sign-In...');

      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        log('Facebook Access Token: ${accessToken.tokenString}');

        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        final String? token = await userCredential.user?.getIdToken();

        if (token != null) {
          onSuccess(token);
          log('Facebook Sign-In successful. User UID: ${userCredential.user?.uid}');
        } else {
          log('Failed to retrieve token after Facebook login.');
          Utils.showError(
              "Login Failed", "Could not retrieve authentication token.");
        }
      } else if (result.status == LoginStatus.cancelled) {
        log('Facebook Sign-In cancelled by user.');
        Utils.showError("Login Cancelled", "Facebook login was cancelled.");
      } else {
        log('Facebook Sign-In failed: ${result.message}');
        Utils.showError("Login Failed", result.message ?? "Unknown error");
      }
    } catch (error) {
      log('[Facebook Login] Error: $error');
      Utils.showError(
          "Login Failed", "Facebook Sign-In failed. Please try again.");
    } finally {
      isLoadingFacebook(false);
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      isGoogleLoading(true);
      log('Attempting Google Sign-In...');

      if (await GoogleSignIn().isSignedIn()) {
        await GoogleSignIn().signOut();
      }

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        isGoogleLoading(false);
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
      onSuccess(token!);

      log('Firebase Sign-In successful. User UID: ${user.user!.uid}');
    } catch (error) {
      if (error is FirebaseAuthException) {
        log('[Google Login] Login with Google failed: $error');
      }
      isGoogleLoading(false);
      log('[Google Login] Login with Google failed: $error');
      Utils.showError(
          "Login Failed", "Google Sign-In failed. Please try again.");
      // isLoading.value = false;
    } finally {
      isGoogleLoading(false);
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
          onSuccess(token);
        }
      } catch (e) {
        print("--------------------- Apple Error $e");
      } finally {
        isAppleLoading.value = false;
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
        'name': user.displayName,
        'createdAt': Timestamp.now(),
        'isVerified': user.emailVerified,
      };

      // Save user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userData);

      await UserPreferences.saveUser(userData);

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
      isLoading(false);
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
