import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../models/parking_zone.dart';
import '../models/reservation.dart';
import '../models/vehicle.dart';
import '../services/auth_session.dart';
import '../services/mock_app_data.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  Future<void> _removeVehicle(AppUser user, Vehicle vehicle) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remover veículo?'),
        content: Text('Deseja remover a placa ${vehicle.plate} da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Remover', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => MockAppData.removeVehicle(user, vehicle.id));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veículo removido.')),
      );
    }
  }

  Future<void> _reserveVehicle(
    AppUser user,
    Vehicle vehicle,
    ParkingZone zone,
  ) async {
    String selectedDuration = '1';

    final duration = await showDialog<int>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Confirmar reserva'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Veículo: ${vehicle.plate} (${vehicle.type})'),
              const SizedBox(height: 8),
              Text('Estacionamento: ${zone.name}'),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selectedDuration,
                decoration: const InputDecoration(
                  labelText: 'Tempo de permanência',
                  prefixIcon: Icon(Icons.access_time),
                ),
                items: const [
                  DropdownMenuItem(value: '1', child: Text('1 hora')),
                  DropdownMenuItem(value: '2', child: Text('2 horas')),
                  DropdownMenuItem(value: '3', child: Text('3 horas')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() => selectedDuration = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              Text(
                'Valor por hora: R\$ ${zone.hourlyPrice.toStringAsFixed(2)}',
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(
                dialogContext,
                int.parse(selectedDuration),
              ),
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ),
    );

    if (duration == null || !mounted) return;

    final total = zone.hourlyPrice * duration;
    final reservation = Reservation(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      vehiclePlate: vehicle.plate,
      vehicleType: vehicle.type,
      zoneId: zone.id,
      zoneName: zone.name,
      amount: total,
      durationHours: duration,
      reservedAt: DateTime.now(),
    );

    MockAppData.addReservation(user, reservation);

    await NotificationService.showReservationConfirmation(
      zoneName: zone.name,
      plate: vehicle.plate,
    );

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.check_circle,
          color: AppTheme.available,
          size: 44,
        ),
        title: const Text('Reserva Confirmada!'),
        content: Text(
          'A reserva de ${zone.name} para o veículo ${vehicle.plate} foi registrada.\n\n'
          'Duração: $duration hora(s)\n'
          'Valor total: R\$ ${total.toStringAsFixed(2)}\n\n'
          'Você também recebeu uma notificação.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );

    // Fecha a tela de veículos e retorna à tela de detalhes da zona.
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthSession.currentUser;
    final args = ModalRoute.of(context)?.settings.arguments;
    final zone = args is ParkingZone ? args : null;

    if (user == null || user.role != UserRole.standard) {
      return Scaffold(
        appBar: AppBar(title: const Text('Meus veículos')),
        body: const Center(child: Text('Faça login para visualizar seus veículos.')),
      );
    }

    final vehicles = MockAppData.vehiclesFor(user);


    return Scaffold(
      appBar: AppBar(
        title: Text(zone == null ? 'Meus veículos' : 'Selecione um veículo'),
      ),
      body: vehicles.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.directions_car_outlined,
                      size: 64,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Nenhum veículo cadastrado',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      zone == null
                          ? 'Adicione um veículo para facilitar suas reservas.'
                          : 'Cadastre um veículo para continuar com a reserva.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/form')
                          .then((_) {
                        if (mounted) setState(() {});
                      }),
                      icon: const Icon(Icons.add),
                      label: const Text('Cadastrar veículo'),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (zone != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: .10),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Escolha o veículo que deseja utilizar na reserva de ${zone.name}.',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                ...vehicles.map(
                  (vehicle) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      child: ListTile(
                        onTap: zone == null
                            ? null
                            : () => _reserveVehicle(user, vehicle, zone),
                        leading: const CircleAvatar(
                          child: Icon(Icons.directions_car),
                        ),
                        title: Text(
                          vehicle.plate,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(vehicle.type),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (zone != null)
                              const Icon(
                                Icons.touch_app_outlined,
                                color: AppTheme.primary,
                              ),
                            IconButton(
                              tooltip: 'Remover veículo',
                              onPressed: () => _removeVehicle(user, vehicle),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Cadastrar veículo',
        onPressed: () {
          Navigator.pushNamed(context, '/form').then((_) {
            if (mounted) setState(() {});
          });
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
