import 'package:flutter/material.dart';

import '../models/parking_zone.dart';

/// Dados demonstrativos das zonas cadastradas.
/// As coordenadas são fictícias e ficam próximas ao centro do mapa inicial.
class ParkingData {
  static final List<ParkingZone> zones = [
    const ParkingZone(
      id: 'Z01',
      name: 'Centro - Praça Central',
      address: 'Av. Central, 100',
      description:
          'Zona de estacionamento rotativo localizada próxima à praça central e ao comércio.',
      availableSpots: 18,
      totalSpots: 40,
      hourlyPrice: 4.50,
      icon: Icons.location_city,
      latitude: -22.9050,
      longitude: -47.0605,
      isOpen: true,
    ),
    const ParkingZone(
      id: 'Z02',
      name: 'Centro - Rua Principal',
      address: 'Rua Principal, 250',
      description:
          'Área de estacionamento rotativo próxima a lojas, restaurantes e serviços.',
      availableSpots: 7,
      totalSpots: 30,
      hourlyPrice: 5.00,
      icon: Icons.storefront,
      latitude: -22.9080,
      longitude: -47.0630,
      isOpen: true,
    ),
    const ParkingZone(
      id: 'Z03',
      name: 'Shopping',
      address: 'Rua das Flores, 800',
      description:
          'Zona de estacionamento próxima ao centro comercial e pontos de transporte.',
      availableSpots: 25,
      totalSpots: 50,
      hourlyPrice: 3.50,
      icon: Icons.shopping_bag,
      latitude: -22.9005,
      longitude: -47.0550,
      isOpen: false,
    ),
    const ParkingZone(
      id: 'Z04',
      name: 'Terminal',
      address: 'Av. dos Trabalhadores, 50',
      description:
          'Área de estacionamento rotativo próxima ao terminal de transporte.',
      availableSpots: 3,
      totalSpots: 25,
      hourlyPrice: 4.00,
      icon: Icons.directions_bus,
      latitude: -22.9100,
      longitude: -47.0570,
      isOpen: true,
    ),
  ];

  static ParkingZone? findById(String id) {
    for (final zone in zones) {
      if (zone.id == id) return zone;
    }
    return null;
  }

  static void add(ParkingZone zone) {
    zones.add(zone);
  }

  static bool update(ParkingZone updatedZone) {
    final index = zones.indexWhere((zone) => zone.id == updatedZone.id);
    if (index < 0) return false;
    zones[index] = updatedZone;
    return true;
  }
}
