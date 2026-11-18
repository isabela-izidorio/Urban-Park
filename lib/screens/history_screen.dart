import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../models/reservation.dart';
import '../services/auth_session.dart';
import '../services/mock_app_data.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedPlate = 'Todos';
  DateTime? _selectedDate;

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/${date.year} às $hour:$minute';
  }

  Future<void> _chooseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _clearHistory(AppUser user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Limpar histórico?'),
        content: const Text(
          'Tem certeza de que deseja remover todos os registros do histórico?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        MockAppData.clearReservations(user);
        _selectedPlate = 'Todos';
        _selectedDate = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Histórico limpo com sucesso.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthSession.currentUser;
    if (user == null || user.role != UserRole.standard) {
      return Scaffold(
        appBar: AppBar(title: const Text('Histórico')),
        body: const Center(child: Text('Faça login para visualizar o histórico.')),
      );
    }

    final allRecords = MockAppData.reservationsFor(user);
    final plates = allRecords.map((item) => item.vehiclePlate).toSet().toList()
      ..sort();
    final options = ['Todos', ...plates];

    final records = allRecords.where((record) {
      final matchesPlate = _selectedPlate == 'Todos' ||
          record.vehiclePlate == _selectedPlate;
      final date = _selectedDate;
      final matchesDate = date == null ||
          (record.reservedAt.year == date.year &&
              record.reservedAt.month == date.month &&
              record.reservedAt.day == date.day);
      return matchesPlate && matchesDate;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de reservas'),
        actions: [
          IconButton(
            tooltip: 'Limpar histórico',
            onPressed: allRecords.isEmpty ? null : () => _clearHistory(user),
            disabledColor: Colors.grey.shade300,
            icon: Icon(
              Icons.delete_outline,
              color: allRecords.isEmpty ? Colors.grey.shade400 : Colors.red,
            ),
          ),
        ],
      ),
      body: allRecords.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.history,
                      size: 64,
                      color: AppTheme.textSecondary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Sem histórico disponível',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Suas reservas realizadas aparecerão aqui.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedPlate,
                        decoration: const InputDecoration(
                          labelText: 'Filtrar por veículo',
                          prefixIcon: Icon(Icons.directions_car),
                        ),
                        items: options
                            .map(
                              (plate) => DropdownMenuItem(
                                value: plate,
                                child: Text(plate),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedPlate = value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      tooltip: _selectedDate == null
                          ? 'Filtrar por data'
                          : 'Data: ${_formatDate(_selectedDate!)}',
                      onPressed: _chooseDate,
                      icon: const Icon(Icons.calendar_month),
                    ),
                    if (_selectedDate != null)
                      IconButton(
                        tooltip: 'Remover filtro de data',
                        onPressed: () => setState(() => _selectedDate = null),
                        icon: const Icon(Icons.close),
                      ),
                  ],
                ),
                if (_selectedDate != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Data selecionada: ${_formatDate(_selectedDate!)}',
                    style: const TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
                const SizedBox(height: 18),
                if (records.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Nenhuma reserva encontrada para os filtros selecionados.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  )
                else
                  ...records.map(
                    (record) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ReservationCard(
                        reservation: record,
                        formattedDate: _formatDate(record.reservedAt),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final String formattedDate;

  const _ReservationCard({
    required this.reservation,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_parking, color: AppTheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    reservation.zoneName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Veículo: ${reservation.vehiclePlate} (${reservation.vehicleType})'),
            Text('Duração: ${reservation.durationHours} hora(s)'),
            Text('Data: $formattedDate'),
            const Divider(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Valor da reserva',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
                Text(
                  'R\$ ${reservation.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
