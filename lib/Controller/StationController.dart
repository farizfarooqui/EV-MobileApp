import 'dart:async';
import 'dart:developer';
import 'dart:math';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:nobile/Model/StationModel.dart';
import 'package:permission_handler/permission_handler.dart';

class StationController extends GetxController {
  final stations = <ChargingStation>[].obs;
  final filteredStations = <ChargingStation>[].obs;
  final isLoading = false.obs;
  RxString searchText = ''.obs;
  final RxBool showSearch = false.obs;
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxBool isLocating = false.obs;
  late final MapController mapController;
  late StreamSubscription<QuerySnapshot> _stationsSubscription;
  final TextEditingController searchController = TextEditingController();

  // Filter variables
  final selectedChargerTypes = <String>[].obs;
  final selectedAmenities = <String>[].obs;
  final selectedPaymentMethods = <String>[].obs;
  final minHourlyRate = 0.0.obs;
  final maxHourlyRate = 100.0.obs;
  final minPricePerKwh = 0.0.obs;
  final maxPricePerKwh = 100.0.obs;
  final openOnly = false.obs;
  final availableOnly = false.obs;

  // Update filter methods
  void updateChargerTypeFilter(List<String> types) {
    selectedChargerTypes.value = types;
    applyFilters();
  }

  void updateAmenitiesFilter(List<String> amenities) {
    selectedAmenities.value = amenities;
    applyFilters();
  }

  void updatePaymentMethodFilter(List<String> methods) {
    selectedPaymentMethods.value = methods;
    applyFilters();
  }

  void updateHourlyRateFilter(double min, double max) {
    minHourlyRate.value = min;
    maxHourlyRate.value = max;
    applyFilters();
  }

  void updatePricePerKwhFilter(double min, double max) {
    minPricePerKwh.value = min;
    maxPricePerKwh.value = max;
    applyFilters();
  }

  void updateOpenOnly(bool value) {
    openOnly.value = value;
    applyFilters();
  }

  void updateAvailableOnly(bool value) {
    availableOnly.value = value;
    applyFilters();
  }

  void clearFilters() {
    selectedChargerTypes.clear();
    selectedAmenities.clear();
    selectedPaymentMethods.clear();
    minHourlyRate.value = 0.0;
    maxHourlyRate.value = 100.0;
    minPricePerKwh.value = 0.0;
    maxPricePerKwh.value = 100.0;
    openOnly.value = false;
    availableOnly.value = false;
    applyFilters();
  }

  void applyFilters() {
    if (selectedChargerTypes.isEmpty &&
        selectedAmenities.isEmpty &&
        selectedPaymentMethods.isEmpty &&
        minHourlyRate.value == 0.0 &&
        maxHourlyRate.value == 100.0 &&
        minPricePerKwh.value == 0.0 &&
        maxPricePerKwh.value == 100.0 &&
        !openOnly.value &&
        !availableOnly.value) {
      // If no filters are applied, show all stations
      filteredStations.value = stations;
      return;
    }

    filteredStations.value = stations.where((station) {
      // Check charger types
      if (selectedChargerTypes.isNotEmpty) {
        final hasSelectedType = station.ports
            .any((port) => selectedChargerTypes.contains(port.type));
        if (!hasSelectedType) return false;
      }

      // Check amenities
      if (selectedAmenities.isNotEmpty) {
        final hasAllAmenities = selectedAmenities
            .every((amenity) => station.amenities.contains(amenity));
        if (!hasAllAmenities) return false;
      }

      // Check payment methods (assuming payment methods are stored in station data)
      if (selectedPaymentMethods.isNotEmpty) {
        // Add payment method check logic here
        // This depends on how payment methods are stored in your station data
      }

      // Check hourly rate
      final hasValidHourlyRate = station.ports.any((port) =>
          port.pricing >= minHourlyRate.value &&
          port.pricing <= maxHourlyRate.value);
      if (!hasValidHourlyRate) return false;

      // Check price per kWh
      final hasValidPricePerKwh = station.ports.any((port) =>
          port.pricing >= minPricePerKwh.value &&
          port.pricing <= maxPricePerKwh.value);
      if (!hasValidPricePerKwh) return false;

      // Check if station is open (24/7 or has operating hours)
      if (openOnly.value) {
        // Add open/closed check logic here
        // This depends on how operating hours are stored in your station data
      }

      // Check if station has available ports
      if (availableOnly.value) {
        final hasAvailablePorts = station.ports.any((port) =>
            port.isActive && port.slots.any((slot) => !slot.isBooked));
        if (!hasAvailablePorts) return false;
      }

      return true;
    }).toList();
  }

  Future<void> getCurrentLocation() async {
    try {
      isLocating.value = true;
      var status = await Permission.location.request();
      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        currentPosition.value = position;

        // Smooth animation to current location
        _animateToLocation(LatLng(position.latitude, position.longitude));
      } else {
        // log("Please grant location permission to use this feature.");
      }
    } catch (e) {
      // log("Error getting location: ${e.toString()}");
    } finally {
      isLocating.value = false;
    }
  }

  void _animateToLocation(LatLng targetLocation) {
    const Duration animationDuration = Duration(milliseconds: 1500);
    const int steps = 60; // 60 steps for smooth animation
    final Duration stepDuration =
        Duration(milliseconds: animationDuration.inMilliseconds ~/ steps);

    // Get current map position
    final currentCenter = mapController.camera.center;
    final currentZoom = mapController.camera.zoom;
    const targetZoom = 16.0;

    // Calculate the difference
    final latDiff = targetLocation.latitude - currentCenter.latitude;
    final lngDiff = targetLocation.longitude - currentCenter.longitude;
    final zoomDiff = targetZoom - currentZoom;

    Timer.periodic(stepDuration, (timer) {
      final progress = timer.tick / steps;
      final easedProgress = _easeInOutCubic(progress);

      final newLat = currentCenter.latitude + (latDiff * easedProgress);
      final newLng = currentCenter.longitude + (lngDiff * easedProgress);
      final newZoom = currentZoom + (zoomDiff * easedProgress);

      mapController.move(
        LatLng(newLat, newLng),
        newZoom,
      );

      if (timer.tick >= steps) {
        timer.cancel();
        // Ensure we end up exactly at the target location
        mapController.move(
          targetLocation,
          targetZoom,
        );

        // Add a subtle bounce effect by slightly zooming out and back in
        Timer(const Duration(milliseconds: 200), () {
          mapController.move(
            targetLocation,
            targetZoom - 0.5,
          );
          Timer(const Duration(milliseconds: 300), () {
            mapController.move(
              targetLocation,
              targetZoom,
            );
          });
        });
      }
    });
  }

  double _easeInOutCubic(double t) {
    return t < 0.5 ? 4 * t * t * t : 1 - pow(-2 * t + 2, 3) / 2;
  }

  void goToStation(Map<String, dynamic> station) {
    try {
      final location = station['location'] as GeoPoint;
      _animateToLocation(LatLng(location.latitude, location.longitude));
    } catch (e) {
      // log("Error moving to station: ${e.toString()}");
      Get.snackbar(
        'Error',
        'Could not navigate to station location',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void getStationsStream() {
    _stationsSubscription = FirebaseFirestore.instance
        .collection('chargingStations')
        .snapshots()
        .listen((snapshot) {
      stations.value = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add document ID to the data
        return ChargingStation.fromJson(data);
      }).toList();

      // Update filtered stations if there's a search query
      if (searchText.value.isNotEmpty) {
        filterStations(searchText.value);
      } else {
        filteredStations.value = stations;
      }
    }, onError: (error) {
      Get.snackbar('Error', 'Failed to fetch stations: $error');
    });
  }

  void filterStations(String query) {
    searchText.value = query;
    if (query.isEmpty) {
      applyFilters(); // Apply existing filters
    } else {
      final filtered = stations.where((station) {
        final name = station.stationName.toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
      filteredStations.value = filtered;
    }
  }

  getStationById(String id) {
    return stations.firstWhereOrNull((station) => station.id == id);
  }

  // Get total number of stations
  int get totalStations => stations.length;

  // Get number of active stations (stations with at least one active port)
  int get activeStations {
    return stations.where((station) {
      return station.ports.any((port) => port.isActive);
    }).length;
  }

  // Get total number of ports across all stations
  int get totalPorts {
    return stations.fold(0, (sum, station) => sum + station.numberOfPorts);
  }

  @override
  void onInit() {
    super.onInit();
    getStationsStream();
    mapController = MapController();
  }

  @override
  void onClose() {
    _stationsSubscription.cancel();
    super.onClose();
  }
}
