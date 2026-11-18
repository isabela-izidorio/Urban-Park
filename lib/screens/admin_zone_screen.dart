import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../data/parking_data.dart';
import '../models/parking_zone.dart';
import '../theme/app_theme.dart';
import 'zone_location_picker_screen.dart';

class AdminZoneDetailsScreen extends StatefulWidget {
  final String zoneId;

  const AdminZoneDetailsScreen({super.key, required this.zoneId});

  @override
  State<AdminZoneDetailsScreen> createState() => _AdminZoneDetailsScreenState();
}

class _AdminZoneDetailsScreenState extends State<AdminZoneDetailsScreen> {
  ParkingZone? get zone => ParkingData.findById(widget.zoneId);

  Future<void> _editZone(ParkingZone currentZone) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ZoneEditorScreen(zone: currentZone),
      ),
    );
    if (updated == true && mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentZone = zone;
    if (currentZone == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Zona de estacionamento')),
        body: const Center(child: Text('Zona não encontrada.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da zona'),
        actions: [
          IconButton(
            tooltip: 'Editar zona',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _editZone(currentZone),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 170,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(currentZone.icon, size: 76, color: Colors.white),
          ),
          const SizedBox(height: 22),
          Text(
            currentZone.name,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: AppTheme.textSecondary),
              const SizedBox(width: 6),
              Expanded(child: Text(currentZone.address)),
            ],
          ),
          const SizedBox(height: 20),
          _InfoLine(
            title: 'Funcionamento',
            value: currentZone.isOpen ? 'Aberto' : 'Fechado',
            valueColor: currentZone.isOpen ? AppTheme.available : AppTheme.occupied,
          ),
          _InfoLine(
            title: 'Vagas disponíveis',
            value: '${currentZone.availableSpots} de ${currentZone.totalSpots}',
          ),
          _InfoLine(
            title: 'Valor por hora',
            value: 'R\$ ${currentZone.hourlyPrice.toStringAsFixed(2)}',
          ),
          _InfoLine(
            title: 'Latitude',
            value: currentZone.latitude.toStringAsFixed(6),
          ),
          _InfoLine(
            title: 'Longitude',
            value: currentZone.longitude.toStringAsFixed(6),
          ),
          const SizedBox(height: 22),
          const Text(
            'Descrição',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            currentZone.description,
            style: const TextStyle(color: AppTheme.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => _editZone(currentZone),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Editar informações da zona'),
          ),
        ],
      ),
    );
  }
}

class ZoneEditorScreen extends StatefulWidget {
  final ParkingZone? zone;

  const ZoneEditorScreen({super.key, this.zone});

  @override
  State<ZoneEditorScreen> createState() => _ZoneEditorScreenState();
}

class _ZoneEditorScreenState extends State<ZoneEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _hourlyPriceController;
  late final TextEditingController _totalSpotsController;
  late final TextEditingController _availableSpotsController;

  late double _latitude;
  late double _longitude;
  late bool _isOpen;
  bool _saving = false;

  bool get _isEditing => widget.zone != null;

  @override
  void initState() {
    super.initState();
    final zone = widget.zone;
    _nameController = TextEditingController(text: zone?.name ?? '');
    _addressController = TextEditingController(text: zone?.address ?? '');
    _descriptionController = TextEditingController(text: zone?.description ?? '');
    _hourlyPriceController = TextEditingController(
      text: zone?.hourlyPrice.toStringAsFixed(2) ?? '4.50',
    );
    _totalSpotsController = TextEditingController(
      text: (zone?.totalSpots ?? 20).toString(),
    );
    _availableSpotsController = TextEditingController(
      text: (zone?.availableSpots ?? 20).toString(),
    );
    _latitude = zone?.latitude ?? -22.9056;
    _longitude = zone?.longitude ?? -47.0608;
    _isOpen = zone?.isOpen ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _hourlyPriceController.dispose();
    _totalSpotsController.dispose();
    _availableSpotsController.dispose();
    super.dispose();
  }

  Future<void> _chooseLocation() async {
    final selected = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (_) => ZoneLocationPickerScreen(
          initialPoint: LatLng(_latitude, _longitude),
        ),
      ),
    );

    if (selected != null && mounted) {
      setState(() {
        _latitude = selected.latitude;
        _longitude = selected.longitude;
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final total = int.tryParse(_totalSpotsController.text.trim()) ?? 0;
    final available = int.tryParse(_availableSpotsController.text.trim()) ?? 0;
    final price = double.tryParse(
          _hourlyPriceController.text.trim().replaceAll(',', '.'),
        ) ??
        -1;

    if (available > total) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As vagas disponíveis não podem superar o total de vagas.'),
        ),
      );
      return;
    }
    if (price < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um valor por hora válido.')),
      );
      return;
    }

    setState(() => _saving = true);
    final previous = widget.zone;
    final updated = ParkingZone(
      id: previous?.id ?? 'Z${DateTime.now().microsecondsSinceEpoch}',
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? 'Zona de estacionamento cadastrada no Urban Park.'
          : _descriptionController.text.trim(),
      availableSpots: available,
      totalSpots: total,
      hourlyPrice: price,
      icon: previous?.icon ?? Icons.local_parking,
      latitude: _latitude,
      longitude: _longitude,
      isOpen: _isOpen,
    );

    if (previous == null) {
      ParkingData.add(updated);
    } else {
      ParkingData.update(updated);
    }

    Navigator.pop(context, true);
  }

  String? _requiredText(String? value) {
    if (value == null || value.trim().isEmpty) return 'Campo obrigatório';
    return null;
  }

  String? _requiredNumber(String? value) {
    if (value == null || int.tryParse(value.trim()) == null) {
      return 'Informe um número inteiro';
    }
    if (int.parse(value.trim()) < 0) return 'O valor não pode ser negativo';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar zona' : 'Cadastrar zona'),
        actions: [
          IconButton(
            tooltip: 'Salvar',
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.save_outlined),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome da zona',
                prefixIcon: Icon(Icons.local_parking),
              ),
              validator: _requiredText,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Endereço',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              validator: _requiredText,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _hourlyPriceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Valor por hora (R\$)',
                prefixIcon: Icon(Icons.payments_outlined),
              ),
              validator: (value) {
                final parsed = double.tryParse(
                  (value ?? '').trim().replaceAll(',', '.'),
                );
                if (parsed == null || parsed < 0) return 'Informe um valor válido';
                return null;
              },
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _totalSpotsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Vagas totais'),
                    validator: _requiredNumber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _availableSpotsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Vagas disponíveis'),
                    validator: _requiredNumber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Estacionamento aberto'),
              subtitle: Text(_isOpen ? 'Aberto (marcador verde)' : 'Fechado (marcador vermelho)'),
              value: _isOpen,
              activeColor: AppTheme.available,
              onChanged: (value) => setState(() => _isOpen = value),
            ),
            const SizedBox(height: 18),
            const Text(
              'Localização no mapa',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Latitude: ${_latitude.toStringAsFixed(6)}\n'
              'Longitude: ${_longitude.toStringAsFixed(6)}',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _chooseLocation,
              icon: const Icon(Icons.map_outlined),
              label: const Text('Selecionar localização no mapa'),
            ),
            const SizedBox(height: 22),
            ElevatedButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.save),
              label: Text(_isEditing ? 'Salvar alterações' : 'Cadastrar zona'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Os dados são demonstrativos e permanecem em memória enquanto o aplicativo estiver aberto.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;

  const _InfoLine({
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(color: AppTheme.textSecondary)),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
