import 'package:flutter/material.dart';

import '../models/parking_zone.dart';
import '../theme/app_theme.dart';

class ParkingCard extends StatelessWidget {
  final ParkingZone zone;
  final VoidCallback onTap;

  const ParkingCard({super.key, required this.zone, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasSpots = zone.availableSpots > 0;
    final statusColor = zone.isOpen ? AppTheme.available : AppTheme.occupied;

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
                    Wrap(
                      spacing: 7,
                      runSpacing: 5,
                      children: [
                        _StatusPill(
                          color: statusColor,
                          label: zone.isOpen ? 'Aberto' : 'Fechado',
                        ),
                        _StatusPill(
                          color: hasSpots ? AppTheme.primary : AppTheme.occupied,
                          label: hasSpots
                              ? '${zone.availableSpots} vagas disponíveis'
                              : 'Sem vagas',
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

class _StatusPill extends StatelessWidget {
  final Color color;
  final String label;

  const _StatusPill({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
