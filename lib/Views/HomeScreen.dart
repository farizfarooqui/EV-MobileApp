import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:nobile/Constants/Constants.dart';
import 'package:nobile/Controller/StationListController.dart';
import 'package:nobile/Views/StationFilterSheet.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final StationController controller = Get.put(StationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: FloatingActionButton(
              onPressed: () {
                // homeController.getCurrentLocation();
                //move on click only
              },
              backgroundColor: colorNavBar,
              child: const Icon(
                Icons.my_location,
                color: colorPrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 90),
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (context) => StationFilterSheet(),
                );
              },
              backgroundColor: colorNavBar,
              child: const Icon(
                Icons.filter_list,
                color: colorPrimary,
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        children: [
          // Map Layer
          FlutterMap(
            mapController: controller.mapController,
            options: const MapOptions(
              initialCenter: LatLng(24.884928, 67.058579),
              initialZoom: 12,
              minZoom: 10,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: Theme.of(context).brightness == Brightness.dark
                    ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
                    : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
                subdomains: const ['a', 'b', 'c'],
              ),
              // Current Location Marker
              Obx(() {
                final position = controller.currentPosition.value;
                if (position == null) return const SizedBox.shrink();
                return MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(position.latitude, position.longitude),
                      width: 30,
                      height: 30,
                      child: SvgPicture.asset(
                        'assets/SVG/location.svg',
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ],
                );
              }),
              // Station Markers
              Obx(
                () => MarkerLayer(
                  markers: controller.stations.map((station) {
                    return Marker(
                      point: LatLng(station.location.latitude,
                          station.location.longitude),
                      width: 40.0,
                      height: 40.0,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (context) => DraggableScrollableSheet(
                              expand: false,
                              initialChildSize: 0.4,
                              minChildSize: 0.3,
                              maxChildSize: 0.9,
                              builder: (_, scrollController) =>
                                  StationDetailSheet(
                                station: station.toJson(),
                                scrollController: scrollController,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.ev_station,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          // Floating Search Icon
          Obx(() => !controller.showSearch.value
              ? Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  right: 24,
                  child: Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    elevation: 6,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      // onTap: controller.showSearchBar,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .shadowColor
                                  .withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: Theme.of(context)
                                .dividerColor
                                .withOpacity(0.15),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(Icons.search,
                            color: Theme.of(context).iconTheme.color),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink()),
          // Search Bar
          Obx(() => controller.showSearch.value
              ? Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  right: 16,
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
                            return const Center(
                                child: Text('No stations found'));
                          }
                          return ListView.builder(
                            itemCount: stations.length,
                            itemBuilder: (context, index) {
                              final station = stations[index];
                              return ListTile(
                                leading: Icon(
                                  station.verified
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: station.verified
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                title: Text(station.stationName),
                                subtitle: Text(
                                    '${station.city}, ${station.state}, ${station.country}'),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  // close and move map to its location on map
                                },
                              );
                            },
                          );
                        }),
                      ),
                      //
                    ],
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}

class StationDetailSheet extends StatelessWidget {
  final Map<String, dynamic> station;
  final ScrollController scrollController;

  const StationDetailSheet({
    super.key,
    required this.station,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> chargerTypes = List<String>.from(station[''] ?? []);
    final int available = station[''] ?? 0;

    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Drag handle
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 12),

            /// Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Station Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station['name'] ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colorPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        station['address'] ?? '',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Chip(
                            label: const Text(
                              'OPEN',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 0),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
                          ),
                          SizedBox(width: 8),
                          Text('24/7'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Reserve / Report
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.event_available, size: 20, color: colorPrimary),
                    SizedBox(width: 4),
                    Text("Reserve a spot"),
                    SizedBox(width: 8),
                    Chip(
                      label: const Text(
                        'New',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    )
                  ],
                ),
                Icon(Icons.help_outline, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // Report issue
              },
              child: const Row(
                children: [
                  Icon(Icons.report_problem_outlined, size: 20),
                  SizedBox(width: 8),
                  Text("Report an issue"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Availability Chips
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statusChip("Available", available, Colors.blue[900]!),
                _statusChip("Occupied", 0, Colors.amber[700]!),
                _statusChip("Unavailable", 0, Colors.red),
              ],
            ),

            const SizedBox(height: 16),

            const Divider(),

            /// Charger Type List (from strings)
            ...chargerTypes.map((type) => Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.electric_bolt, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            type,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    const Divider(),
                  ],
                )),

            const SizedBox(height: 16),

            /// Bottom "Navigate" Button
            ElevatedButton(
              onPressed: () {
                // Navigate
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Navigate',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                //
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Book',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String label, int count, Color color) {
    return Chip(
      backgroundColor: color.withOpacity(0.1),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          CircleAvatar(
            radius: 10,
            backgroundColor: color,
            child: Text(
              "$count",
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}
