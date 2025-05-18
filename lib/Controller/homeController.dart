import 'dart:developer';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:nobile/Model/ChargingStationModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class HomeController extends GetxController {
  late final MapController mapController;
  final RxList<ChargingStation> stations = <ChargingStation>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxList<String> selectedChargerTypes = <String>[].obs;
  final RxList<String> selectedVehicles = <String>[].obs;
  final RxList<String> selectedPorts = <String>[].obs;
  final RxList<String> selectedPaymentMethods = <String>[].obs;
  final RxDouble maxDistance = 10.0.obs;
  final RxBool showSearch = false.obs;
  final RxList<Map<String, dynamic>> searchResults =
      <Map<String, dynamic>>[].obs;
  final TextEditingController searchController = TextEditingController();

  final _supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    mapController = MapController();
    fetchStations();
  }

  Future<void> reloadStations() async {
    await fetchStations();
  }

  void goToStation(Map<String, dynamic> station) {
    hideSearchBar();
    mapController.move(
      LatLng(station['latitude'], station['longitude']),
      16.0,
    );
  }

  Future<void> fetchStations() async {
    isLoading.value = true;
    try {
      final response = await _supabase.from('stations').select();
      stations.value = (response as List)
          .map((json) => ChargingStation.fromJson(json as Map<String, dynamic>))
          .toList();
      log("Successfully fetched stations : ${stations.toList()}");
    } catch (e) {
      log("Falied to fetch: ${e.toString()}");
      toastification.show(
        context: Get.context!,
        title: const Text('Error'),
        description: Text(e.toString()),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.bottomRight,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // Filter stations based on selected criteria
  List<ChargingStation> get filteredStations {
    return stations.where((station) {
      // Search query filter
      if (searchQuery.value.isNotEmpty) {
        if (!station.name
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()) &&
            !station.address
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase())) {
          return false;
        }
      }

      // Charger type filter
      if (selectedChargerTypes.isNotEmpty) {
        if (!selectedChargerTypes
            .any((type) => station.chargerTypes.contains(type))) {
          return false;
        }
      }

      // Vehicle compatibility filter
      if (selectedVehicles.isNotEmpty) {
        if (!selectedVehicles.any((vehicle) =>
            station.compatibleVehicles?.contains(vehicle) ?? false)) {
          return false;
        }
      }

      // Charging port filter
      if (selectedPorts.isNotEmpty) {
        if (!selectedPorts
            .any((port) => station.chargingPorts?.contains(port) ?? false)) {
          return false;
        }
      }

      // Payment method filter
      if (selectedPaymentMethods.isNotEmpty) {
        if (!selectedPaymentMethods
            .any((method) => station.paymentMethods.contains(method))) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    update();
  }

  // Update filters
  void updateChargerTypeFilter(List<String> types) {
    selectedChargerTypes.value = types;
    update();
  }

  void updateVehicleFilter(List<String> vehicles) {
    selectedVehicles.value = vehicles;
    update();
  }

  void updatePortFilter(List<String> ports) {
    selectedPorts.value = ports;
    update();
  }

  void updatePaymentMethodFilter(List<String> methods) {
    selectedPaymentMethods.value = methods;
    update();
  }

  void updateMaxDistance(double distance) {
    maxDistance.value = distance;
    update();
  }

  // Clear all filters
  void clearFilters() {
    searchQuery.value = '';
    selectedChargerTypes.clear();
    selectedVehicles.clear();
    selectedPorts.clear();
    selectedPaymentMethods.clear();
    maxDistance.value = 10.0;
    update();
  }

  void onSearchChanged(String value) {
    searchResults.value = stations
        .where((station) =>
            station.name.toLowerCase().contains(value.toLowerCase()) ||
            station.address.toLowerCase().contains(value.toLowerCase()))
        .map((station) => station.toJson())
        .toList();
  }

  void showSearchBar() {
    showSearch.value = true;
  }

  void hideSearchBar() {
    showSearch.value = false;
    searchController.clear();
    searchResults.clear();
  }
}
