import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../services/auth_session.dart';
import '../services/mock_app_data.dart';
import '../services/mock_auth_service.dart';
import '../theme/app_theme.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final _auth = MockAuthService();

  Future<void> _changeRole(AppUser user, UserRole role) async {
    if (user.email.toLowerCase() ==
        AuthSession.currentUser?.email.toLowerCase()) {
      return;
    }

    final changed = _auth.updateRole(user.email, role);
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          changed
              ? 'Perfil de ${user.name} atualizado para '
                  '${role == UserRole.admin ? 'Administrador' : 'Usuário comum'}.'
              : 'Não foi possível atualizar o perfil.',
        ),
      ),
    );
  }

  Future<void> _deleteUser(AppUser user) async {
    final currentEmail = AuthSession.currentUser?.email.toLowerCase();
    if (user.email.toLowerCase() == currentEmail) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir usuário?'),
        content: Text(
          'Deseja excluir a conta de ${user.name}? Os veículos e o histórico '
          'demonstrativo associados a essa conta também serão removidos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    final deleted = _auth.deleteUser(user.email);
    if (deleted) MockAppData.removeUserData(user.email);
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          deleted ? 'Usuário excluído.' : 'Não foi possível excluir o usuário.',
        ),
      ),
    );
  }

  void _openDetails(AppUser user) {
    Navigator.pushNamed(context, '/admin/user-details', arguments: user);
  }

  @override
  Widget build(BuildContext context) {
    final users = _auth.users;
    final currentEmail = AuthSession.currentUser?.email.toLowerCase();

    return Scaffold(
      appBar: AppBar(title: const Text('Administrar usuários')),
      body: users.isEmpty
          ? const Center(child: Text('Nenhum usuário cadastrado.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final user = users[index];
                final isCurrentUser = user.email.toLowerCase() == currentEmail;
                final isAdmin = user.role == UserRole.admin;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () => _openDetails(user),
                          leading: CircleAvatar(
                            backgroundColor: isAdmin
                                ? AppTheme.primary.withValues(alpha: .12)
                                : AppTheme.secondary.withValues(alpha: .18),
                            child: Icon(
                              isAdmin ? Icons.admin_panel_settings : Icons.person,
                              color: AppTheme.primary,
                            ),
                          ),
                          title: Text(
                            user.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${user.email}\n${isAdmin ? 'Administrador' : 'Usuário comum'}'
                            '${isCurrentUser ? ' · Você' : ''}',
                          ),
                          isThreeLine: true,
                          trailing: const Icon(Icons.chevron_right),
                        ),
                        const Divider(height: 1),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              PopupMenuButton<UserRole>(
                                enabled: !isCurrentUser,
                                tooltip: isCurrentUser
                                    ? 'Não é possível alterar seu próprio perfil'
                                    : 'Alterar perfil',
                                onSelected: (role) => _changeRole(user, role),
                                itemBuilder: (_) => const [
                                  PopupMenuItem(
                                    value: UserRole.standard,
                                    child: Text('Usuário comum'),
                                  ),
                                  PopupMenuItem(
                                    value: UserRole.admin,
                                    child: Text('Administrador'),
                                  ),
                                ],
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.manage_accounts, size: 18),
                                      const SizedBox(width: 6),
                                      Text(isAdmin ? 'Alterar para comum' : 'Tornar admin'),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                tooltip: isCurrentUser
                                    ? 'Não é possível excluir sua própria conta'
                                    : 'Excluir usuário',
                                onPressed: isCurrentUser
                                    ? null
                                    : () => _deleteUser(user),
                                icon: const Icon(Icons.delete_outline),
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class AdminUserDetailsScreen extends StatelessWidget {
  final AppUser user;

  const AdminUserDetailsScreen({super.key, required this.user});

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = MockAppData.vehiclesFor(user);
    final history = MockAppData.reservationsFor(user);

    return Scaffold(
      appBar: AppBar(title: const Text('Dados do usuário')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(user.name),
              subtitle: Text(
                '${user.email}\n'
                '${user.role == UserRole.admin ? 'Administrador' : 'Usuário comum'}',
              ),
              isThreeLine: true,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Veículos (${vehicles.length})',
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (vehicles.isEmpty)
            const Card(
              child: ListTile(
                leading: Icon(Icons.directions_car_outlined),
                title: Text('Nenhum veículo cadastrado.'),
              ),
            )
          else
            ...vehicles.map(
              (vehicle) => Card(
                child: ListTile(
                  leading: const Icon(Icons.directions_car),
                  title: Text(vehicle.plate),
                  subtitle: Text(vehicle.type),
                ),
              ),
            ),
          const SizedBox(height: 22),
          Text(
            'Histórico de reservas (${history.length})',
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (history.isEmpty)
            const Card(
              child: ListTile(
                leading: Icon(Icons.history),
                title: Text('Sem histórico disponível.'),
              ),
            )
          else
            ...history.map(
              (reservation) => Card(
                child: ListTile(
                  leading: const Icon(Icons.local_parking),
                  title: Text(reservation.zoneName),
                  subtitle: Text(
                    '${reservation.vehiclePlate} · '
                    '${_formatDate(reservation.reservedAt)}',
                  ),
                  trailing: Text(
                    'R\$ ${reservation.amount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
