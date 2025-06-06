import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Constants/Constants.dart';
import 'package:nobile/Controller/LogoutController.dart';
import 'package:nobile/Views/Widgets/CustomElevatedButton.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimary,
      appBar: AppBar(
        title: const Text("Logout screen"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Lou Account",
                textAlign: TextAlign.center,
                // textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: colorSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              BulletPoint(text: "logout"),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    // LoaderButton2(
                    //   buttonName: "delete".translate,
                    //   onPressed: () {
                    //     showConfirmationDialog();
                    //   },
                    // ),
                    GestureDetector(
                  onTap: () {
                    showConfirmationDialog();
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: colorSecondary,
                    ),
                    child: const Center(
                      child: Text(
                        "logout",
                        style: TextStyle(fontSize: 16, color: colorPrimary),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showConfirmationDialog() async {
    final LogoutController controller = Get.put(LogoutController());
    Get.dialog(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      SizedBox(height: Get.height * 0.01),
                      Text(
                        "AreYouSureYouWantToProceed",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                      SizedBox(height: Get.height * 0.02),
                      CustomElevatedButton(
                          fontWeight: FontWeight.bold,
                          borderColor: const Color(0xff2e124c33),
                          text: 'Cancel',
                          backgroundColor: colorNavBar,
                          onpress: () {
                            Get.back();
                          }),
                      SizedBox(height: Get.height * 0.02),
                      Obx(
                        () => CustomElevatedButton(
                            loading: controller.deleteBtnLoading.value,
                            fontWeight: FontWeight.bold,
                            // elevation: 2,
                            text: 'Ok',
                            textColor: colorPrimary,
                            backgroundColor: Colors.black,
                            onpress: () {
                              controller.logout();
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }
}
