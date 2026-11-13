import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
  LatLng _center = const LatLng(-22.9056, -47.0608); // Centro de Campinas (posição inicial ilustrativa)
  bool _loading = false;
  String? _message;

  final List<_MapParking> _parkings = const [
    _MapParking('Praça Central', LatLng(-22.9050, -47.0605), 18),
    _MapParking('Rua Principal', LatLng(-22.9080, -47.0630), 7),
    _MapParking('Shopping', LatLng(-22.9005, -47.0550), 25),
    _MapParking('Terminal', LatLng(-22.9100, -47.0570), 3),
  ];

  Future<void> _locate() async {
    setState(() { _loading = true; _message = null; });
    try {
      final position = await _location.getCurrentPosition();
      if (!mounted) return;
      final point = LatLng(position.latitude, position.longitude);
      setState(() => _center = point);
      _mapController.move(point, 14);
    } catch (e) {
      if (mounted) setState(() => _message = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(height: 230, child: Stack(children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: _center, initialZoom: 13),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.urban_park',
              ),
              MarkerLayer(markers: [
                Marker(point: _center, width: 42, height: 42, child: const Icon(Icons.my_location, color: Colors.blue, size: 32)),
                ..._parkings.map((p) => Marker(
                  point: p.point, width: 42, height: 42,
                  child: Tooltip(message: '${p.name}: ${p.spots} vagas',
                    child: const Icon(Icons.location_on, color: AppTheme.primary, size: 38)),
                )),
              ]),
            ],
          ),
          Positioned(right: 12, bottom: 12, child: FloatingActionButton.small(
            heroTag: 'locate_map', onPressed: _loading ? null : _locate,
            child: _loading ? const SizedBox(width: 18,height: 18,child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.my_location))),
        ])),
      ),
      if (_message != null) Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(_message!, style: const TextStyle(color: Colors.red, fontSize: 12)),
      ),
      const SizedBox(height: 7),
      const Text('Mapa ilustrativo: os pontos e a quantidade de vagas são mockados.',
        style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
    ],
  );
}

class _MapParking {
  final String name;
  final LatLng point;
  final int spots;
  const _MapParking(this.name, this.point, this.spots);
}
