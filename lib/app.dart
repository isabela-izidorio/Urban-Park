import 'package:flutter/material.dart';

import 'models/app_user.dart';
import 'models/parking_zone.dart';
import 'screens/admin_screen.dart';
import 'screens/admin_users_screen.dart';
import 'screens/admin_zone_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/form_screen.dart';
import 'screens/help_screen.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'screens/vehicles_screen.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

class EstacionamentoApp extends StatelessWidget {
  const EstacionamentoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Urban Park',
      theme: AppTheme.theme,
      initialRoute: '/welcome',
      routes: {
        '/welcome': (_) => const WelcomeScreen(),
        '/': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
        '/admin': (_) => const AdminScreen(),
        '/admin/users': (_) => const AdminUsersScreen(),
        '/form': (_) => const FormScreen(),
        '/vehicles': (_) => const VehiclesScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/history': (_) => const HistoryScreen(),
        '/help': (_) => const HelpScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/detail':
            final argument = settings.arguments;
            if (argument is ParkingZone) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => DetailScreen(zone: argument),
              );
            }
            break;
          case '/admin/zone':
            final argument = settings.arguments;
            if (argument is String) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => AdminZoneDetailsScreen(zoneId: argument),
              );
            }
            break;
          case '/admin/user-details':
            final argument = settings.arguments;
            if (argument is AppUser) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => AdminUserDetailsScreen(user: argument),
              );
            }
            break;
        }
        return null;
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Tela não encontrada')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 56, color: Colors.red),
                  const SizedBox(height: 12),
                  Text('Rota não cadastrada: ${settings.name ?? 'desconhecida'}'),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (_) => false,
                    ),
                    child: const Text('Voltar ao login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
