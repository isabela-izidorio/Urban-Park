import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/form_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/profile_screen.dart';
import 'theme/app_theme.dart';
import 'models/parking_zone.dart';

class EstacionamentoApp extends StatelessWidget {
  const EstacionamentoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Urban Park',
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (_) => const WelcomeScreen(),
        '/home': (_) => const HomeScreen(),
        '/form': (_) => const FormScreen(),
        '/profile': (_) => const ProfileScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final zone = settings.arguments as ParkingZone;
          return MaterialPageRoute(builder: (_) => DetailScreen(zone: zone));
        }
        return null;
      },
    );
  }
}
