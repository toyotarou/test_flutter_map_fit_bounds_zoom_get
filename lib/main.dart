import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MapController _mapController = MapController();

  final LatLng _tokyoStation = const LatLng(35.6809591, 139.7673068);
  final LatLng _osakaStation = const LatLng(34.7024854, 135.4959511);

  double? _calculatedZoom;
  LatLng? _calculatedCenter;

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Map Fit Bounds Example')),
      body: Column(
        children: <Widget>[
          ///
          Expanded(
            child: FlutterMap(
              options: const MapOptions(initialCenter: LatLng(35.0, 135.0), initialZoom: 5.0),
              mapController: _mapController,
              children: <Widget>[
                TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                MarkerLayer(
                  markers: <Marker>[
                    Marker(
                      point: const LatLng(35.6809591, 139.7673068),
                      width: 40,
                      height: 40,
                      child: CircleAvatar(
                        backgroundColor: Colors.redAccent.withOpacity(0.5),
                        child: const Text('tokyo', style: TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    ),
                    Marker(
                      point: const LatLng(34.7024854, 135.4959511),
                      width: 40,
                      height: 40,
                      child: CircleAvatar(
                        backgroundColor: Colors.redAccent.withOpacity(0.5),
                        child: const Text('osaka', style: TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          ///

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _fitBoundsAndMove,
              child: const Text('Fit Bounds & Get Zoom'),
            ),
          ),

          ///

          if (_calculatedCenter != null && _calculatedZoom != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Calculated Center: $_calculatedCenter'),
                  Text('Calculated Zoom: $_calculatedZoom'),
                ],
              ),
            ),

          ///

          const SizedBox(height: 16),

          ///
        ],
      ),
    );
  }

  ///
  void _fitBoundsAndMove() {
    final LatLngBounds bounds = LatLngBounds.fromPoints(<LatLng>[_tokyoStation, _osakaStation]);

    final CameraFit cameraFit = CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50), maxZoom: 16);

    _mapController.fitCamera(cameraFit);

    final LatLng newCenter = _mapController.camera.center;
    final double newZoom = _mapController.camera.zoom;

    setState(() {
      _calculatedCenter = newCenter;
      _calculatedZoom = newZoom;
    });
  }
}
