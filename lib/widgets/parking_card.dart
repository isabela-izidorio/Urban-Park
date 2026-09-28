import 'package:flutter/material.dart';

import '../models/parking_zone.dart';
import '../theme/app_theme.dart';

class ParkingCard extends StatelessWidget {
  final ParkingZone zone;
  final VoidCallback onTap;

  const ParkingCard({super.key, required this.zone, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool available = zone.isAvailable;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,

                // BACKGROUND DO ÍCONE DO CARD:
                // Altere aqui para mudar o fundo circular do ícone.
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Icon(zone.icon, color: AppTheme.primary, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      zone.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      zone.address,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),

                          // BACKGROUND DO STATUS:
                          // Verde = disponível / vermelho = lotado.
                          decoration: BoxDecoration(
                            color: available
                                ? AppTheme.available.withValues(alpha: 0.12)
                                : AppTheme.occupied.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Text(
                            available
                                ? '${zone.availableSpots} vagas disponíveis'
                                : 'Sem vagas',
                            style: TextStyle(
                              color: available
                                  ? AppTheme.available
                                  : AppTheme.occupied,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
