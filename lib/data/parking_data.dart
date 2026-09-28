import 'package:flutter/material.dart';

import '../models/parking_zone.dart';

class ParkingData {
  static const List<ParkingZone> zones = [
    ParkingZone(
      id: 'Z01',
      name: 'Centro - Praça Central',
      address: 'Av. Central, 100',
      description: 'Zona de estacionamento rotativo localizada próxima à praça central e ao comércio.',
      availableSpots: 18,
      totalSpots: 40,
      hourlyPrice: 4.50,
      icon: Icons.location_city,
    ),
    ParkingZone(
      id: 'Z02',
      name: 'Centro - Rua Principal',
      address: 'Rua Principal, 250',
      description: 'Área de estacionamento rotativo próxima a lojas, restaurantes e serviços.',
      availableSpots: 7,
      totalSpots: 30,
      hourlyPrice: 5.00,
      icon: Icons.storefront,
    ),
    ParkingZone(
      id: 'Z03',
      name: 'Shopping',
      address: 'Rua das Flores, 800',
      description: 'Zona de estacionamento próxima ao centro comercial e pontos de transporte.',
      availableSpots: 25,
      totalSpots: 50,
      hourlyPrice: 3.50,
      icon: Icons.shopping_bag,
    ),
    ParkingZone(
      id: 'Z04',
      name: 'Terminal',
      address: 'Av. dos Trabalhadores, 50',
      description:
          'Área de estacionamento rotativo próxima ao terminal de transporte.',
      availableSpots: 3,
      totalSpots: 25,
      hourlyPrice: 4.00,
      icon: Icons.directions_bus,
    ),
  ];
}
