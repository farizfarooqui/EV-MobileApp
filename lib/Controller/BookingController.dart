// booking_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Constants/Utils.dart';
import 'package:nobile/Model/StationModel.dart';

class BookingController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;
  final RxList<Booking> activeBookings = <Booking>[].obs;
  final RxList<Booking> completedBookings = <Booking>[].obs;
  final RxList<Booking> canceledBookings = <Booking>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    fetchUserBookings();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> fetchUserBookings() async {
    try {
      isLoading.value = true;
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final bookingsSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .get();

      final allBookings = bookingsSnapshot.docs
          .map((doc) => Booking.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Sort bookings into respective lists
      activeBookings.value = allBookings
          .where((booking) =>
              booking.status == 'approved' &&
              booking.endTime.isAfter(DateTime.now()))
          .toList();

      completedBookings.value = allBookings
          .where((booking) =>
              booking.status == 'completed' ||
              (booking.status == 'approved' &&
                  booking.endTime.isBefore(DateTime.now())))
          .toList();

      canceledBookings.value = allBookings
          .where((booking) => booking.status == 'canceled')
          .toList();
    } catch (e) {
      Utils.showError('Error', 'Failed to fetch bookings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createBooking({
    required String stationId,
    required String portId,
    required String slotId,
    required DateTime startTime,
    required DateTime endTime,
    required double totalPrice,
  }) async {
    try {
      isLoading.value = true;
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Create booking document
      final bookingRef = FirebaseFirestore.instance.collection('bookings').doc();
      final booking = Booking(
        id: bookingRef.id,
        stationId: stationId,
        portId: portId,
        userId: userId,
        startTime: startTime,
        endTime: endTime,
        status: 'pending',
        createdAt: Timestamp.now(),
        totalPrice: totalPrice,
      );

      // Update slot status
      final stationRef = FirebaseFirestore.instance
          .collection('chargingStations')
          .doc(stationId);
      
      final stationDoc = await stationRef.get();
      if (!stationDoc.exists) {
        throw Exception('Station not found');
      }

      final station = ChargingStation.fromJson({
        ...stationDoc.data()!,
        'id': stationDoc.id,
      });

      final portIndex = station.ports.indexWhere((p) => p.id == portId);
      if (portIndex == -1) {
        throw Exception('Port not found');
      }

      final slotIndex = station.ports[portIndex].slots.indexWhere((s) => s.id == slotId);
      if (slotIndex == -1) {
        throw Exception('Slot not found');
      }

      // Update slot in Firestore
      await stationRef.update({
        'ports.$portIndex.slots.$slotIndex.isBooked': true,
        'ports.$portIndex.slots.$slotIndex.bookingId': bookingRef.id,
      });

      // Save booking
      await bookingRef.set(booking.toJson());

      // Refresh bookings
      await fetchUserBookings();
      return true;
    } catch (e) {
      Utils.showError('Error', 'Failed to create booking: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    try {
      isLoading.value = true;
      final bookingRef = FirebaseFirestore.instance.collection('bookings').doc(bookingId);
      final bookingDoc = await bookingRef.get();
      
      if (!bookingDoc.exists) {
        throw Exception('Booking not found');
      }

      final booking = Booking.fromJson({...bookingDoc.data()!, 'id': bookingDoc.id});
      
      // Update booking status
      await bookingRef.update({
        'status': 'canceled',
        'updatedAt': Timestamp.now(),
      });

      // Update slot status
      final stationRef = FirebaseFirestore.instance
          .collection('chargingStations')
          .doc(booking.stationId);
      
      final stationDoc = await stationRef.get();
      if (!stationDoc.exists) {
        throw Exception('Station not found');
      }

      final station = ChargingStation.fromJson({
        ...stationDoc.data()!,
        'id': stationDoc.id,
      });

      final portIndex = station.ports.indexWhere((p) => p.id == booking.portId);
      if (portIndex == -1) {
        throw Exception('Port not found');
      }

      final slotIndex = station.ports[portIndex].slots.indexWhere((s) => s.bookingId == bookingId);
      if (slotIndex == -1) {
        throw Exception('Slot not found');
      }

      // Update slot in Firestore
      await stationRef.update({
        'ports.$portIndex.slots.$slotIndex.isBooked': false,
        'ports.$portIndex.slots.$slotIndex.bookingId': null,
      });

      // Refresh bookings
      await fetchUserBookings();
      return true;
    } catch (e) {
      Utils.showError('Error', 'Failed to cancel booking: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
