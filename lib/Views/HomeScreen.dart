import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:nobile/Constants/Constants.dart';
import 'package:nobile/Controller/homeController.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  void _goToStation(Map<String, dynamic> station) {
    homeController.hideSearchBar();
    _mapController.move(
      LatLng(station['latitude'], station['longitude']),
      16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            // Map Layer
            FlutterMap(
              mapController: _mapController,
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
                MarkerLayer(
                  markers: homeController.stations.map((station) {
                    return Marker(
                      point: LatLng(station.latitude, station.longitude),
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
              ],
            ),
            // Floating Search Icon
            Obx(() => !homeController.showSearch.value
                ? Positioned(
                    top: MediaQuery.of(context).padding.top + 16,
                    right: 24,
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      elevation: 6,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: homeController.showSearchBar,
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
            Obx(() => homeController.showSearch.value
                ? Positioned(
                    top: MediaQuery.of(context).padding.top + 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      children: [
                        Material(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(32),
                          child: TextField(
                            controller: homeController.searchController,
                            autofocus: true,
                            onChanged: homeController.onSearchChanged,
                            decoration: InputDecoration(
                              hintText: 'Search by station',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: homeController.hideSearchBar,
                              ),
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        homeController.searchController.text.isNotEmpty &&
                                homeController.searchResults.isNotEmpty
                            ? Container(
                                margin: const EdgeInsets.only(top: 8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .shadowColor
                                          .withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount:
                                      homeController.searchResults.length,
                                  separatorBuilder: (_, __) =>
                                      const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final station =
                                        homeController.searchResults[index];
                                    return ListTile(
                                      title: Text(station['name'] ?? ''),
                                      subtitle: Text(station['address'] ?? ''),
                                      onTap: () => _goToStation(station),
                                    );
                                  },
                                ),
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                  )
                : const SizedBox.shrink()),
          ],
        );
      }),
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
    final List<String> chargerTypes =
        List<String>.from(station['charger_types'] ?? []);
    final int available = station['total_charging_ports'] ?? 0;

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
