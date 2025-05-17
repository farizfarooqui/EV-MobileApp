import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Views/MyVehicle/add_vehicle_screen.dart';
import '../../Controllers/my_vehicle_controller.dart';

class SelectModelScreen extends StatelessWidget {
  SelectModelScreen({super.key});
  final MyVehicleController controller = Get.find();
  final RxString searchQuery = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        centerTitle: true,
        title: const Text('SELECT MODEL',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) => searchQuery.value = value,
              )),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              final models = controller.getModelsForSelectedBrand();
              final filteredModels = models
                  .where((m) =>
                      m.toLowerCase().contains(searchQuery.value.toLowerCase()))
                  .toList();
              return ListView.separated(
                itemCount: filteredModels.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final model = filteredModels[index];
                  return ListTile(
                    title: Text(model, style: const TextStyle(fontSize: 17)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      controller.selectModel(model);
                      Get.to(AddVehicleScreen());
                    },
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
