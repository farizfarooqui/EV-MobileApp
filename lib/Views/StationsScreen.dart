import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Controller/stationController.dart';

class StationsScreen extends StatelessWidget {
  final StationController controller = Get.put(StationController());

  StationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Charging Stations')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.stations.isEmpty) {
          return const Center(child: Text('No stations found.'));
        }

        return ListView.builder(
          itemCount: controller.stations.length,
          itemBuilder: (context, index) {
            final station = controller.stations[index];
            return ListTile(
              title: Text(station['name'] ?? 'Unnamed'),
              subtitle: Text('${station['city']}, ${station['state']}'),
            );
          },
        );
      }),
    );
  }
}
