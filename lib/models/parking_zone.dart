import 'package:flutter/material.dart';

class ParkingZone {
  final String id;
  final String name;
  final String address;
  final String description;
  final int availableSpots;
  final int totalSpots;
  final double hourlyPrice;
  final IconData icon;
  final double latitude;
  final double longitude;
  final bool isOpen;

  const ParkingZone({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.availableSpots,
    required this.totalSpots,
    required this.hourlyPrice,
    required this.icon,
    this.latitude = -22.9056,
    this.longitude = -47.0608,
    this.isOpen = true,
  });

  double get occupancy {
    if (totalSpots == 0) return 0;
    return (totalSpots - availableSpots) / totalSpots;
  }

  bool get isAvailable => availableSpots > 0;

  ParkingZone copyWith({
    String? name,
    String? address,
    String? description,
    int? availableSpots,
    int? totalSpots,
    double? hourlyPrice,
    IconData? icon,
    double? latitude,
    double? longitude,
    bool? isOpen,
  }) {
    return ParkingZone(
      id: id,
      name: name ?? this.name,
      address: address ?? this.address,
      description: description ?? this.description,
      availableSpots: availableSpots ?? this.availableSpots,
      totalSpots: totalSpots ?? this.totalSpots,
      hourlyPrice: hourlyPrice ?? this.hourlyPrice,
      icon: icon ?? this.icon,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isOpen: isOpen ?? this.isOpen,
    );
  }
}
