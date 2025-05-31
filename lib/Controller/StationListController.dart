import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nobile/Model/StationModel.dart';

class StationController extends GetxController {
  final stations = <ChargingStation>[].obs;
  final filteredStations = <ChargingStation>[].obs;
  final isLoading = false.obs;
  RxString searchText = ''.obs;

  late StreamSubscription<QuerySnapshot> _stationsSubscription;

  @override
  void onInit() {
    super.onInit();
    _setupStationsStream();
  }

  @override
  void onClose() {
    _stationsSubscription.cancel();
    super.onClose();
  }

  void _setupStationsStream() {
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
        final city = station.city.toLowerCase();
        return name.contains(query.toLowerCase()) ||
            city.contains(query.toLowerCase());
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

  // Get number of available ports (ports that are not booked)
  int get availablePorts {
    return stations.fold(0, (sum, station) {
      return sum +
          station.ports.fold(0, (portSum, port) {
            return portSum + port.slots.where((slot) => !slot.isBooked).length;
          });
    });
  }

  // Calculate percentage change in stations since last month
  double get stationGrowthPercentage {
    // This is a placeholder. In a real app, you would compare with historical data
    return 12.0; // Example: 12% growth
  }
}
