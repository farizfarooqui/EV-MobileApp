import 'package:get/get.dart';
import 'package:nobile/Service/UserPreferences.dart';
import '../Model/VehicleModel.dart';
import '../Model/PakistaniECarsData.dart';
import '../Service/VehicleService.dart';

class MyVehicleController extends GetxController {
  // Observable variables
  var selectedBrand = Rx<VehicleBrand?>(null);
  var selectedModel = Rx<VehicleModel?>(null);
  var selectedVariant = Rx<VehicleVariant?>(null);
  var userVehicles = <UserVehicle>[].obs;
  var isLoading = false.obs;
  var currentStep = 0.obs;

  // Form fields
  var registrationNumber = ''.obs;
  var vehicleColor = ''.obs;
  var yearOfManufacture = DateTime.now().year.obs;

  // Available brands from Pakistani E-Cars data
  List<VehicleBrand> get availableBrands => PakistaniECarsData.pakistaniECars;

  // Get models for selected brand
  List<VehicleModel> get modelsForSelectedBrand {
    if (selectedBrand.value == null) return [];
    return selectedBrand.value!.models;
  }

  // Get variants for selected model
  List<VehicleVariant> get variantsForSelectedModel {
    if (selectedModel.value == null) return [];
    return selectedModel.value!.variants;
  }

  void selectBrand(VehicleBrand brand) {
    selectedBrand.value = brand;
    selectedModel.value = null;
    selectedVariant.value = null;
    currentStep.value = 1;
  }

  void selectModel(VehicleModel model) {
    selectedModel.value = model;
    selectedVariant.value = null;
    currentStep.value = 2;
  }

  void selectVariant(VehicleVariant variant) {
    selectedVariant.value = variant;
    currentStep.value = 3;
  }

  void setRegistrationNumber(String number) {
    registrationNumber.value = number;
  }

  void setVehicleColor(String color) {
    vehicleColor.value = color;
  }

  void setYearOfManufacture(int year) {
    yearOfManufacture.value = year;
  }

  void reset() {
    selectedBrand.value = null;
    selectedModel.value = null;
    selectedVariant.value = null;
    registrationNumber.value = '';
    vehicleColor.value = '';
    yearOfManufacture.value = DateTime.now().year;
    currentStep.value = 0;
  }

  // Firebase operations
  Future<void> saveVehicle() async {
    if (selectedBrand.value == null ||
        selectedModel.value == null ||
        selectedVariant.value == null ||
        registrationNumber.value.isEmpty ||
        vehicleColor.value.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }
    try {
      isLoading.value = true;
      final user = await UserPreferences.getUser();
      String userId = user?['uid'] ?? '';
      
      if (userId.isEmpty) {
        Get.snackbar('Error', 'User not found. Please login again.');
        return;
      }

      final vehicle = UserVehicle(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        brandId: selectedBrand.value!.id,
        brandName: selectedBrand.value!.name,
        modelId: selectedModel.value!.id,
        modelName: selectedModel.value!.name,
        variantId: selectedVariant.value!.id,
        variantName: selectedVariant.value!.name,
        registrationNumber: registrationNumber.value,
        color: vehicleColor.value,
        yearOfManufacture: yearOfManufacture.value,
        addedAt: DateTime.now(),
        isDefault: userVehicles.isEmpty, // First vehicle becomes default
      );

      // Save to Firebase using service
      await VehicleService.saveUserVehicle(vehicle);

      // Add to local list
      userVehicles.add(vehicle);

      Get.snackbar(
        'Success',
        'Vehicle added successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Reset form
      reset();
    } catch (e) {
      Get.snackbar('Error', 'Failed to save vehicle: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadUserVehicles() async {
    try {
      isLoading.value = true;
      final user = await UserPreferences.getUser();
      String userId = user?['uid'] ?? '';
      
      if (userId.isEmpty) {
        Get.snackbar('Error', 'User not found. Please login again.');
        return;
      }
      
      userVehicles.value = await VehicleService.loadUserVehicles(userId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load vehicles: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteVehicle(String vehicleId) async {
    try {
      isLoading.value = true;
      final user = await UserPreferences.getUser();
      String userId = user?['uid'] ?? '';
      
      if (userId.isEmpty) {
        Get.snackbar('Error', 'User not found. Please login again.');
        return;
      }

      await VehicleService.deleteUserVehicle(userId, vehicleId);
      userVehicles.removeWhere((vehicle) => vehicle.id == vehicleId);

      Get.snackbar('Success', 'Vehicle deleted successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete vehicle: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setDefaultVehicle(String vehicleId) async {
    try {
      isLoading.value = true;

      final user = await UserPreferences.getUser();
      String userId = user?['uid'] ?? '';
      
      if (userId.isEmpty) {
        Get.snackbar('Error', 'User not found. Please login again.');
        return;
      }

      await VehicleService.setDefaultVehicle(userId, vehicleId);

      // Update local list
      for (int i = 0; i < userVehicles.length; i++) {
        userVehicles[i].isDefault = userVehicles[i].id == vehicleId;
      }

      Get.snackbar('Success', 'Default vehicle updated!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update default vehicle: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadUserVehicles();
  }
}
