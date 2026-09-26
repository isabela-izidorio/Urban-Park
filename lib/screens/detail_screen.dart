import 'package:flutter/material.dart';

import '../models/parking_zone.dart';
import '../theme/app_theme.dart';

class DetailScreen extends StatelessWidget {
  final ParkingZone zone;

  const DetailScreen({super.key, required this.zone});

  @override
  Widget build(BuildContext context) {
    final bool available = zone.isAvailable;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da zona')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: constraints.maxWidth > 700 ? 300 : 220,
                    width: double.infinity,

                    // BACKGROUND DA IMAGEM/ILUSTRAÇÃO DOS DETALHES:
                    // Altere aqui o fundo da área superior da tela.
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(26),
                    ),

                    child: Icon(zone.icon, size: 100, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    zone.name,
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          zone.address,
                          style: const TextStyle(color: AppTheme.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoBox(
                          icon: Icons.local_parking,
                          title: 'Disponíveis',
                          value: '${zone.availableSpots}',
                          color: available
                              ? AppTheme.available
                              : AppTheme.occupied,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoBox(
                          icon: Icons.attach_money,
                          title: 'Por hora',
                          value: 'R\$ ${zone.hourlyPrice.toStringAsFixed(2)}',
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Sobre esta zona',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    zone.description,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton.icon(
                    onPressed: available
                        ? () => Navigator.pushNamed(
                            context,
                            '/form',
                            arguments: zone,
                          )
                        : null,
                    icon: const Icon(Icons.directions_car),
                    label: const Text('Cadastrar estacionamento'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _InfoBox({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      // BACKGROUND DOS QUADROS DE INFORMAÇÃO:
      // Altere Colors.white para outra cor se quiser mudar os cards.
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
