import 'package:cloud_firestore/cloud_firestore.dart';

class Slot {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final bool isBooked;
  final String? bookingId;

  Slot({
    required this.id,
    required this.startTime,
    required this.endTime,
    this.isBooked = false,
    this.bookingId,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    final startTime = (json['startTime'] as Timestamp).toDate();
    final endTime = (json['endTime'] as Timestamp).toDate();

    // Debug log
    print('Slot fromJson - Start: $startTime, End: $endTime');

    return Slot(
      id: json['id'] as String,
      startTime: startTime,
      endTime: endTime,
      isBooked: json['isBooked'] as bool? ?? false,
      bookingId: json['bookingId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'isBooked': isBooked,
      'bookingId': bookingId,
    };
  }

  Slot copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    bool? isBooked,
    String? bookingId,
  }) {
    return Slot(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isBooked: isBooked ?? this.isBooked,
      bookingId: bookingId ?? this.bookingId,
    );
  }
}

class Booking {
  final String id;
  final String? stationName;
  final String? address;

  final String stationId;
  final String portId;
  final String userId;
  final DateTime startTime;
  final DateTime endTime;
  final String status; // 'pending', 'approved', 'rejected', 'completed'
  final Timestamp createdAt;
  final Timestamp? updatedAt;
  final double totalPrice;

  Booking({
    required this.id,
    required this.stationName,
    required this.address,
    required this.stationId,
    required this.portId,
    required this.userId,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    required this.totalPrice,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      stationName: json['stationName'] ?? '',
      address: json['address'] ?? '',
      stationId: json['stationId'] ?? '',
      portId: json['portId'] ?? '',
      userId: json['userId'] ?? '',
      startTime: (json['startTime'] as Timestamp).toDate(),
      endTime: (json['endTime'] as Timestamp).toDate(),
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] ?? Timestamp.now(),
      updatedAt: json['updatedAt'],
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stationName': stationName,
      'address': address,
      'stationId': stationId,
      'portId': portId,
      'userId': userId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'totalPrice': totalPrice,
    };
  }
}

class ChargingPort {
  final String id;
  final String type;
  final String status;
  final double pricing;
  final bool isActive;
  final Timestamp lastUpdated;
  final List<Slot> slots;
  final int slotsPerDay;

  ChargingPort({
    required this.id,
    required this.type,
    required this.status,
    required this.pricing,
    required this.isActive,
    required this.lastUpdated,
    required this.slots,
    required this.slotsPerDay,
  });

  factory ChargingPort.fromJson(Map<String, dynamic> json) {
    final slotsRaw = json['slots'];
    List<Slot> parsedSlots = [];

    if (slotsRaw is List) {
      parsedSlots = slotsRaw
          .map((slot) => Slot.fromJson(slot as Map<String, dynamic>))
          .toList();
    }

    return ChargingPort(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      pricing: (json['pricing'] ?? 0).toDouble(),
      isActive: json['isActive'] ?? false,
      lastUpdated: json['lastUpdated'] ?? Timestamp.now(),
      slots: parsedSlots,
      slotsPerDay: json['slotsPerDay'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'status': status,
      'pricing': pricing,
      'isActive': isActive,
      'lastUpdated': lastUpdated,
      'slots': slots.map((slot) => slot.toJson()).toList(),
      'slotsPerDay': slotsPerDay,
    };
  }

  ChargingPort copyWith({
    String? id,
    String? type,
    String? status,
    double? pricing,
    bool? isActive,
    Timestamp? lastUpdated,
    List<Slot>? slots,
    int? slotsPerDay,
  }) {
    return ChargingPort(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      pricing: pricing ?? this.pricing,
      isActive: isActive ?? this.isActive,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      slots: slots ?? this.slots,
      slotsPerDay: slotsPerDay ?? this.slotsPerDay,
    );
  }
}

class ChargingStation {
  final String id;
  String stationName;
  String city;
  String state;
  String country;
  String address;
  String zipCode;
  String description;
  Timestamp createdAt;
  bool verified;
  String imageUrl;
  GeoPoint location;
  int numberOfPorts;
  List<ChargingPort> ports;
  List<String> amenities;

  ChargingStation({
    required this.id,
    required this.stationName,
    required this.city,
    required this.state,
    required this.country,
    required this.address,
    required this.zipCode,
    required this.description,
    required this.createdAt,
    required this.verified,
    required this.imageUrl,
    required this.location,
    required this.numberOfPorts,
    required this.ports,
    required this.amenities,
  });

  factory ChargingStation.fromJson(Map<String, dynamic> json) {
    return ChargingStation(
      id: json['id'] ?? '',
      stationName: json['stationName'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      address: json['address'] ?? '',
      zipCode: json['zipCode'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] ?? Timestamp.now(),
      verified: json['verified'] ?? false,
      imageUrl: json['imageUrl'] ?? '',
      location: json['location'] ?? const GeoPoint(0, 0),
      numberOfPorts: json['numberOfPorts'] ?? 0,
      ports: (() {
        final raw = json['ports'];
        if (raw is List) {
          return raw
              .map((portJson) => ChargingPort.fromJson(portJson))
              .toList()
              .cast<ChargingPort>();
        } else if (raw is Map) {
          return raw.values
              .map((portJson) => ChargingPort.fromJson(portJson))
              .toList()
              .cast<ChargingPort>();
        } else {
          return <ChargingPort>[];
        }
      })(),
      amenities: List<String>.from(json['amenities'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stationName': stationName,
      'city': city,
      'state': state,
      'country': country,
      'address': address,
      'zipCode': zipCode,
      'description': description,
      'createdAt': createdAt,
      'verified': verified,
      'imageUrl': imageUrl,
      'location': location,
      'numberOfPorts': numberOfPorts,
      'ports': ports.map((p) => p.toJson()).toList(),
      'amenities': amenities,
    };
  }
}
