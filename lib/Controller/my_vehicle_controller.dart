import 'package:get/get.dart';

class MyVehicleController extends GetxController {
  // Static list of brands and models
  final brands = [
    'Abarth', 'Aiways', 'Alfa Romeo', 'Alpine', 'Audi', 'Bentley', 'BMW', 'BYD', 'Cadillac', 'Citroen', 'CUPRA'
  ];

  final modelsByBrand = {
    'Aiways': ['U5', 'U6'],
    // Add more brand-model mappings as needed
  };

  // Selected brand/model
  var selectedBrand = ''.obs;
  var selectedModel = ''.obs;

  void selectBrand(String brand) {
    selectedBrand.value = brand;
    selectedModel.value = '';
  }

  void selectModel(String model) {
    selectedModel.value = model;
  }

  List<String> getModelsForSelectedBrand() {
    return modelsByBrand[selectedBrand.value] ?? [];
  }

  void reset() {
    selectedBrand.value = '';
    selectedModel.value = '';
  }
} 