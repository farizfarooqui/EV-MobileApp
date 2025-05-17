class ChargingStation {
  final String id;
  final String name;
  final String address;
  final String? city;
  final String? state;
  final String? zip;
  final double latitude;
  final double longitude;
  final List<String> chargerTypes;
  final double? hourlyRate;
  final int? totalPorts;
  final String? description;
  final List<String> amenities;
  final List<String> paymentMethods;
  final List<String>? imageUrls;
  final bool isAvailable;

  // Old fields (optional for backward compatibility)
  final List<String>? compatibleVehicles;
  final List<String>? chargingPorts;
  final double? pricePerKWh;
  final int? totalSlots;
  final int? availableslots;

  ChargingStation({
    required this.id,
    required this.name,
    required this.address,
    this.city,
    this.state,
    this.zip,
    required this.latitude,
    required this.longitude,
    required this.chargerTypes,
    this.hourlyRate,
    this.totalPorts,
    this.description,
    required this.amenities,
    required this.paymentMethods,
    this.imageUrls,
    this.isAvailable = true,
    this.compatibleVehicles,
    this.chargingPorts,
    this.pricePerKWh,
    this.totalSlots,
    this.availableslots,
  });

  factory ChargingStation.fromJson(Map<String, dynamic> json) {
    double? parseNullableDouble(dynamic value) {
      if (value == null) return null;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      if (value is double) return value;
      return null;
    }
    int? parseNullableInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      if (value is double) return value.toInt();
      return null;
    }
    double parseDouble(dynamic value) {
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return value as double;
    }
    return ChargingStation(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
      latitude: parseDouble(json['latitude']),
      longitude: parseDouble(json['longitude']),
      chargerTypes: List<String>.from(json['chargertypes'] ?? []),
      hourlyRate: parseNullableDouble(json['hourlyrate']),
      totalPorts: parseNullableInt(json['totalports']),
      description: json['description'],
      amenities: List<String>.from(json['amenities'] ?? []),
      paymentMethods: List<String>.from(json['paymentmethods'] ?? []),
      imageUrls: json['imageurls'] != null
          ? List<String>.from(json['imageurls'])
          : null,
      isAvailable: json['isavailable'] ?? true,
      compatibleVehicles: json['compatiblevehicles'] != null
          ? List<String>.from(json['compatiblevehicles'])
          : null,
      chargingPorts: json['chargingports'] != null
          ? List<String>.from(json['chargingports'])
          : null,
      pricePerKWh: parseNullableDouble(json['priceperkwh']),
      totalSlots: parseNullableInt(json['totalslots']),
      availableslots: parseNullableInt(json['availableslots']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'zip': zip,
      'latitude': latitude,
      'longitude': longitude,
      'chargertypes': chargerTypes,
      'hourlyrate': hourlyRate,
      'totalports': totalPorts,
      'description': description,
      'amenities': amenities,
      'paymentmethods': paymentMethods,
      'imageurls': imageUrls,
      'isavailable': isAvailable,
      'compatiblevehicles': compatibleVehicles,
      'chargingports': chargingPorts,
      'priceperkwh': pricePerKWh,
      'totalslots': totalSlots,
      'availableslots': availableslots,
    };
  }
}
