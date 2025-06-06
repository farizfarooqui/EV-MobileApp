import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nobile/Constants/Utils.dart';
import 'package:nobile/Controller/StationController.dart';
import 'package:nobile/Views/MainNavBar.dart';
import 'package:nobile/Views/WelcomeBackScreen.dart';

class LogoutController extends GetxController {
  RxBool logoutBtnLoading = false.obs;
  RxBool deleteBtnLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> logout() async {
    logoutBtnLoading.value = true;
    try {
      bool hasInternet = await Utils.checkInternetConnection();
      if (!hasInternet) {
        Utils.showError("ERROR", "No internet connection");
        return;
      }

      await _auth.signOut();
      await _googleSignIn.signOut();

      // Delete controllers before navigation
      logoutBtnLoading.value = false;

      Get.delete<StationController>();
      Get.delete<MainNavBar>();
      Get.offAll(() => WelcomeBackScreen());
    } catch (e) {
      Utils.showError("ERROR", "Something went wrong: ${e.toString()}");
      logoutBtnLoading.value = false;
    }
  }
}
