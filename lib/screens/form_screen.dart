import 'package:flutter/material.dart';

import '../models/parking_zone.dart';
import '../theme/app_theme.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _plateController = TextEditingController();
  final _phoneController = TextEditingController();

  String vehicleType = 'Carro';
  String duration = '1 hora';

  @override
  void dispose() {
    _nameController.dispose();
    _plateController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;

    // O PDF solicita mostrar no console o que foi inserido.
    debugPrint('========== ESTACIONAMENTO ==========');
    debugPrint('Nome: ${_nameController.text}');
    debugPrint('Placa: ${_plateController.text}');
    debugPrint('Telefone: ${_phoneController.text}');
    debugPrint('Tipo: $vehicleType');
    debugPrint('Duração: $duration');
    debugPrint('====================================');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dados enviados com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final zone = args is ParkingZone ? args : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar estacionamento')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontal = constraints.maxWidth >= 700;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontal ? 80 : 20,
                vertical: 24,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),

                      // BACKGROUND DO CABEÇALHO DO FORMULÁRIO:
                      // Altere aqui a cor da área informativa superior.
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Row(
                        children: [
                          const Icon(
                            Icons.directions_car,
                            color: AppTheme.primary,
                            size: 34,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              zone == null
                                  ? 'Informe os dados do veículo'
                                  : 'Zona selecionada: ${zone.name}',
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    const Text(
                      'Nome do motorista',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Digite seu nome',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe seu nome';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Placa do veículo',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _plateController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        hintText: 'ABC-1234',
                        prefixIcon: Icon(Icons.credit_card),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe a placa';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Telefone',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: '(00) 00000-0000',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o telefone';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Tipo de veículo',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: vehicleType,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.directions_car_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Carro', child: Text('Carro')),
                        DropdownMenuItem(value: 'Moto', child: Text('Moto')),
                        DropdownMenuItem(value: 'Van', child: Text('Van')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => vehicleType = value);
                        }
                      },
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Tempo de permanência',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: duration,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: '1 hora',
                          child: Text('1 hora'),
                        ),
                        DropdownMenuItem(
                          value: '2 horas',
                          child: Text('2 horas'),
                        ),
                        DropdownMenuItem(
                          value: '3 horas',
                          child: Text('3 horas'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => duration = value);
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: submit,
                      child: const Text('Confirmar estacionamento'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
