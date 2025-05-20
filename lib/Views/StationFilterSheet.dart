import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Controller/homeController.dart';
import 'package:nobile/Constants/Constants.dart';

class StationFilterSheet extends StatelessWidget {
  StationFilterSheet({super.key});
  final HomeController controller = Get.find();

  // Placeholder lists (replace with your actual data if available)
  final List<Map<String, dynamic>> connectorTypes = const [
    {
      'label': 'Tesla Supercharger',
      'icon': Icons.electric_car,
      'key': 'Tesla Supercharger'
    },
    {'label': 'CCS', 'icon': Icons.electric_bolt, 'key': 'CCS'},
    {'label': 'CHAdeMO', 'icon': Icons.electric_rickshaw, 'key': 'CHAdeMO'},
    {'label': 'Type 2', 'icon': Icons.electric_moped, 'key': 'Type 2'},
  ];

  final List<Map<String, dynamic>> amenities = const [
    {'label': 'Parking', 'icon': Icons.local_parking, 'key': 'Parking'},
    {'label': 'WiFi', 'icon': Icons.wifi, 'key': 'WiFi'},
    {'label': 'Shopping', 'icon': Icons.shopping_bag, 'key': 'Shopping'},
    {'label': 'Restrooms', 'icon': Icons.wc, 'key': 'Restrooms'},
    {'label': 'Dining/Food', 'icon': Icons.restaurant, 'key': 'Dining/Food'},
  ];

  final List<Map<String, dynamic>> paymentMethods = const [
    {
      'label': 'Credit/Debit Card',
      'icon': Icons.credit_card,
      'key': 'Credit/Debit Card'
    },
    {
      'label': 'Mobile Payment',
      'icon': Icons.phone_android,
      'key': 'Mobile Payment (Apple Pay, Google Pay)'
    },
    {'label': 'RFID Card/Tag', 'icon': Icons.nfc, 'key': 'RFID Card/Tag'},
    {'label': 'In-App Payment', 'icon': Icons.payment, 'key': 'In-App Payment'},
  ];

  final List<int> chargePowers = const [3, 11, 22, 43, 100, 350];
  final List<Map<String, dynamic>> stations = const [
    {'label': 'EVigo', 'key': 'evigo'},
    {'label': 'Partner Network', 'key': 'partner'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.6,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ListView(
        // mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle and Reset
          Center(
            child: Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'FILTERS',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 19,
                    letterSpacing: 1),
              ),
              const Spacer(),
              TextButton(
                onPressed: controller.clearFilters,
                child: const Text(
                  'Reset',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('CONNECTOR',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Obx(() => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: connectorTypes.map((type) {
                  final selected =
                      controller.selectedChargerTypes.contains(type['key']);
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(type['icon'],
                            size: 20,
                            color: selected ? Colors.white : colorPrimary),
                        const SizedBox(width: 6),
                        Text(type['label'],
                            style: TextStyle(
                                color: selected ? Colors.white : colorPrimary)),
                      ],
                    ),
                    selected: selected,
                    selectedColor: colorPrimary,
                    backgroundColor: colorNavBar,
                    onSelected: (val) {
                      final types =
                          List<String>.from(controller.selectedChargerTypes);
                      if (val) {
                        types.add(type['key']);
                      } else {
                        types.remove(type['key']);
                      }
                      controller.updateChargerTypeFilter(types);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  );
                }).toList(),
              )),
          const SizedBox(height: 16),
          Text('CHARGE POWER',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Obx(() {
            // Find the closest index for the current value
            int currentIndex = chargePowers.indexWhere(
                (v) => v.toDouble() == controller.maxDistance.value);
            if (currentIndex == -1) currentIndex = 0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '${chargePowers[currentIndex]} kW',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorPrimary,
                      fontSize: 18,
                    ),
                  ),
                ),
                Slider(
                  value: currentIndex.toDouble(),
                  min: 0,
                  max: (chargePowers.length - 1).toDouble(),
                  divisions: chargePowers.length - 1,
                  activeColor: colorPrimary,
                  inactiveColor: colorNavBar,
                  onChanged: (val) {
                    int idx = val.round();
                    controller.updateMaxDistance(chargePowers[idx].toDouble());
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: chargePowers
                      .map((power) => Text('$power kW',
                          style: const TextStyle(
                              fontSize: 12, color: colorPrimary)))
                      .toList(),
                ),
              ],
            );
          }),
          const SizedBox(height: 16),
          Text('STATIONS',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Obx(() => Column(
                children: stations.map((station) {
                  final selected =
                      controller.selectedChargerTypes.contains(station['key']);
                  return CheckboxListTile(
                    value: selected,
                    onChanged: (val) {
                      final types =
                          List<String>.from(controller.selectedChargerTypes);
                      if (val == true) {
                        types.add(station['key']);
                      } else {
                        types.remove(station['key']);
                      }
                      controller.updateChargerTypeFilter(types);
                    },
                    title: Text(station['label'],
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    controlAffinity: ListTileControlAffinity.trailing,
                    activeColor: colorPrimary,
                    contentPadding: EdgeInsets.zero,
                  );
                }).toList(),
              )),
          const SizedBox(height: 8),
          // Toggles
          // Obx(() => Column(
          //       children: [
          //         SwitchListTile(
          //           value: controller.openOnly.value,
          //           onChanged: controller.updateOpenOnly,
          //           title: const Text('Open only'),
          //           activeColor: colorPrimary,
          //           contentPadding: EdgeInsets.zero,
          //         ),
          //         SwitchListTile(
          //           value: controller.availableOnly.value,
          //           onChanged: controller.updateAvailableOnly,
          //           title: const Text('Available only'),
          //           activeColor: colorPrimary,
          //           contentPadding: EdgeInsets.zero,
          //         ),
          //         SwitchListTile(
          //           value: controller.freeOnly.value,
          //           onChanged: controller.updateFreeOnly,
          //           title: const Text('Free only'),
          //           activeColor: colorPrimary,
          //           contentPadding: EdgeInsets.zero,
          //         ),
          //       ],
          //     )),
          const SizedBox(height: 16),
          // Amenities
          const Text(
            'Amenities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: amenities.map((amenity) {
                  final selected =
                      controller.selectedAmenities.contains(amenity['key']);
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(amenity['icon'],
                            size: 20,
                            color: selected ? Colors.white : colorPrimary),
                        const SizedBox(width: 6),
                        Text(amenity['label'],
                            style: TextStyle(
                                color: selected ? Colors.white : colorPrimary)),
                      ],
                    ),
                    selected: selected,
                    selectedColor: colorPrimary,
                    backgroundColor: colorNavBar,
                    onSelected: (val) {
                      final amenities =
                          List<String>.from(controller.selectedAmenities);
                      if (val) {
                        amenities.add(amenity['key']);
                      } else {
                        amenities.remove(amenity['key']);
                      }
                      controller.updateAmenitiesFilter(amenities);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  );
                }).toList(),
              )),
          const SizedBox(height: 16),
          // Payment Methods
          const Text(
            'Payment Methods',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: paymentMethods.map((method) {
                  final selected =
                      controller.selectedPaymentMethods.contains(method['key']);
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(method['icon'],
                            size: 20,
                            color: selected ? Colors.white : colorPrimary),
                        const SizedBox(width: 6),
                        Text(method['label'],
                            style: TextStyle(
                                color: selected ? Colors.white : colorPrimary)),
                      ],
                    ),
                    selected: selected,
                    selectedColor: colorPrimary,
                    backgroundColor: colorNavBar,
                    onSelected: (val) {
                      final methods =
                          List<String>.from(controller.selectedPaymentMethods);
                      if (val) {
                        methods.add(method['key']);
                      } else {
                        methods.remove(method['key']);
                      }
                      controller.updatePaymentMethodFilter(methods);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  );
                }).toList(),
              )),
          const SizedBox(height: 16),
          // Price Range
          const Text(
            'Price Range',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Column(
                children: [
                  RangeSlider(
                    values: RangeValues(
                      controller.minPricePerKwh.value,
                      controller.maxPricePerKwh.value == double.infinity
                          ? 100
                          : controller.maxPricePerKwh.value,
                    ),
                    min: 0,
                    max: 100,
                    divisions: 20,
                    labels: RangeLabels(
                      '${controller.minPricePerKwh.value.toStringAsFixed(1)} €/kWh',
                      controller.maxPricePerKwh.value == double.infinity
                          ? '∞'
                          : '${controller.maxPricePerKwh.value.toStringAsFixed(1)} €/kWh',
                    ),
                    onChanged: (RangeValues values) {
                      controller.updatePricePerKwhFilter(
                        values.start,
                        values.end == 100 ? double.infinity : values.end,
                      );
                    },
                  ),
                ],
              )),
          const SizedBox(height: 16),
          // Hourly Rate Range
          const Text(
            'Hourly Rate',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Column(
                children: [
                  RangeSlider(
                    values: RangeValues(
                      controller.minHourlyRate.value,
                      controller.maxHourlyRate.value == double.infinity
                          ? 100
                          : controller.maxHourlyRate.value,
                    ),
                    min: 0,
                    max: 100,
                    divisions: 20,
                    labels: RangeLabels(
                      '${controller.minHourlyRate.value.toStringAsFixed(1)} €/h',
                      controller.maxHourlyRate.value == double.infinity
                          ? '∞'
                          : '${controller.maxHourlyRate.value.toStringAsFixed(1)} €/h',
                    ),
                    onChanged: (RangeValues values) {
                      controller.updateHourlyRateFilter(
                        values.start,
                        values.end == 100 ? double.infinity : values.end,
                      );
                    },
                  ),
                ],
              )),
          const SizedBox(height: 16),
          // View stations button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                controller.filterStations(
                  chargerTypes: controller.selectedChargerTypes,
                  amenities: controller.selectedAmenities,
                  paymentMethods: controller.selectedPaymentMethods,
                  minHourlyRate: controller.minHourlyRate.value,
                  maxHourlyRate: controller.maxHourlyRate.value,
                  minPricePerKwh: controller.minPricePerKwh.value,
                  maxPricePerKwh: controller.maxPricePerKwh.value,
                );
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorNavBar,
                foregroundColor: colorPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('View stations',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
