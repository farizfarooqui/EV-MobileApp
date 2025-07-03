import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Constants/Constants.dart';
import 'package:nobile/Views/MyVehicle/add_vehicle_screen.dart';
import '../../Controller/my_vehicle_controller.dart';
import '../../Model/VehicleModel.dart';

class MyVehicleScreen extends StatelessWidget {
  MyVehicleScreen({Key? key}) : super(key: key);
  final MyVehicleController controller = Get.put(MyVehicleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: colorPrimary),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'My Vehicles',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorPrimary,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.userVehicles.isEmpty) {
          return _buildEmptyState();
        } else {
          return _buildVehicleList();
        }
      }),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: colorPrimary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.directions_car,
            size: 60,
            color: colorPrimary,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'No Vehicles Added',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: colorPrimary,
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            'Add your vehicle to discover all its capabilities and get the best charging experience possible.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              onPressed: () {
                Get.to(() => AddVehicleScreen());
              },
              child: const Text(
                'Add Your First Vehicle',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Vehicles',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorPrimary,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Get.to(() => AddVehicleScreen());
                },
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  'Add Vehicle',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: controller.userVehicles.length,
            itemBuilder: (context, index) {
              final vehicle = controller.userVehicles[index];
              return _buildVehicleCard(vehicle, context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleCard(UserVehicle vehicle, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: colorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.directions_car,
                  color: colorPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${vehicle.brandName} ${vehicle.modelName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      vehicle.variantName,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (vehicle.isDefault)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Default',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colorPrimary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildVehicleInfo('Registration', vehicle.registrationNumber),
              const SizedBox(width: 24),
              _buildVehicleInfo('Color', vehicle.color),
              const SizedBox(width: 24),
              _buildVehicleInfo('Year', vehicle.yearOfManufacture.toString()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (!vehicle.isDefault)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => controller.setDefaultVehicle(vehicle.id),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colorPrimary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Set as Default',
                      style: TextStyle(color: colorPrimary),
                    ),
                  ),
                ),
              if (!vehicle.isDefault) const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.deleteVehicle(vehicle.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleInfo(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
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
}
