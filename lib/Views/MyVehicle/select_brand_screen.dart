import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/my_vehicle_controller.dart';
import '../../Constants/Constants.dart';

class SelectBrandScreen extends StatelessWidget {
  SelectBrandScreen({Key? key}) : super(key: key);
  final MyVehicleController controller = Get.find();
  final RxString searchQuery = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorPrimary),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'Select Brand',
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
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search brands...',
                prefixIcon: Icon(Icons.search, color: colorPrimary),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colorPrimary, width: 2),
                ),
              ),
              onChanged: (value) => searchQuery.value = value,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final filteredBrands = controller.availableBrands
                  .where((brand) => brand.name
                      .toLowerCase()
                      .contains(searchQuery.value.toLowerCase()))
                  .toList();
              
              return ListView.builder(
                itemCount: filteredBrands.length,
                itemBuilder: (context, index) {
                  final brand = filteredBrands[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colorPrimary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.directions_car,
                          color: colorPrimary,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        brand.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        brand.country,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                        size: 16,
                      ),
                      onTap: () {
                        controller.selectBrand(brand);
                        Get.back();
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
