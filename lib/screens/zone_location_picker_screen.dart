import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../theme/app_theme.dart';

class ZoneLocationPickerScreen extends StatefulWidget {
  final LatLng initialPoint;

  const ZoneLocationPickerScreen({
    super.key,
    required this.initialPoint,
  });

  @override
  State<ZoneLocationPickerScreen> createState() => _ZoneLocationPickerScreenState();
}

class _ZoneLocationPickerScreenState extends State<ZoneLocationPickerScreen> {
  late LatLng _selectedPoint;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _selectedPoint = widget.initialPoint;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecionar localização')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(14),
            child: Text(
              'Toque no mapa para posicionar o marcador no endereço do estacionamento.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _selectedPoint,
                initialZoom: 15,
                onTap: (_, point) => setState(() => _selectedPoint = point),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.urban_park',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedPoint,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.location_on,
                        color: AppTheme.primary,
                        size: 46,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              '© OpenStreetMap contributors',
              style: TextStyle(fontSize: 10, color: AppTheme.textSecondary),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Lat: ${_selectedPoint.latitude.toStringAsFixed(6)}  ·  '
                    'Long: ${_selectedPoint.longitude.toStringAsFixed(6)}',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context, _selectedPoint),
                    icon: const Icon(Icons.check),
                    label: const Text('Confirmar localização'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
