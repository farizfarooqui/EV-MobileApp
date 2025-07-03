class VehicleBrand {
  final String id;
  final String name;
  final String logo;
  final String country;
  final List<VehicleModel> models;

  VehicleBrand({
    required this.id,
    required this.name,
    required this.logo,
    required this.country,
    required this.models,
  });
}

class VehicleModel {
  final String id;
  final String name;
  final String brandId;
  final String brandName;
  final int year;
  final List<VehicleVariant> variants;
  final String image;
  final String category; // SUV, Sedan, Hatchback, etc.

  VehicleModel({
    required this.id,
    required this.name,
    required this.brandId,
    required this.brandName,
    required this.year,
    required this.variants,
    required this.image,
    required this.category,
  });
}

class VehicleVariant {
  final String id;
  final String name;
  final String modelId;
  final String modelName;
  final String brandName;
  final VehicleSpecs specs;
  final VehicleCharging charging;
  final VehiclePerformance performance;
  final VehicleDimensions dimensions;
  final VehicleFeatures features;
  final double price; // In PKR
  final String image;

  VehicleVariant({
    required this.id,
    required this.name,
    required this.modelId,
    required this.modelName,
    required this.brandName,
    required this.specs,
    required this.charging,
    required this.performance,
    required this.dimensions,
    required this.features,
    required this.price,
    required this.image,
  });
}

class VehicleSpecs {
  final String batteryCapacity; // kWh
  final String range; // km
  final String power; // kW
  final String torque; // Nm
  final String transmission;
  final String drivetrain; // FWD, RWD, AWD
  final String weight; // kg
  final String seatingCapacity;

  VehicleSpecs({
    required this.batteryCapacity,
    required this.range,
    required this.power,
    required this.torque,
    required this.transmission,
    required this.drivetrain,
    required this.weight,
    required this.seatingCapacity,
  });
}

class VehicleCharging {
  final String maxDCCharging; // kW
  final String maxACCharging; // kW
  final List<String> connectors;
  final String chargingTime; // 0-80% or 0-100%
  final bool autochargeCompatible;
  final String chargingPort; // Location: Front, Side, etc.

  VehicleCharging({
    required this.maxDCCharging,
    required this.maxACCharging,
    required this.connectors,
    required this.chargingTime,
    required this.autochargeCompatible,
    required this.chargingPort,
  });
}

class VehiclePerformance {
  final String acceleration; // 0-100 km/h
  final String topSpeed; // km/h
  final String efficiency; // Wh/km
  final String regenerativeBraking;

  VehiclePerformance({
    required this.acceleration,
    required this.topSpeed,
    required this.efficiency,
    required this.regenerativeBraking,
  });
}

class VehicleDimensions {
  final String length; // mm
  final String width; // mm
  final String height; // mm
  final String wheelbase; // mm
  final String groundClearance; // mm
  final String bootSpace; // L

  VehicleDimensions({
    required this.length,
    required this.width,
    required this.height,
    required this.wheelbase,
    required this.groundClearance,
    required this.bootSpace,
  });
}

class VehicleFeatures {
  final List<String> safetyFeatures;
  final List<String> comfortFeatures;
  final List<String> technologyFeatures;
  final List<String> convenienceFeatures;
  final String infotainment;
  final String connectivity;

  VehicleFeatures({
    required this.safetyFeatures,
    required this.comfortFeatures,
    required this.technologyFeatures,
    required this.convenienceFeatures,
    required this.infotainment,
    required this.connectivity,
  });
}

class UserVehicle {
  final String id;
  final String userId;
  final String brandId;
  final String brandName;
  final String modelId;
  final String modelName;
  final String variantId;
  final String variantName;
  final String registrationNumber;
  final String color;
  final int yearOfManufacture;
  final DateTime addedAt;
  bool isDefault;

  UserVehicle({
    required this.id,
    required this.userId,
    required this.brandId,
    required this.brandName,
    required this.modelId,
    required this.modelName,
    required this.variantId,
    required this.variantName,
    required this.registrationNumber,
    required this.color,
    required this.yearOfManufacture,
    required this.addedAt,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'brandId': brandId,
      'brandName': brandName,
      'modelId': modelId,
      'modelName': modelName,
      'variantId': variantId,
      'variantName': variantName,
      'registrationNumber': registrationNumber,
      'color': color,
      'yearOfManufacture': yearOfManufacture,
      'addedAt': addedAt.toIso8601String(),
      'isDefault': isDefault,
    };
  }

  factory UserVehicle.fromJson(Map<String, dynamic> json) {
    return UserVehicle(
      id: json['id'],
      userId: json['userId'],
      brandId: json['brandId'],
      brandName: json['brandName'],
      modelId: json['modelId'],
      modelName: json['modelName'],
      variantId: json['variantId'],
      variantName: json['variantName'],
      registrationNumber: json['registrationNumber'],
      color: json['color'],
      yearOfManufacture: json['yearOfManufacture'],
      addedAt: DateTime.parse(json['addedAt']),
      isDefault: json['isDefault'] ?? false,
    );
  }
}
