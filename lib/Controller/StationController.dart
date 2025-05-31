import 'dart:async';
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
  late final MapController mapController;
  late StreamSubscription<QuerySnapshot> _stationsSubscription;
  final TextEditingController searchController = TextEditingController();

  Future<void> getCurrentLocation() async {
    try {
      var status = await Permission.location.request();
      if (status.isGranted) {
        // Get current position
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        currentPosition.value = position;
        mapController.move(
          LatLng(position.latitude, position.longitude),
          16.0,
        );
      } else {
        log("Please grant location permission to use this feature.");
      }
    } catch (e) {
      log("Error getting location: ${e.toString()}");
    }
  }

  void goToStation(Map<String, dynamic> station) {
    try {
      final location = station['location'] as GeoPoint;
      mapController.move(
        LatLng(location.latitude, location.longitude),
        16.0,
      );
    } catch (e) {
      log("Error moving to station: ${e.toString()}");
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
      filteredStations.value = stations;
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
