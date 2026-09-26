import 'package:flutter/material.dart';

import '../data/parking_data.dart';
import '../theme/app_theme.dart';
import '../widgets/parking_card.dart';
import '../widgets/section_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  void changePage(int index) {
    setState(() => currentIndex = index);

    if (index == 1) {
      Navigator.pushNamed(context, '/form');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, motorista!',
              style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
            Text(
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
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),

      // DRAWER: recurso Material adicional.
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),

                // BACKGROUND DO CABEÇALHO DO DRAWER:
                // Altere aqui a cor azul do menu lateral.
                color: AppTheme.primary,

                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.local_parking, color: Colors.white, size: 42),
                    SizedBox(height: 10),
                    Text(
                      'Urban Park',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                title: const Text('Cadastrar veículo'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/form');
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
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final int columns = constraints.maxWidth >= 900 ? 2 : 1;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),

                    // BACKGROUND DO BANNER PRINCIPAL:
                    // Altere aqui a cor de fundo do banner "Encontre sua vaga".
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
                  const SizedBox(height: 28),
                  const SectionTitle(title: 'Zonas próximas'),
                  const SizedBox(height: 14),

                  if (columns == 1)
                    ...ParkingData.zones.map(
                      (zone) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ParkingCard(
                          zone: zone,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/detail',
                              arguments: zone,
                            );
                          },
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
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/detail',
                              arguments: zone,
                            );
                          },
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
        onPressed: () => Navigator.pushNamed(context, '/form'),
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
