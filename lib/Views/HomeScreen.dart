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
import 'package:nobile/Views/Widgets/SmallLoader.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final StationController controller = Get.put(StationController());

  @override
  Widget build(BuildContext context) {
    final theme =
        Get.context != null ? Theme.of(Get.context!) : ThemeData.dark();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: IgnorePointer(
        ignoring: controller.isClosed,
        child: Opacity(
          opacity: controller.isClosed ? 0 : 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Obx(() => FloatingActionButton(
                      heroTag: null,
                      onPressed: controller.isLocating.value
                          ? null
                          : () {
                              controller.getCurrentLocation();
                            },
                      backgroundColor: theme.brightness == Brightness.dark
                          ? const Color(0xFF1E1E1E)
                          : Colors.white,
                      child: controller.isLocating.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: SmallLoader(
                                color: colorPrimary,
                              ),
                            )
                          : const Icon(
                              Icons.my_location,
                              color: colorPrimary,
                            ),
                    )),
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
                  backgroundColor: theme.brightness == Brightness.dark
                      ? const Color(0xFF1F1F1F)
                      // ? Colors.black
                      : Colors.white,
                  child: const Icon(
                    Icons.filter_list,
                    color: colorPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
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
                          child: const Icon(
                            Icons.ev_station,
                            color: Colors.white,
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
                      color: theme.brightness == Brightness.dark
                          ? const Color(0xFF1F1F1F)
                          // ? Colors.black
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.searchController,
                            autofocus: true,
                            decoration: InputDecoration(
                              fillColor: theme.brightness == Brightness.dark
                                  ? const Color(0xFF1F1F1F)
                                  // ? Colors.black
                                  : Colors.white,
                              hintText: 'Search stations...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
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
                          icon: const Icon(
                            Icons.close,
                            size: 20,
                          ),
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
                        elevation: 2,
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
                              color: theme.brightness == Brightness.dark
                                  ? const Color(0xFF1F1F1F)
                                  // ? Colors.black
                                  : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: theme.brightness == Brightness.dark
                                      ? const Color(0xFF1F1F1F)
                                      // ? Colors.black
                                      : Colors.white.withOpacity(0.1),
                                  blurRadius: 2,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                              border: Border.all(
                                color: theme.brightness == Brightness.dark
                                    ? const Color(0xFF1F1F1F)
                                    : Theme.of(context)
                                        .dividerColor
                                        .withOpacity(0.15),
                                width: 0.5,
                              ),
                            ),
                            child: Icon(
                              Icons.search,
                              color: theme.brightness == Brightness.dark
                                  ? Colors.green
                                  : Theme.of(context).iconTheme.color,
                            ),
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
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF1E1E1E) // Dark theme background
                          : Colors.white, // Light theme background
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
                              child: Text(
                                'No stations found',
                                style: TextStyle(color: Colors.grey),
                              ),
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
                                title: Text(
                                  station.stationName,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                subtitle: Text(
                                  '${station.city}, ${station.state}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1C1C1C) : Colors.white;
    final cardColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey;
    final dividerColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;

    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: SingleChildScrollView(
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
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: colorPrimary,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 20,
                                color: isDark ? Colors.grey[400] : colorGrey,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${station.address}, ${station.city}',
                          style: TextStyle(color: subtitleColor),
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
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            const SizedBox(width: 8),
                            Text('24/7', style: TextStyle(color: textColor)),
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
                  final currentStation = controller.stations.firstWhereOrNull(
                    (s) => s.id == station.id,
                  );
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
                      _statusChip(
                          "Available", availablePorts, Colors.blue[900]!),
                      _statusChip(
                          "Occupied", occupiedPorts, Colors.amber[700]!),
                      _statusChip("Total", totalPorts, Colors.grey[700]!),
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),
              Divider(color: dividerColor),

              /// Charging Ports
              Text(
                'Charging Ports',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
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
                        .map((port) => _buildPortCard(context, port))
                        .toList(),
                  );
                },
              ),

              const SizedBox(height: 16),
              Divider(color: dividerColor),

              /// Amenities
              if (station.amenities.isNotEmpty) ...[
                Text(
                  'Amenities',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: station.amenities
                      .map((amenity) => Chip(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey.shade600
                                    : colorPrimary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            label: Text(
                              amenity,
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey.shade100
                                    : colorPrimary,
                              ),
                            ),
                            backgroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade800
                                    : colorPrimary.withOpacity(0.1),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
              ],

              /// Action Buttons
              Row(
                children: [
                  Expanded(
                    child: _AnimatedActionButton(
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
                      icon: Icons.directions_car_filled,
                      label: 'Navigate',
                      backgroundColor: Colors.blue[600]!,
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      gradient: LinearGradient(
                        colors: [Colors.blue[600]!, Colors.blue[800]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _AnimatedActionButton(
                      onPressed: () {
                        Get.to(
                            () => StationDetailsScreen(stationId: station.id));
                        log("Station Id : ${station.id}");
                      },
                      icon: Icons.calendar_today_rounded,
                      label: 'Book Now',
                      backgroundColor: colorPrimary,
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      gradient: LinearGradient(
                        colors: [colorPrimary, colorPrimary.withOpacity(0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortCard(BuildContext context, ChargingPort port) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textColor = theme.colorScheme.onSurface;
    final backgroundBarColor = theme.brightness == Brightness.dark
        ? Colors.white.withOpacity(0.1)
        : Colors.grey[200];

    return Card(
      color: theme.brightness == Brightness.dark
          ? Colors.grey.shade900
          : Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Port Type and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  port.type,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColor,
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

            // Pricing and Slots
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price: \$${port.pricing.toStringAsFixed(2)}/kWh',
                  style: TextStyle(color: textColor),
                ),
                Text(
                  '${port.slotsPerDay} slots/day',
                  style: TextStyle(color: textColor),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Booking Progress Bar
            LinearProgressIndicator(
              value: port.slots.isEmpty
                  ? 0.0
                  : port.slots.where((slot) => slot.isBooked).length /
                      port.slots.length,
              backgroundColor: backgroundBarColor,
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
      shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.transparent,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8)),
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

class _AnimatedActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final Gradient? gradient;

  const _AnimatedActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
    this.gradient,
  });

  @override
  State<_AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<_AnimatedActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _iconAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _animationController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _animationController.reverse();
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: widget.gradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: widget.backgroundColor.withOpacity(0.3),
                    blurRadius: _isPressed ? 8 : 12,
                    offset: Offset(0, _isPressed ? 2 : 4),
                    spreadRadius: _isPressed ? 0 : 1,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: widget.onPressed,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _iconAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _iconAnimation.value,
                              child: Icon(
                                widget.icon,
                                color: widget.iconColor,
                                size: 24,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.label,
                          style: TextStyle(
                            color: widget.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
