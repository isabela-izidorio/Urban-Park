import 'package:flutter/material.dart';

import '../data/parking_data.dart';
import '../models/app_user.dart';
import '../services/auth_session.dart';
import '../theme/app_theme.dart';
import 'admin_zone_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  void _logout() {
    AuthSession.end();
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

  Future<void> _createZone() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const ZoneEditorScreen()),
    );
    if (created == true && mounted) setState(() {});
  }

  Future<void> _openZone(String zoneId) async {
    await Navigator.pushNamed(context, '/admin/zone', arguments: zoneId);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthSession.currentUser;

    if (user == null || user.role != UserRole.admin) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: _logout,
            child: const Text('Voltar ao login'),
          ),
        ),
      );
    }

    final total = ParkingData.zones.fold<int>(
      0,
      (sum, zone) => sum + zone.totalSpots,
    );
    final available = ParkingData.zones.fold<int>(
      0,
      (sum, zone) => sum + zone.availableSpots,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel administrativo'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createZone,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Nova zona'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        children: [
          Text(
            'Olá, ${user.name}',
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(user.email, style: const TextStyle(color: AppTheme.textSecondary)),
          const SizedBox(height: 6),
          const Text(
            'Administrador',
            style: TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 22),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFEAF2FF),
                child: Icon(Icons.manage_accounts, color: AppTheme.primary),
              ),
              title: const Text(
                'Administrar usuários',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Visualizar contas, alterar perfis e consultar dados dos usuários.',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/admin/users'),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Visão geral do estacionamento',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 26),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Zonas cadastradas',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton.icon(
                onPressed: _createZone,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...ParkingData.zones.map(
            (zone) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: ListTile(
                  onTap: () => _openZone(zone.id),
                  leading: CircleAvatar(
                    backgroundColor: (zone.isOpen
                            ? AppTheme.available
                            : AppTheme.occupied)
                        .withValues(alpha: .12),
                    child: Icon(
                      zone.icon,
                      color: zone.isOpen ? AppTheme.available : AppTheme.occupied,
                    ),
                  ),
                  title: Text(
                    zone.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${zone.address}\n'
                    '${zone.availableSpots}/${zone.totalSpots} vagas · '
                    '${zone.isOpen ? 'Aberto' : 'Fechado'}',
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Os dados desta versão são demonstrativos e permanecem apenas durante a execução do aplicativo.',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
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
            style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
          ),
          Text(title, style: const TextStyle(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
