import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:nobile/Constants/Constants.dart';
import 'package:nobile/Controller/StationController.dart';
import 'package:nobile/Model/StationModel.dart';
import 'package:nobile/Views/StationDetailsScreen.dart';
import 'package:nobile/Views/StationFilterSheet.dart';
import 'package:url_launcher/url_launcher.dart';

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
              heroTag: null,
              onPressed: () {
                controller.getCurrentLocation();
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
              heroTag: null,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
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
                  markers: controller.filteredStations.map((station) {
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
                                stationJson: station.toJson(),
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
          // Search Bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Obx(() => controller.showSearch.value
                ? Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Theme.of(context).shadowColor.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.searchController,
                            autofocus: true,
                            decoration: const InputDecoration(
                              hintText: 'Search stations...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            onChanged: (value) {
                              controller.filterStations(value);
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            controller.searchController.clear();
                            controller.showSearch.value = false;
                            controller.filterStations('');
                          },
                        ),
                      ],
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Material(
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        elevation: 6,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            controller.showSearch.value = true;
                            controller.searchController.clear();
                            controller.filterStations('');
                          },
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
                    ],
                  )),
          ),
          // Search Results
          Obx(() => controller.showSearch.value
              ? Positioned(
                  top: MediaQuery.of(context).padding.top + 80,
                  left: 16,
                  right: 16,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Theme.of(context).shadowColor.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: controller.filteredStations.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('No stations found'),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.filteredStations.length,
                            itemBuilder: (context, index) {
                              final station =
                                  controller.filteredStations[index];
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
                                subtitle:
                                    Text('${station.city}, ${station.state}'),
                                onTap: () {
                                  controller.goToStation(station.toJson());
                                  controller.showSearch.value = false;
                                  controller.searchController.clear();
                                },
                              );
                            },
                          ),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}

class StationDetailSheet extends StatelessWidget {
  final Map<String, dynamic> stationJson;
  final ScrollController scrollController;
  final StationController controller = Get.find();

  StationDetailSheet({
    super.key,
    required this.stationJson,
    required this.scrollController,
  });

  ChargingStation get station => ChargingStation.fromJson(stationJson);

  @override
  Widget build(BuildContext context) {
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
                      GestureDetector(
                        onTap: () {
                          Get.to(() =>
                              StationDetailsScreen(stationId: station.id));
                          log("Station Id : ${station.id}");
                        },
                        child: Row(
                          children: [
                            Text(
                              station.stationName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: colorPrimary,
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_outlined)
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${station.address}, ${station.city}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Chip(
                            label: Text(
                              station.verified ? 'VERIFIED' : 'UNVERIFIED',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                            backgroundColor:
                                station.verified ? Colors.green : Colors.red,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 0),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                          ),
                          const SizedBox(width: 8),
                          const Text('24/7'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Station Status
            GetX<StationController>(
              builder: (controller) {
                // Find the current station in the controller's stations list
                final currentStation = controller.stations.firstWhereOrNull(
                  (s) => s.id == station.id,
                );

                // If station not found in controller, use the passed station
                final stationToUse = currentStation ?? station;

                final availablePorts =
                    stationToUse.ports.where((port) => port.isActive).length;
                final totalPorts = stationToUse.ports.length;
                final occupiedPorts = stationToUse.ports
                    .where((port) => port.slots.any((slot) => slot.isBooked))
                    .length;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statusChip("Available", availablePorts, Colors.blue[900]!),
                    _statusChip("Occupied", occupiedPorts, Colors.amber[700]!),
                    _statusChip("Total", totalPorts, Colors.grey[700]!),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),
            const Divider(),

            /// Charging Ports
            const Text(
              'Charging Ports',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            GetX<StationController>(
              builder: (controller) {
                final currentStation = controller.stations.firstWhereOrNull(
                  (s) => s.id == station.id,
                );
                final stationToUse = currentStation ?? station;

                return Column(
                  children: stationToUse.ports
                      .map((port) => _buildPortCard(port))
                      .toList(),
                );
              },
            ),

            const SizedBox(height: 16),
            const Divider(),

            /// Amenities
            if (station.amenities.isNotEmpty) ...[
              const Text(
                'Amenities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: station.amenities
                    .map((amenity) => Chip(
                          label: Text(amenity),
                          backgroundColor: colorPrimary.withOpacity(0.1),
                          labelStyle: TextStyle(color: colorPrimary),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
            ],

            /// Action Buttons
            OutlinedButton(
              onPressed: () async {
                final lat = station.location.latitude;
                final lng = station.location.longitude;
                final googleMapsUrl =
                    'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
                if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
                  await launchUrl(Uri.parse(googleMapsUrl),
                      mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Could not open Google Maps.')),
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: colorPrimary, width: 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 50),
                foregroundColor: colorPrimary,
              ),
              child: const Text(
                'Navigate',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Get.to(() => StationDetailsScreen(stationId: station.id));
                log("Station Id : ${station.id}");
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colorPrimary, width: 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 50),
                foregroundColor: colorPrimary,
              ),
              child: const Text(
                'Book Now',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortCard(ChargingPort port) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  port.type,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: port.isActive ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    port.isActive ? 'Active' : 'Inactive',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Price: \$${port.pricing.toStringAsFixed(2)}/kWh'),
                Text('${port.slotsPerDay} slots/day'),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: port.slots.isEmpty
                  ? 0.0
                  : port.slots.where((slot) => slot.isBooked).length /
                      port.slots.length,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                port.isActive ? Colors.green : Colors.red,
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
