import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Constants/Constants.dart';
import 'package:nobile/Views/MainNavBar.dart';
import 'package:nobile/supabase_client.dart';
import 'package:nobile/Controller/theme_controller.dart';
// MyVehicle screens
import 'package:nobile/Views/MyVehicle/my_vehicle_screen.dart';
import 'package:nobile/Views/MyVehicle/select_brand_screen.dart';
import 'package:nobile/Views/MyVehicle/select_model_screen.dart';
import 'package:nobile/Views/MyVehicle/add_vehicle_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseManager.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    return Obx(() => GetMaterialApp(
      title: 'EV Mobile App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: colorPrimary,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: colorPrimary,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeController.themeMode,
      home: MainNavBar(),
      getPages: [
        GetPage(name: '/myVehicle', page: () => MyVehicleScreen()),
        GetPage(name: '/selectBrand', page: () => SelectBrandScreen()),
        GetPage(name: '/selectModel', page: () => SelectModelScreen()),
        GetPage(name: '/addVehicle', page: () => AddVehicleScreen()),
      ],
    ));
  }
}
