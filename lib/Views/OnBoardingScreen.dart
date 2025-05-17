// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nobile/Constants/Constants.dart';
import 'package:nobile/Views/HomeScreen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;
  PageController? controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
  }

  List<Map<String, String>> onboardingData = [
    {
      "text": "Find the Nearest Charging Station",
      "animation": "assets/animations/animation1.json",
      "image": "assets/images/onB1.jpg",
      "subtitle":
          "Locate the best charging spot based on availability and distance."
    },
    {
      "text": "Optimized Charging Recommendations",
      "animation": "assets/animations/animation2.json",
      "image": "assets/images/onB2.jpg",
      "subtitle":
          "Get AI-driven suggestions for fast and cost-effective charging."
    },
    {
      "text": "Seamless Charging Experience",
      "animation": "assets/animations/animation3.json",
      "image": "assets/images/onB3.jpg",
      "subtitle": "Navigate effortlessly to the most suitable charging station."
    },
  ];

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimary,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) => Center(
                  child: Image.asset(
                    onboardingData[index]["image"]!,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      onboardingData[currentPage]["text"]!,
                      key: ValueKey<String>(
                          onboardingData[currentPage]["text"]!),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: colorPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      onboardingData[currentPage]["subtitle"]!,
                      key: ValueKey<String>(
                          onboardingData[currentPage]["subtitle"]!),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                      (index) => buildDot(index: index),
                    ),
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: () async {
                      if (currentPage >= onboardingData.length - 1) {
                        Get.to(() => HomeScreen());
                        // Get.offAll(() => StationsScreen());
                      } else {
                        controller!.nextPage(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.fastOutSlowIn,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary,
                      fixedSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      currentPage == onboardingData.length - 1
                          ? "Continue"
                          : "Next",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.only(right: 5),
      width: currentPage == index ? 20 : 6,
      height: 6,
      decoration: BoxDecoration(
        color:
            currentPage == index ? Colors.white : Colors.grey.withOpacity(0.6),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
