
import 'package:flutter/material.dart';

import '../data/parking_data.dart';
import '../models/app_user.dart';
import '../services/auth_session.dart';
import '../theme/app_theme.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  void _logout(BuildContext context) {
    AuthSession.end();

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppUser? user = AuthSession.currentUser;

    if (user == null || user.role != UserRole.admin) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => _logout(context),
            child: const Text('Voltar ao login'),
          ),
        ),
      );
    }

    final total = ParkingData.zones.fold<int>(
      0,
      (sum, z) => sum + z.totalSpots,
    );

    final available = ParkingData.zones.fold<int>(
      0,
      (sum, z) => sum + z.availableSpots,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel administrativo'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Olá, ${user.name}',
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),

          Text(
            user.email,
            style: const TextStyle(
              color: AppTheme.textSecondary,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Administrador',
            style: TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Visão geral do estacionamento',
            style: TextStyle(
              color: AppTheme.textSecondary,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _Metric(
                  title: 'Vagas totais',
                  value: '$total',
                  icon: Icons.local_parking,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _Metric(
                  title: 'Disponíveis',
                  value: '$available',
                  icon: Icons.check_circle,
                  color: AppTheme.available,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            'Zonas cadastradas',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          ...ParkingData.zones.map(
            (z) => Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.local_parking),
                ),
                title: Text(z.name),
                subtitle: Text(
                  '${z.address}\n'
                  '${z.availableSpots} de ${z.totalSpots} vagas disponíveis',
                ),
                isThreeLine: true,
                trailing: Text(
                  'R\$ ${z.hourlyPrice.toStringAsFixed(2)}',
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Os indicadores acima utilizam dados mockados nesta versão.',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _Metric({
    required this.title,
    required this.value,
    required this.icon,
    this.color = AppTheme.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
