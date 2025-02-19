import 'package:get/get.dart';

class RouteController extends GetxController {
  var vehicles = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  // final CSVService _csvService = CSVService();

  // Future<void> loadVehicles() async {
  //   isLoading.value = true;
  //   try {
  //     var data = await _csvService.loadVehicleTrackingCSV();
  //     vehicles.value = data;
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to load CSV');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
