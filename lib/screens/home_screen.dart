import 'package:flutter/material.dart';

import '../data/parking_data.dart';
import '../models/app_user.dart';
import '../services/auth_session.dart';
import '../theme/app_theme.dart';
import '../widgets/nearby_parking_map.dart';
import '../widgets/parking_card.dart';
import '../widgets/section_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  Future<void> changePage(int index) async {
    if (index == 0) {
      setState(() => currentIndex = 0);
      return;
    }

    setState(() => currentIndex = index);

    if (index == 1) {
      await Navigator.pushNamed(context, '/vehicles');
    } else if (index == 2) {
      await Navigator.pushNamed(context, '/profile');
    }

    if (mounted) setState(() => currentIndex = 0);
  }

  void _logout() {
    AuthSession.end();
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final AppUser? user = AuthSession.currentUser;

    if (user == null || user.role != UserRole.standard) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: _logout,
            child: const Text('Voltar ao login'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, ${user.name}!',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const Text(
              'Encontre sua vaga',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Sair',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                color: AppTheme.primary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.local_parking,
                      color: Colors.white,
                      size: 42,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Urban Park',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(user.name, style: const TextStyle(color: Colors.white)),
                    Text(user.email, style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text('Início'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.directions_car_outlined),
                title: const Text('Meus veículos'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/vehicles');
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Perfil'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sair da conta'),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 900 ? 2 : 1;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Estacione sem complicação',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Consulte zonas e encontre vagas disponíveis.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.local_parking,
                          color: Colors.white,
                          size: 62,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const SectionTitle(title: 'Estacionamentos no mapa'),
                  const SizedBox(height: 12),
                  const NearbyParkingMap(),
                  const SizedBox(height: 26),
                  const SectionTitle(title: 'Zonas próximas'),
                  const SizedBox(height: 14),
                  if (columns == 1)
                    ...ParkingData.zones.map(
                      (zone) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ParkingCard(
                          zone: zone,
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/detail',
                            arguments: zone,
                          ),
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 2.1,
                      ),
                      itemCount: ParkingData.zones.length,
                      itemBuilder: (_, index) {
                        final zone = ParkingData.zones[index];
                        return ParkingCard(
                          zone: zone,
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/detail',
                            arguments: zone,
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Meus veículos',
        onPressed: () => Navigator.pushNamed(context, '/vehicles'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: changePage,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_car_outlined),
            selectedIcon: Icon(Icons.directions_car),
            label: 'Veículo',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
