import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../domain/entity/place_entity.dart';

class PlaceRouteMap extends StatefulWidget {
  final PlaceEntity place;

  const PlaceRouteMap({
    super.key,
    required this.place,
  });

  @override
  State<PlaceRouteMap> createState() => _PlaceRouteMapState();
}

class _PlaceRouteMapState extends State<PlaceRouteMap> {
  final MapController _mapController = MapController();
  final Dio _dio = Dio();

  Position? _currentPosition;
  List<LatLng> _routePoints = [];
  String? _message;
  bool _loading = true;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  Future<void> _initMap() async {
    final latitude = widget.place.latitude;
    final longitude = widget.place.longitude;
    if (latitude == null || longitude == null) {
      if (!mounted) return;
      setState(() {
        _message = 'This place does not have map coordinates.';
        _loading = false;
      });
      return;
    }

    final position = await _requestCurrentLocation();
    if (!mounted) return;

    if (position != null) {
      _currentPosition = position;
      await _loadRoute();
    }

    setState(() {
      _loading = false;
      _ready = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fitMap();
    });
  }

  Future<Position?> _requestCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return null;
      setState(() {
        _message = 'Location services are disabled.';
      });
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      if (!mounted) return null;
      setState(() {
        _message = 'Location permission denied.';
      });
      return null;
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return null;
      setState(() {
        _message = 'Location permission permanently denied.';
      });
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (e) {
      if (!mounted) return null;
      setState(() {
        _message = 'Unable to get current location: $e';
      });
      return null;
    }
  }

  Future<void> _loadRoute() async {
    final current = _currentPosition;
    final latitude = widget.place.latitude;
    final longitude = widget.place.longitude;
    if (current == null || latitude == null || longitude == null) return;

    try {
      final uri = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
        '${current.longitude},${current.latitude};$longitude,$latitude'
        '?overview=full&geometries=geojson&alternatives=false&steps=false',
      );
      final response = await _dio.getUri(uri);
      final data = response.data;
      final routes = data is Map<String, dynamic> ? data['routes'] : null;
      if (routes is List && routes.isNotEmpty) {
        final geometry = routes.first is Map<String, dynamic>
            ? routes.first['geometry']
            : null;
        final coordinates = geometry is Map<String, dynamic>
            ? geometry['coordinates']
            : null;
        if (coordinates is List) {
          _routePoints = coordinates
              .whereType<List>()
              .where((pair) => pair.length >= 2)
              .map(
                (pair) => LatLng(
                  (pair[1] as num).toDouble(),
                  (pair[0] as num).toDouble(),
                ),
              )
              .toList();
        }
      }
    } catch (_) {
      _routePoints = [];
    }

    if (_routePoints.isEmpty && current != null && latitude != null && longitude != null) {
      _routePoints = [
        LatLng(current.latitude, current.longitude),
        LatLng(latitude, longitude),
      ];
    }
  }

  void _fitMap() {
    final latitude = widget.place.latitude;
    final longitude = widget.place.longitude;
    final current = _currentPosition;
    if (latitude == null || longitude == null || current == null) return;

    _mapController.fitCamera(
      CameraFit.coordinates(
        coordinates: [
          LatLng(current.latitude, current.longitude),
          LatLng(latitude, longitude),
        ],
        padding: const EdgeInsets.all(48),
        maxZoom: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final latitude = widget.place.latitude;
    final longitude = widget.place.longitude;
    if (latitude == null || longitude == null) {
      return Container(
        height: MediaQuery.sizeOf(context).height * 0.45,
        alignment: Alignment.center,
        child: const Text('This place does not have map coordinates.'),
      );
    }

    final placePoint = LatLng(latitude, longitude);
    final currentPoint = _currentPosition == null
        ? null
        : LatLng(_currentPosition!.latitude, _currentPosition!.longitude);

    final markers = <Marker>[
      Marker(
        point: placePoint,
        width: 54,
        height: 54,
        child: const Icon(
          Icons.location_pin,
          size: 54,
          color: Colors.red,
        ),
      ),
      if (currentPoint != null)
        Marker(
          point: currentPoint,
          width: 54,
          height: 54,

          child: const Icon(
            Icons.my_location,
            size: 30,
            color: Colors.blue,
          ),
        ),
    ];

    final routeLine = _routePoints.isNotEmpty
        ? _routePoints
        : currentPoint == null
            ? <LatLng>[]
            : <LatLng>[currentPoint, placePoint];

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.55,
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: placePoint,
              initialZoom: 13,
              onMapReady: _fitMap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'place_finder_app',
                maxZoom: 19,
              ),
              if (routeLine.length >= 2)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routeLine,
                      color: Colors.blue,
                      strokeWidth: 5,
                    ),
                  ],
                ),
              MarkerLayer(markers: markers),
            ],
          ),
          if (_loading)
            Container(
              color: Colors.black12,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          if (_ready && _message != null)
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Material(
                color: Colors.white,
                elevation: 3,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _message!,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ),
          if (_ready && _message != null)
            Positioned(
              right: 12,
              top: 12,
              child: FloatingActionButton.small(
                heroTag: 'retry_location',
                onPressed: _initMap,
                child: const Icon(Icons.my_location),
              ),
            ),
        ],
      ),
    );
  }
}
