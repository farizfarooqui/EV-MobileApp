import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Constants/Constants.dart';
import 'package:nobile/Controller/StationController.dart';

class StationFilterSheet extends StatelessWidget {
  StationFilterSheet({super.key});

  final StationController controller = Get.find<StationController>();

  // Predefined options for filters
  final List<String> chargerTypes = [
    'Type 1',
    'Type 2',
    'CCS',
    'CHAdeMO',
    'Tesla Supercharger',
  ];

  final List<String> amenities = [
    'Restroom',
    'Food & Beverage',
    'Shopping',
    'WiFi',
    'Rest Area',
    'Parking',
  ];

  final List<String> paymentMethods = [
    'Credit Card',
    'Debit Card',
    'Mobile Payment',
    'Cash',
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        final theme =
            Get.context != null ? Theme.of(Get.context!) : ThemeData.dark();
        return Obx(
          () => Container(
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? const Color(0xFF1F1F1F)
                  : Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Drag Handle
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? Colors.grey
                        : Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Filter Stations',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              controller.clearFilters();
                            },
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Filter Sections
                      // Charger Types
                      _buildSectionTitle('Charger Types'),
                      _buildMultiSelectChips(
                        chargerTypes,
                        controller.selectedChargerTypes,
                        (types) => controller.updateChargerTypeFilter(types),
                      ),
                      const SizedBox(height: 16),

                      // Amenities
                      _buildSectionTitle('Amenities'),
                      _buildMultiSelectChips(
                        amenities,
                        controller.selectedAmenities,
                        (amenities) =>
                            controller.updateAmenitiesFilter(amenities),
                      ),
                      const SizedBox(height: 16),

                      // Payment Methods
                      _buildSectionTitle('Payment Methods'),
                      _buildMultiSelectChips(
                        paymentMethods,
                        controller.selectedPaymentMethods,
                        (methods) =>
                            controller.updatePaymentMethodFilter(methods),
                      ),
                      const SizedBox(height: 16),

                      // Price Range
                      _buildSectionTitle('Price Range'),
                      Obx(() {
                        final minValue =
                            controller.minPricePerKwh.value.clamp(0.0, 100.0);
                        final maxValue = controller.maxPricePerKwh.value
                            .clamp(minValue, 100.0);

                        return Column(
                          children: [
                            RangeSlider(
                              values: RangeValues(minValue, maxValue),
                              min: 0,
                              max: 100,
                              divisions: 20,
                              labels: RangeLabels(
                                '\$${minValue.toStringAsFixed(2)}',
                                '\$${maxValue.toStringAsFixed(2)}',
                              ),
                              onChanged: (values) {
                                controller.updatePricePerKwhFilter(
                                  values.start,
                                  values.end,
                                );
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('\$${minValue.toStringAsFixed(2)}'),
                                  Text('\$${maxValue.toStringAsFixed(2)}'),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 16),

                      // Quick Filters
                      _buildSectionTitle('Quick Filters'),
                      _buildQuickFilters(),
                      const SizedBox(height: 16),
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Apply Filters',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          )),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMultiSelectChips(
    List<String> options,
    RxList<String> selectedOptions,
    Function(List<String>) onSelectionChanged,
  ) {
    final theme =
        Get.context != null ? Theme.of(Get.context!) : ThemeData.dark();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selectedOptions.contains(option);
        return FilterChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (selected) {
            final newSelection = List<String>.from(selectedOptions);
            if (selected) {
              newSelection.add(option);
            } else {
              newSelection.remove(option);
            }
            onSelectionChanged(newSelection);
          },
          backgroundColor: theme.brightness == Brightness.dark
              ? Colors.grey.shade800
              : Colors.white,
          selectedColor: colorPrimary.withOpacity(0.2),
          checkmarkColor: colorPrimary,
          labelStyle: TextStyle(
            color: isSelected
                ? colorPrimary
                : (theme.brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87),
          ),
          side: BorderSide(
            color: isSelected
                ? colorPrimary
                : (theme.brightness == Brightness.dark
                    ? Colors.grey.shade600
                    : Colors.black.withOpacity(0.1)),
            width: 1.5,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickFilters() {
    final theme =
        Get.context != null ? Theme.of(Get.context!) : ThemeData.dark();
    return Column(
      children: [
        Obx(() => SwitchListTile(
              title: const Text('Open Now'),
              value: controller.openOnly.value,
              onChanged: (value) => controller.updateOpenOnly(value),
              activeColor: colorPrimary,
              activeTrackColor: colorPrimary.withOpacity(0.4),
              inactiveThumbColor: theme.brightness == Brightness.dark
                  ? Colors.grey.shade600
                  : Colors.grey.shade400,
              inactiveTrackColor: theme.brightness == Brightness.dark
                  ? Colors.grey.shade800
                  : Colors.grey.shade300,
              trackOutlineColor: WidgetStatePropertyAll(
                theme.brightness == Brightness.dark
                    ? Colors.transparent
                    : Colors.white,
              ),
            )),
        Obx(() => SwitchListTile(
              title: const Text('Available Ports Only'),
              value: controller.availableOnly.value,
              onChanged: (value) => controller.updateAvailableOnly(value),
              activeColor: colorPrimary,
              activeTrackColor: colorPrimary.withOpacity(0.4),
              inactiveThumbColor: theme.brightness == Brightness.dark
                  ? Colors.grey.shade600
                  : Colors.grey.shade400,
              inactiveTrackColor: theme.brightness == Brightness.dark
                  ? Colors.grey.shade800
                  : Colors.grey.shade300,
              trackOutlineColor: WidgetStatePropertyAll(
                theme.brightness == Brightness.dark
                    ? Colors.transparent
                    : Colors.white,
              ),
            )),
      ],
    );
  }
}
