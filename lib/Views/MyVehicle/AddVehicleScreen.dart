import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/my_vehicle_controller.dart';
import '../../Constants/Constants.dart';
import '../../Model/VehicleModel.dart';
import '../../Model/PakistaniECarsData.dart';

class AddVehicleScreen extends StatelessWidget {
  AddVehicleScreen({super.key});
  final MyVehicleController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final theme =
        Get.context != null ? Theme.of(Get.context!) : ThemeData.dark();
    return Scaffold(
      backgroundColor: theme.brightness == Brightness.dark
          ? const Color(0xFF121212)
          : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorPrimary),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'Add Your Vehicle',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorPrimary,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Obx(() => _buildProgressIndicator()),
          ),

          // Content Area
          Expanded(
            child: Obx(() {
              switch (controller.currentStep.value) {
                case 0:
                  return _buildBrandSelection();
                case 1:
                  return _buildModelSelection();
                case 2:
                  return _buildVariantSelection();
                case 3:
                  return _buildVehicleDetails();
                default:
                  return _buildBrandSelection();
              }
            }),
          ),

          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(24),
            child: Obx(() => _buildNavigationButtons()),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(4, (index) {
        bool isActive = index <= controller.currentStep.value;
        bool isCompleted = index < controller.currentStep.value;

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? colorPrimary
                        : isActive
                            ? colorPrimary.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive
                          ? colorPrimary
                          : Colors.grey.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : isActive
                          ? Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: colorPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                ),
                const SizedBox(height: 8),
                Text(
                  ['Brand', 'Model', 'Variant', 'Details'][index],
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive ? colorPrimary : Colors.grey,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBrandSelection() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Your Vehicle Brand',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose from our curated list of Pakistani E-Cars',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: controller.availableBrands.length,
              itemBuilder: (context, index) {
                final brand = controller.availableBrands[index];
                return _buildBrandCard(brand, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandCard(VehicleBrand brand, context) {
    final theme =
        Get.context != null ? Theme.of(Get.context!) : ThemeData.dark();
    return GestureDetector(
      onTap: () => controller.selectBrand(brand),
      child: Container(
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? const Color(0xFF1E1E1E)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: colorPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.directions_car,
                color: colorPrimary,
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              brand.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              brand.country,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelSelection() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Your Vehicle Model',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${controller.selectedBrand.value?.name} Models',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: controller.modelsForSelectedBrand.length,
              itemBuilder: (context, index) {
                final model = controller.modelsForSelectedBrand[index];
                return _buildModelCard(model, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelCard(VehicleModel model, context) {
    final theme =
        Get.context != null ? Theme.of(Get.context!) : ThemeData.dark();
    return GestureDetector(
      onTap: () => controller.selectModel(model),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? const Color(0xFF1E1E1E)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.ev_station,
                color: colorPrimary,
                size: 40,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    model.category,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${model.variants.length} variants available',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantSelection() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Your Vehicle Variant',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${controller.selectedModel.value?.name} Variants',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: controller.variantsForSelectedModel.length,
              itemBuilder: (context, index) {
                final variant = controller.variantsForSelectedModel[index];
                return _buildVariantCard(variant, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantCard(VehicleVariant variant, context) {
    final theme =
        Get.context != null ? Theme.of(Get.context!) : ThemeData.dark();

    return GestureDetector(
      onTap: () => controller.selectVariant(variant),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? const Color(0xFF1E1E1E)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    variant.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'PKR ${(variant.price / 1000000).toStringAsFixed(1)}M',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colorPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSpecRow('Battery', variant.specs.batteryCapacity),
            _buildSpecRow('Range', variant.specs.range),
            _buildSpecRow('Power', variant.specs.power),
            _buildSpecRow('DC Charging', variant.charging.maxDCCharging),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleDetails() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vehicle Details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your vehicle information',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTextField(
                    label: 'Registration Number',
                    hint: 'ABC-123',
                    onChanged: controller.setRegistrationNumber,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Vehicle Color',
                    hint: 'e.g., White, Black, Red',
                    onChanged: controller.setVehicleColor,
                  ),
                  const SizedBox(height: 20),
                  _buildYearSelector(),
                  const SizedBox(height: 32),
                  _buildSelectedVehicleSummary(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorPrimary, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.05),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildYearSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Year of Manufacture',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.withOpacity(0.05),
          ),
          child: Obx(() => DropdownButton<int>(
                value: controller.yearOfManufacture.value,
                isExpanded: true,
                underline: const SizedBox(),
                items: List.generate(10, (index) {
                  int year = DateTime.now().year - index;
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year.toString()),
                  );
                }),
                onChanged: (value) {
                  if (value != null) controller.setYearOfManufacture(value);
                },
              )),
        ),
      ],
    );
  }

  Widget _buildSelectedVehicleSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorPrimary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Vehicle',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildSummaryRow('Brand', controller.selectedBrand.value?.name ?? ''),
          _buildSummaryRow('Model', controller.selectedModel.value?.name ?? ''),
          _buildSummaryRow(
              'Variant', controller.selectedVariant.value?.name ?? ''),
          _buildSummaryRow(
              'Range', controller.selectedVariant.value?.specs.range ?? ''),
          _buildSummaryRow('DC Charging',
              controller.selectedVariant.value?.charging.maxDCCharging ?? ''),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (controller.currentStep.value > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                controller.currentStep.value--;
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colorPrimary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Back',
                style: TextStyle(
                  color: colorPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (controller.currentStep.value > 0) const SizedBox(width: 16),
        Expanded(
          child: Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        if (controller.currentStep.value == 3) {
                          controller.saveVehicle();
                        } else if (controller.currentStep.value < 3) {
                          // Validate current step
                          if (_validateCurrentStep()) {
                            controller.currentStep.value++;
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        controller.currentStep.value == 3
                            ? 'Save Vehicle'
                            : 'Next',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              )),
        ),
      ],
    );
  }

  bool _validateCurrentStep() {
    switch (controller.currentStep.value) {
      case 0:
        return controller.selectedBrand.value != null;
      case 1:
        return controller.selectedModel.value != null;
      case 2:
        return controller.selectedVariant.value != null;
      default:
        return true;
    }
  }
}
