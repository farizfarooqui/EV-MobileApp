import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/my_vehicle_controller.dart';

class AddVehicleScreen extends StatelessWidget {
  AddVehicleScreen({Key? key}) : super(key: key);
  final MyVehicleController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        centerTitle: true,
        title: const Text('ADD MY VEHICLE',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Image.asset('assets/images/P1.png', height: 100),
            ),
          ),
          const SizedBox(height: 24),
          Obx(() => Column(
                children: [
                  _vehicleDetailRow('Brand', controller.selectedBrand.value),
                  _vehicleDetailRow('Model', controller.selectedModel.value),
                  _vehicleDetailRow('Version', 'unknown'),
                  _vehicleDetailRow('Max. DC charge power', 'N/C'),
                  _vehicleDetailRow('Max. AC charge power', 'N/C'),
                  _vehicleDetailRow('Connectors', ''),
                  _vehicleDetailRow('Autocharge compatible', 'No'),
                ],
              )),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6EC6C5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: () {
                  // Save vehicle logic here
                  Get.offAll(());
                  Get.snackbar('Vehicle Added',
                      'Your vehicle has been added successfully!',
                      snackPosition: SnackPosition.BOTTOM);
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

  Widget _vehicleDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
