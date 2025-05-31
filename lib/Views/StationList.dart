import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Controller/StationListController.dart';
import 'package:nobile/Views/StationDetailsScreen.dart'; // Create this screen

class FetchStationsScreen extends StatelessWidget {
  final StationController controller = Get.put(StationController());

  FetchStationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Charging Stations')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search by name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: controller.filterStations,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                final stations = controller.filteredStations;

                if (stations.isEmpty) {
                  return const Center(child: Text('No stations found'));
                }

                return ListView.builder(
                  itemCount: stations.length,
                  itemBuilder: (context, index) {
                    final station = stations[index];
                    return ListTile(
                      leading: Icon(
                        station.verified ? Icons.check_circle : Icons.cancel,
                        color: station.verified ? Colors.green : Colors.red,
                      ),
                      title: Text(station.stationName),
                      subtitle: Text(
                          '${station.city}, ${station.state}, ${station.country}'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Get.to(() => StationDetailsScreen(station: station));
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
