import 'package:flutter/material.dart';
import '../models/parking_zone.dart';
import '../theme/app_theme.dart';
import '../services/notification_service.dart';

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
  bool _sending = false;

  @override
  void dispose() {
    _nameController.dispose(); _plateController.dispose(); _phoneController.dispose(); super.dispose();
  }

  Future<void> submit(ParkingZone? zone) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    try {
      // Simula a chamada assíncrona que futuramente será feita ao backend.
      await Future.delayed(const Duration(milliseconds: 500));
      debugPrint('========== ESTACIONAMENTO ==========');
      debugPrint('Nome: ${_nameController.text}');
      debugPrint('Placa: ${_plateController.text.toUpperCase()}');
      debugPrint('Telefone: ${_phoneController.text}');
      debugPrint('Tipo: $vehicleType | Duração: $duration');
      debugPrint('Zona: ${zone?.name ?? 'Não selecionada'}');
      debugPrint('====================================');

      await NotificationService.showParkingConfirmation(
        zoneName: zone?.name ?? 'Zona selecionada',
        plate: _plateController.text.toUpperCase(),
      );
      if (!mounted) return;
      await showDialog<void>(context: context, builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: AppTheme.available, size: 42),
        title: const Text('Estacionamento confirmado!'),
        content: Text('A solicitação para ${_plateController.text.toUpperCase()} foi registrada. Você também recebeu uma notificação.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendi'))],
      ));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Não foi possível confirmar: $e')));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final zone = args is ParkingZone ? args : null;
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar estacionamento')),
      body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
        final horizontal = constraints.maxWidth >= 700;
        return SingleChildScrollView(padding: EdgeInsets.symmetric(horizontal: horizontal ? 80 : 20, vertical: 24),
          child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: .10), borderRadius: BorderRadius.circular(20)),
              child: Row(children: [
                const Icon(Icons.directions_car, color: AppTheme.primary, size: 34), const SizedBox(width: 14),
                Expanded(child: Text(zone == null ? 'Informe os dados do veículo' : 'Zona selecionada: ${zone.name}',
                  style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold))),
              ])),
            const SizedBox(height: 24),
            TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nome do motorista', prefixIcon: Icon(Icons.person_outline)),
              validator: (v) => v == null || v.trim().isEmpty ? 'Informe seu nome' : null),
            const SizedBox(height: 16),
            TextFormField(controller: _plateController, textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(labelText: 'Placa do veículo', hintText: 'ABC-1234', prefixIcon: Icon(Icons.credit_card)),
              validator: (v) => v == null || v.trim().isEmpty ? 'Informe a placa' : null),
            const SizedBox(height: 16),
            TextFormField(controller: _phoneController, keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Telefone', hintText: '(00) 00000-0000', prefixIcon: Icon(Icons.phone_outlined)),
              validator: (v) => v == null || v.trim().isEmpty ? 'Informe o telefone' : null),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(initialValue: vehicleType,
              decoration: const InputDecoration(labelText: 'Tipo de veículo', prefixIcon: Icon(Icons.directions_car_outlined)),
              items: const [DropdownMenuItem(value: 'Carro', child: Text('Carro')), DropdownMenuItem(value: 'Moto', child: Text('Moto')), DropdownMenuItem(value: 'Van', child: Text('Van'))],
              onChanged: (v) { if (v != null) setState(() => vehicleType = v); }),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(initialValue: duration,
              decoration: const InputDecoration(labelText: 'Tempo de permanência', prefixIcon: Icon(Icons.access_time)),
              items: const [DropdownMenuItem(value: '1 hora', child: Text('1 hora')), DropdownMenuItem(value: '2 horas', child: Text('2 horas')), DropdownMenuItem(value: '3 horas', child: Text('3 horas'))],
              onChanged: (v) { if (v != null) setState(() => duration = v); }),
            const SizedBox(height: 28),
            ElevatedButton.icon(onPressed: _sending ? null : () => submit(zone),
              icon: _sending ? const SizedBox(width: 18,height: 18,child: CircularProgressIndicator(strokeWidth: 2,color: Colors.white)) : const Icon(Icons.check),
              label: Text(_sending ? 'Confirmando...' : 'Confirmar estacionamento')),
          ])));
      })),
    );
  }
}
