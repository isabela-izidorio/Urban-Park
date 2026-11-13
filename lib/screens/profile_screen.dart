
import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../services/auth_session.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Busca os dados do usuário conectado.
    final AppUser? user = AuthSession.currentUser;

    // Verifica se existe uma sessão ativa.
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Perfil'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.account_circle_outlined,
                size: 64,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(height: 12),
              const Text('Nenhum usuário conectado.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (_) => false,
                  );
                },
                child: const Text('Ir para o login'),
              ),
            ],
          ),
        ),
      );
    }

    // Identifica o perfil da conta.
    final roleLabel = user.role == UserRole.admin
        ? 'Administrador'
        : 'Usuário padrão';

    // Gera as iniciais do nome.
    final initials = user.name.trim().isEmpty
        ? '?'
        : user.name
            .trim()
            .split(RegExp(r'\s+'))
            .take(2)
            .map((part) => part[0].toUpperCase())
            .join();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu perfil'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthSession.end();

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (_) => false,
              );
            },
          ),
        ],
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Cabeçalho do perfil.
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white,
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Nome da conta conectada.
                  Text(
                    user.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // E-mail da conta conectada.
                  Text(
                    user.email,
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      roleLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Informações pessoais.
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Nome'),
                    subtitle: Text(user.name),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('E-mail'),
                    subtitle: Text(user.email),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.badge_outlined),
                    title: const Text('Tipo de conta'),
                    subtitle: Text(roleLabel),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Opções do perfil.
            Card(
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.directions_car),
                    title: Text('Meus veículos'),
                    trailing: Icon(Icons.chevron_right),
                  ),

                  const Divider(height: 1),

                  const ListTile(
                    leading: Icon(Icons.history),
                    title: Text('Histórico'),
                    trailing: Icon(Icons.chevron_right),
                  ),

                  const Divider(height: 1),

                  const ListTile(
                    leading: Icon(Icons.help_outline),
                    title: Text('Ajuda'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
