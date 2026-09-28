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

  const ParkingZone({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.availableSpots,
    required this.totalSpots,
    required this.hourlyPrice,
    required this.icon,
  });

  double get occupancy {
    if (totalSpots == 0) return 0;
    return (totalSpots - availableSpots) / totalSpots;
  }

  bool get isAvailable => availableSpots > 0;
}
