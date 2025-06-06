import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nobile/Model/StationModel.dart';

class StationDetailsController extends GetxController {
  final String stationId;
  StationDetailsController(this.stationId);

  final Rx<ChargingStation?> station = Rx<ChargingStation?>(null);

  @override
  void onInit() {
    super.onInit();
    _listenToStation();
  }

  void _listenToStation() {
    FirebaseFirestore.instance
        .collection('chargingStations')
        .doc(stationId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        // Inject Firestore ID if not saved in document
        data['id'] = stationId;
        station.value = ChargingStation.fromJson(data);
      } else {
        station.value = null;
      }
    });
  }
}
