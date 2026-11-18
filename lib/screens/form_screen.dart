import 'package:flutter/material.dart';

import '../models/vehicle.dart';
import '../services/auth_session.dart';
import '../services/mock_app_data.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _plateController = TextEditingController();
  String _vehicleType = 'Carro';
  bool _sending = false;

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = AuthSession.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faça login para cadastrar um veículo.')),
      );
      return;
    }

    setState(() => _sending = true);

    try {
      await Future.delayed(const Duration(milliseconds: 350));

      final plate = _plateController.text.trim().toUpperCase();
      final vehicle = Vehicle(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        plate: plate,
        type: _vehicleType,
      );

      final added = MockAppData.addVehicle(user, vehicle);
      if (!added) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Este veículo já está cadastrado na sua conta.'),
            ),
          );
        }
        return;
      }

      await NotificationService.showVehicleAdded(
        plate: plate,
        type: _vehicleType,
      );

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          icon: const Icon(
            Icons.check_circle,
            color: AppTheme.available,
            size: 42,
          ),
          title: const Text('Veículo cadastrado!'),
          content: Text('O veículo $plate foi adicionado à sua conta.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Entendi'),
            ),
          ],
        ),
      );

      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível cadastrar o veículo: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar veículo')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: .10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.directions_car,
                            color: AppTheme.primary,
                            size: 36,
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'Informe os dados do veículo que deseja adicionar à sua conta.',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _plateController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'Placa do veículo',
                        hintText: 'ABC1D23',
                        prefixIcon: Icon(Icons.credit_card),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe a placa do veículo';
                        }
                        if (value.trim().length < 7) {
                          return 'Informe uma placa válida';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _vehicleType,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de veículo',
                        prefixIcon: Icon(Icons.directions_car_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Carro', child: Text('Carro')),
                        DropdownMenuItem(value: 'Moto', child: Text('Moto')),
                        DropdownMenuItem(value: 'Van', child: Text('Van')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _vehicleType = value);
                        }
                      },
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton.icon(
                      onPressed: _sending ? null : _submit,
                      icon: _sending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check),
                      label: Text(
                        _sending ? 'Cadastrando...' : 'Cadastrar veículo',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
