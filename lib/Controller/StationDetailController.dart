import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Model/StationModel.dart';
import 'package:nobile/Service/UserPreferences.dart';
import 'package:uuid/uuid.dart';

class StationDetailsController extends GetxController {
  final String stationId;
  StationDetailsController(this.stationId);

  final Rx<ChargingStation?> station = Rx<ChargingStation?>(null);

  @override
  void onInit() {
    super.onInit();
    _listenToStation();
  }

  final user = UserPreferences.getUser();

  void _listenToStation() {
    FirebaseFirestore.instance
        .collection('chargingStations')
        .doc(stationId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        station.value = ChargingStation.fromJson(data);
        log(station.value!.ports.toString());
      } else {
        station.value = null;
      }
    });
  }

  final RxMap<String, String?> selectedSlotPerPort = <String, String?>{}.obs;

  void selectSlot(String portId, String slotId) {
    selectedSlotPerPort[portId] = slotId;
  }

  Future<void> bookSlot({
    required String portId,
    required String slotId,
    required DateTime startTime,
    required DateTime endTime,
    required double totalPrice,
  }) async {
    final docRef = FirebaseFirestore.instance
        .collection('chargingStations')
        .doc(stationId);
    final docSnapshot = await docRef.get();
    final user = await UserPreferences.getUser();

    if (!docSnapshot.exists) return;

    final data = docSnapshot.data();
    if (data == null) return;

    final List<dynamic> ports = data['ports'];

    final bookingId = const Uuid().v4();

    final updatedPorts = ports.map((port) {
      if (port['id'] == portId) {
        final List<dynamic> slots = port['slots'];
        final updatedSlots = slots.map((slot) {
          if (slot['id'] == slotId) {
            return {
              ...slot,
              'isBooked': true,
              'bookingId': user?['uid'] ?? 0,
            };
          }
          return slot;
        }).toList();

        return {
          ...port,
          'slots': updatedSlots,
        };
      }
      return port;
    }).toList();
    await docRef.update({'ports': updatedPorts});
    // Get.back();
    // Get.snackbar(
    //   'Success',
    //   'Booking created successfully',
    //   snackPosition: SnackPosition.BOTTOM,
    //   backgroundColor: Colors.green,
    //   colorText: Colors.white,
    // );
    await FirebaseFirestore.instance.collection('bookings').doc(bookingId).set({
      'id': bookingId,
      'stationId': stationId,
      'portId': portId,
      'userId': user?['uid'],
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'status': 'Active',
      'createdAt': Timestamp.now(),
      'totalPrice': totalPrice,
    });

    log('✅ Slot booked and booking recorded with ID: $bookingId');
  }
}
