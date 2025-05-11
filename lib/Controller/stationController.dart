import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';

class StationController extends GetxController {
  final RxList<Map<String, dynamic>> stations = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  final Databases databases = Databases(Client()
    ..setEndpoint('https://fra.cloud.appwrite.io/v1')
    ..setProject('682088f8000cbce0b9e5'));

  @override
  void onInit() {
    super.onInit();
    fetchStations();
  }

  Future<void> fetchStations() async {
    log('Fetchin stations...');
    try {
      final DocumentList documents = await databases.listDocuments(
        databaseId: '68208b9400392b708f6c',
        collectionId: '68208c0c002c30a85ef6',
      );
      stations.value = documents.documents.map((doc) => doc.data).toList();
      log(stations.toString());
    } catch (e) {
      print('Error fetching stations: $e');
      log('Error fetching stations: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
