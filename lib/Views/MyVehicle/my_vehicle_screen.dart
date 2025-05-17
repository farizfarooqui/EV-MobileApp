import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Constants/Constants.dart';
import 'package:nobile/Views/MyVehicle/select_brand_screen.dart';
import '../../Controllers/my_vehicle_controller.dart';

class MyVehicleScreen extends StatelessWidget {
  MyVehicleScreen({Key? key}) : super(key: key);
  final MyVehicleController controller = Get.put(MyVehicleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        centerTitle: true,
        title: const Text('MY VEHICLE',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Image.asset(
            'assets/images/P1.png',
            height: 180,
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Add your vehicle to discover all its capabilities and get the best charging experience possible.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: () {
                  Get.to(SelectBrandScreen());
                },
                child: const Text(
                  'Add vehicle',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
