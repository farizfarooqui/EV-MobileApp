import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/VehicleModel.dart';

class VehicleService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user vehicle to Firebase
  static Future<void> saveUserVehicle(UserVehicle vehicle) async {
    try {
      await _firestore
          .collection('users')
          .doc(vehicle.userId)
          .collection('vehicles')
          .doc(vehicle.id)
          .set(vehicle.toJson());
    } catch (e) {
      throw Exception('Failed to save vehicle: $e');
    }
  }

  // Load user vehicles from Firebase
  static Future<List<UserVehicle>> loadUserVehicles(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .orderBy('addedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => UserVehicle.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to load vehicles: $e');
    }
  }

  // Delete user vehicle from Firebase
  static Future<void> deleteUserVehicle(String userId, String vehicleId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .doc(vehicleId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete vehicle: $e');
    }
  }

  // Update user vehicle in Firebase
  static Future<void> updateUserVehicle(UserVehicle vehicle) async {
    try {
      await _firestore
          .collection('users')
          .doc(vehicle.userId)
          .collection('vehicles')
          .doc(vehicle.id)
          .update(vehicle.toJson());
    } catch (e) {
      throw Exception('Failed to update vehicle: $e');
    }
  }

  // Set default vehicle
  static Future<void> setDefaultVehicle(String userId, String vehicleId) async {
    try {
      // First, remove default from all vehicles
      final vehiclesSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .get();

      final batch = _firestore.batch();

      for (var doc in vehiclesSnapshot.docs) {
        batch.update(doc.reference, {'isDefault': false});
      }

      // Set the selected vehicle as default
      batch.update(
        _firestore
            .collection('users')
            .doc(userId)
            .collection('vehicles')
            .doc(vehicleId),
        {'isDefault': true},
      );

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to set default vehicle: $e');
    }
  }

  // Get default vehicle
  static Future<UserVehicle?> getDefaultVehicle(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .where('isDefault', isEqualTo: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return UserVehicle.fromJson(snapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get default vehicle: $e');
    }
  }

  // Check if user has vehicles
  static Future<bool> hasVehicles(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check vehicles: $e');
    }
  }

  // Get vehicle count
  static Future<int> getVehicleCount(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .get();

      return snapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get vehicle count: $e');
    }
  }
}
