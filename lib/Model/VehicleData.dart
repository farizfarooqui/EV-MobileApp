import 'VehicleModel.dart';

class VehicleData {
  static List<VehicleBrand> pakistaniECars = [
    VehicleBrand(
      id: 'toyota',
      name: 'Toyota',
      logo: 'assets/icons/brands/toyota.png',
      country: 'Japan',
      models: [
        VehicleModel(
          id: 'toyota_bz4x',
          name: 'bZ4X',
          brandId: 'toyota',
          brandName: 'Toyota',
          year: 2024,
          category: 'SUV',
          image: 'assets/images/vehicles/toyota_bz4x.jpg',
          variants: [
            VehicleVariant(
              id: 'toyota_bz4x_fwd',
              name: 'FWD',
              modelId: 'toyota_bz4x',
              modelName: 'bZ4X',
              brandName: 'Toyota',
              price: 15000000, // 15M PKR
              image: 'assets/images/vehicles/toyota_bz4x_fwd.jpg',
              specs: VehicleSpecs(
                batteryCapacity: '71.4 kWh',
                range: '500 km',
                power: '150 kW',
                torque: '266 Nm',
                transmission: 'Single-speed',
                drivetrain: 'FWD',
                weight: '1920 kg',
                seatingCapacity: '5',
              ),
              charging: VehicleCharging(
                maxDCCharging: '150 kW',
                maxACCharging: '11 kW',
                connectors: ['CCS2', 'Type 2'],
                chargingTime: '30 min (0-80%)',
                autochargeCompatible: true,
                chargingPort: 'Front',
              ),
              performance: VehiclePerformance(
                acceleration: '7.5s',
                topSpeed: '160 km/h',
                efficiency: '14.3 kWh/100km',
                regenerativeBraking: 'Yes',
              ),
              dimensions: VehicleDimensions(
                length: '4690',
                width: '1860',
                height: '1650',
                wheelbase: '2850',
                groundClearance: '160',
                bootSpace: '452',
              ),
              features: VehicleFeatures(
                safetyFeatures: [
                  'Toyota Safety Sense 3.0',
                  'Pre-Collision System',
                  'Lane Departure Alert',
                  'Adaptive Cruise Control',
                  'Blind Spot Monitor',
                ],
                comfortFeatures: [
                  'Heated & Ventilated Seats',
                  'Dual Zone Climate Control',
                  'Panoramic Roof',
                  'Wireless Charging',
                ],
                technologyFeatures: [
                  '12.3-inch Touchscreen',
                  'Digital Instrument Cluster',
                  'Head-up Display',
                  '360° Camera',
                ],
                convenienceFeatures: [
                  'Smart Key System',
                  'Power Tailgate',
                  'Auto Parking',
                  'Remote Climate Control',
                ],
                infotainment: 'Toyota Multimedia System',
                connectivity: 'Apple CarPlay, Android Auto',
              ),
            ),
          ],
        ),
      ],
    ),
    VehicleBrand(
      id: 'mg',
      name: 'MG',
      logo: 'assets/icons/brands/mg.png',
      country: 'UK/China',
      models: [
        VehicleModel(
          id: 'mg_zs_ev',
          name: 'ZS EV',
          brandId: 'mg',
          brandName: 'MG',
          year: 2024,
          category: 'SUV',
          image: 'assets/images/vehicles/mg_zs_ev.jpg',
          variants: [
            VehicleVariant(
              id: 'mg_zs_ev_exclusive',
              name: 'Exclusive',
              modelId: 'mg_zs_ev',
              modelName: 'ZS EV',
              brandName: 'MG',
              price: 8500000, // 8.5M PKR
              image: 'assets/images/vehicles/mg_zs_ev_exclusive.jpg',
              specs: VehicleSpecs(
                batteryCapacity: '51.1 kWh',
                range: '320 km',
                power: '130 kW',
                torque: '280 Nm',
                transmission: 'Single-speed',
                drivetrain: 'FWD',
                weight: '1530 kg',
                seatingCapacity: '5',
              ),
              charging: VehicleCharging(
                maxDCCharging: '76 kW',
                maxACCharging: '7 kW',
                connectors: ['CCS2', 'Type 2'],
                chargingTime: '40 min (0-80%)',
                autochargeCompatible: false,
                chargingPort: 'Front',
              ),
              performance: VehiclePerformance(
                acceleration: '8.2s',
                topSpeed: '175 km/h',
                efficiency: '16.0 kWh/100km',
                regenerativeBraking: 'Yes',
              ),
              dimensions: VehicleDimensions(
                length: '4323',
                width: '1809',
                height: '1649',
                wheelbase: '2585',
                groundClearance: '150',
                bootSpace: '470',
              ),
              features: VehicleFeatures(
                safetyFeatures: [
                  'MG Pilot',
                  'Forward Collision Warning',
                  'Lane Keep Assist',
                  'Blind Spot Detection',
                  'Rear Cross Traffic Alert',
                ],
                comfortFeatures: [
                  'Leather Seats',
                  'Climate Control',
                  'Electric Sunroof',
                  'Heated Front Seats',
                ],
                technologyFeatures: [
                  '10.1-inch Touchscreen',
                  'Digital Instrument Cluster',
                  '360° Camera',
                  'Wireless Charging',
                ],
                convenienceFeatures: [
                  'Keyless Entry',
                  'Auto Headlights',
                  'Rain Sensing Wipers',
                  'Auto Hold',
                ],
                infotainment: 'MG iSMART',
                connectivity: 'Apple CarPlay, Android Auto',
              ),
            ),
          ],
        ),
      ],
    ),
    VehicleBrand(
      id: 'audi',
      name: 'Audi',
      logo: 'assets/icons/brands/audi.png',
      country: 'Germany',
      models: [
        VehicleModel(
          id: 'audi_e_tron',
          name: 'e-tron',
          brandId: 'audi',
          brandName: 'Audi',
          year: 2024,
          category: 'SUV',
          image: 'assets/images/vehicles/audi_e_tron.jpg',
          variants: [
            VehicleVariant(
              id: 'audi_e_tron_quattro',
              name: 'quattro',
              modelId: 'audi_e_tron',
              modelName: 'e-tron',
              brandName: 'Audi',
              price: 25000000, // 25M PKR
              image: 'assets/images/vehicles/audi_e_tron_quattro.jpg',
              specs: VehicleSpecs(
                batteryCapacity: '95 kWh',
                range: '484 km',
                power: '300 kW',
                torque: '664 Nm',
                transmission: 'Single-speed',
                drivetrain: 'AWD',
                weight: '2490 kg',
                seatingCapacity: '5',
              ),
              charging: VehicleCharging(
                maxDCCharging: '150 kW',
                maxACCharging: '11 kW',
                connectors: ['CCS2', 'Type 2'],
                chargingTime: '30 min (0-80%)',
                autochargeCompatible: true,
                chargingPort: 'Front',
              ),
              performance: VehiclePerformance(
                acceleration: '5.7s',
                topSpeed: '200 km/h',
                efficiency: '19.6 kWh/100km',
                regenerativeBraking: 'Yes',
              ),
              dimensions: VehicleDimensions(
                length: '4901',
                width: '1935',
                height: '1616',
                wheelbase: '2928',
                groundClearance: '170',
                bootSpace: '660',
              ),
              features: VehicleFeatures(
                safetyFeatures: [
                  'Audi Pre Sense',
                  'Adaptive Cruise Control',
                  'Lane Departure Warning',
                  'Blind Spot Monitor',
                  '360° Camera',
                ],
                comfortFeatures: [
                  'Valcona Leather Seats',
                  '4-Zone Climate Control',
                  'Panoramic Sunroof',
                  'Massage Seats',
                ],
                technologyFeatures: [
                  '12.3-inch Virtual Cockpit',
                  '10.1-inch Touchscreen',
                  '8.6-inch Climate Control',
                  'Head-up Display',
                ],
                convenienceFeatures: [
                  'Keyless Go',
                  'Power Tailgate',
                  'Auto Parking',
                  'Remote Climate Control',
                ],
                infotainment: 'MMI Navigation Plus',
                connectivity: 'Audi Connect, Apple CarPlay, Android Auto',
              ),
            ),
          ],
        ),
      ],
    ),
    VehicleBrand(
      id: 'bmw',
      name: 'BMW',
      logo: 'assets/icons/brands/bmw.png',
      country: 'Germany',
      models: [
        VehicleModel(
          id: 'bmw_ix',
          name: 'iX',
          brandId: 'bmw',
          brandName: 'BMW',
          year: 2024,
          category: 'SUV',
          image: 'assets/images/vehicles/bmw_ix.jpg',
          variants: [
            VehicleVariant(
              id: 'bmw_ix_xdrive50',
              name: 'xDrive50',
              modelId: 'bmw_ix',
              modelName: 'iX',
              brandName: 'BMW',
              price: 30000000, // 30M PKR
              image: 'assets/images/vehicles/bmw_ix_xdrive50.jpg',
              specs: VehicleSpecs(
                batteryCapacity: '111.5 kWh',
                range: '630 km',
                power: '385 kW',
                torque: '765 Nm',
                transmission: 'Single-speed',
                drivetrain: 'AWD',
                weight: '2440 kg',
                seatingCapacity: '5',
              ),
              charging: VehicleCharging(
                maxDCCharging: '195 kW',
                maxACCharging: '11 kW',
                connectors: ['CCS2', 'Type 2'],
                chargingTime: '35 min (0-80%)',
                autochargeCompatible: true,
                chargingPort: 'Front',
              ),
              performance: VehiclePerformance(
                acceleration: '4.6s',
                topSpeed: '200 km/h',
                efficiency: '17.7 kWh/100km',
                regenerativeBraking: 'Yes',
              ),
              dimensions: VehicleDimensions(
                length: '4953',
                width: '1967',
                height: '1696',
                wheelbase: '3000',
                groundClearance: '180',
                bootSpace: '500',
              ),
              features: VehicleFeatures(
                safetyFeatures: [
                  'BMW Driving Assistant Professional',
                  'Active Cruise Control',
                  'Lane Change Assistant',
                  'Emergency Stop Assistant',
                  '360° Camera',
                ],
                comfortFeatures: [
                  'Veganza Leather Seats',
                  '4-Zone Climate Control',
                  'Panoramic Sunroof',
                  'Massage Seats',
                ],
                technologyFeatures: [
                  '12.3-inch Instrument Display',
                  '14.9-inch Control Display',
                  'Head-up Display',
                  'Gesture Control',
                ],
                convenienceFeatures: [
                  'Comfort Access',
                  'Power Tailgate',
                  'Auto Parking',
                  'Remote Services',
                ],
                infotainment: 'BMW iDrive 8',
                connectivity: 'BMW Connected, Apple CarPlay, Android Auto',
              ),
            ),
          ],
        ),
      ],
    ),
    VehicleBrand(
      id: 'mercedes',
      name: 'Mercedes-Benz',
      logo: 'assets/icons/brands/mercedes.png',
      country: 'Germany',
      models: [
        VehicleModel(
          id: 'mercedes_eqe',
          name: 'EQE',
          brandId: 'mercedes',
          brandName: 'Mercedes-Benz',
          year: 2024,
          category: 'Sedan',
          image: 'assets/images/vehicles/mercedes_eqe.jpg',
          variants: [
            VehicleVariant(
              id: 'mercedes_eqe_350',
              name: '350+',
              modelId: 'mercedes_eqe',
              modelName: 'EQE',
              brandName: 'Mercedes-Benz',
              price: 28000000, // 28M PKR
              image: 'assets/images/vehicles/mercedes_eqe_350.jpg',
              specs: VehicleSpecs(
                batteryCapacity: '90.6 kWh',
                range: '660 km',
                power: '215 kW',
                torque: '565 Nm',
                transmission: 'Single-speed',
                drivetrain: 'RWD',
                weight: '2340 kg',
                seatingCapacity: '5',
              ),
              charging: VehicleCharging(
                maxDCCharging: '170 kW',
                maxACCharging: '11 kW',
                connectors: ['CCS2', 'Type 2'],
                chargingTime: '32 min (0-80%)',
                autochargeCompatible: true,
                chargingPort: 'Rear',
              ),
              performance: VehiclePerformance(
                acceleration: '6.4s',
                topSpeed: '210 km/h',
                efficiency: '13.7 kWh/100km',
                regenerativeBraking: 'Yes',
              ),
              dimensions: VehicleDimensions(
                length: '4946',
                width: '1961',
                height: '1512',
                wheelbase: '3120',
                groundClearance: '140',
                bootSpace: '430',
              ),
              features: VehicleFeatures(
                safetyFeatures: [
                  'Mercedes-Benz Driving Assistance Package',
                  'Active Distance Assist',
                  'Active Lane Change Assist',
                  'Active Blind Spot Assist',
                  '360° Camera',
                ],
                comfortFeatures: [
                  'Artico Leather Seats',
                  'THERMOTRONIC Climate Control',
                  'Panoramic Sunroof',
                  'Heated & Ventilated Seats',
                ],
                technologyFeatures: [
                  '12.3-inch Driver Display',
                  '12.8-inch Central Display',
                  'Head-up Display',
                  'MBUX Interior Assistant',
                ],
                convenienceFeatures: [
                  'KEYLESS-GO',
                  'Power Boot Lid',
                  'Auto Parking',
                  'Mercedes me Connect',
                ],
                infotainment: 'MBUX',
                connectivity: 'Mercedes me, Apple CarPlay, Android Auto',
              ),
            ),
          ],
        ),
      ],
    ),
  ];

  // Helper methods
  static VehicleBrand? getBrandById(String brandId) {
    try {
      return pakistaniECars.firstWhere((brand) => brand.id == brandId);
    } catch (e) {
      return null;
    }
  }

  static VehicleModel? getModelById(String modelId) {
    for (var brand in pakistaniECars) {
      try {
        return brand.models.firstWhere((model) => model.id == modelId);
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  static VehicleVariant? getVariantById(String variantId) {
    for (var brand in pakistaniECars) {
      for (var model in brand.models) {
        try {
          return model.variants
              .firstWhere((variant) => variant.id == variantId);
        } catch (e) {
          continue;
        }
      }
    }
    return null;
  }

  static List<VehicleBrand> searchBrands(String query) {
    return pakistaniECars
        .where(
            (brand) => brand.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  static List<VehicleModel> searchModels(String query) {
    List<VehicleModel> results = [];
    for (var brand in pakistaniECars) {
      results.addAll(brand.models.where(
          (model) => model.name.toLowerCase().contains(query.toLowerCase())));
    }
    return results;
  }
}
