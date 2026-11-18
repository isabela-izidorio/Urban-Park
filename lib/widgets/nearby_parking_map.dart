import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../data/parking_data.dart';
import '../services/location_service.dart';
import '../theme/app_theme.dart';

class NearbyParkingMap extends StatefulWidget {
  const NearbyParkingMap({super.key});

  @override
  State<NearbyParkingMap> createState() => _NearbyParkingMapState();
}

class _NearbyParkingMapState extends State<NearbyParkingMap> {
  final _mapController = MapController();
  final _location = LocationService();
  LatLng _center = const LatLng(-22.9056, -47.0608);
  LatLng? _userPoint;
  bool _loading = false;
  String? _message;

  Future<void> _locate() async {
    setState(() {
      _loading = true;
      _message = null;
    });
    try {
      final position = await _location.getCurrentPosition();
      if (!mounted) return;
      final point = LatLng(position.latitude, position.longitude);
      setState(() {
        _center = point;
        _userPoint = point;
      });
      _mapController.move(point, 14);
    } catch (error) {
      if (mounted) {
        setState(() {
          _message = error.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final zones = ParkingData.zones;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 250,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(initialCenter: _center, initialZoom: 13),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.urban_park',
                    ),
                    MarkerLayer(
                      markers: [
                        if (_userPoint != null)
                          Marker(
                            point: _userPoint!,
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.blue,
                              size: 30,
                            ),
                          ),
                        ...zones.map(
                          (zone) => Marker(
                            point: LatLng(zone.latitude, zone.longitude),
                            width: 48,
                            height: 54,
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/detail',
                                arguments: zone,
                              ),
                              child: Tooltip(
                                message:
                                    '${zone.name}\n${zone.isOpen ? 'Aberto' : 'Fechado'} · '
                                    '${zone.availableSpots} vagas disponíveis',
                                child: Icon(
                                  Icons.location_on,
                                  color: zone.isOpen
                                      ? AppTheme.available
                                      : AppTheme.occupied,
                                  size: 42,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: FloatingActionButton.small(
                    heroTag: 'locate_map',
                    onPressed: _loading ? null : _locate,
                    child: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text(
            '© OpenStreetMap contributors',
            style: TextStyle(fontSize: 10, color: AppTheme.textSecondary),
          ),
        ),
        if (_message != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _message!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 9),
        Wrap(
          spacing: 16,
          runSpacing: 6,
          children: const [
            _MapLegend(color: AppTheme.available, label: 'Aberto'),
            _MapLegend(color: AppTheme.occupied, label: 'Fechado'),
            _MapLegend(color: Colors.blue, label: 'Sua localização'),
          ],
        ),
        const SizedBox(height: 5),
        const Text(
          'O mapa exibe as zonas cadastradas pelo administrador. Toque em um marcador para consultar os detalhes.',
          style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}

class _MapLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _MapLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
      ],
    );
  }
}
