// booking_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Model/StationModel.dart';
import 'package:nobile/Service/UserPreferences.dart';

class BookingController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;

  List<Booking> allBookings = [];
  List<Booking> activeBookings = [];
  List<Booking> completedBookings = [];
  List<Booking> canceledBookings = [];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    fetchUserBookings();
  }

  Future<void> fetchUserBookings() async {
    final now = DateTime.now();

    final user = await UserPreferences.getUser();
    if (user == null || user['uid'] == null) return;

    final query = await FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: user['uid'])
        .orderBy('startTime', descending: true)
        .get();

    allBookings = query.docs.map((doc) {
      final data = doc.data();
      return Booking.fromJson(data);
    }).toList();

    activeBookings = allBookings
        .where((b) =>
            b.status.toLowerCase() == 'active' && b.endTime.compareTo(now) > 0)
        .toList();

    completedBookings = allBookings
        .where((b) =>
            b.status.toLowerCase() == 'active' && b.endTime.compareTo(now) <= 0)
        .toList();

    canceledBookings =
        allBookings.where((b) => b.status.toLowerCase() == 'canceled').toList();

    update(); // Notify UI
  }

  Future<bool> cancelBooking(String bookingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({
        'status': 'Canceled',
      });
      fetchUserBookings(); // Refresh list
      return true;
    } catch (e) {
      print("Cancel booking error: $e");
      return false;
    }
  }
}
