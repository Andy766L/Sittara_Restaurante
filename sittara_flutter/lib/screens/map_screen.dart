import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../data/mock_data.dart';
import '../models.dart';
import '../services/location_service.dart';
import '../widgets/restaurant_map_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final LocationService _locationService = LocationService();
  LatLng? _currentPosition;
  bool _isLoading = true;
  String? _errorMessage;



  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _startLocationStream();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _startLocationStream() async {
    try {
      // Check permissions first
      await _locationService.determinePosition();
      
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );

      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) {
          setState(() {
            _currentPosition = _locationService.positionToLatLng(position);
            _isLoading = false;
            _errorMessage = null;
          });
          
          // Move map to user only on first fix or if user requests it
          // For now, let's just update the marker. The FAB centers it.
          if (_isLoading) { // First fix
             _mapController.move(_currentPosition!, 14.0);
          }
        },
        onError: (error) {
          setState(() {
            _errorMessage = error.toString();
            _isLoading = false;
            // Fallback only if we don't have a position yet
            if (_currentPosition == null) {
               _currentPosition = const LatLng(40.4168, -3.7038);
            }
          });
        },
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
        _currentPosition = const LatLng(40.4168, -3.7038);
      });
    }
  }

  void _showRestaurantDetails(Restaurant restaurant) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RestaurantMapSheet(restaurant: restaurant),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null && _currentPosition == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error al obtener ubicación',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _startLocationStream();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition ?? const LatLng(40.4168, -3.7038),
              initialZoom: 14.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.sittara_flutter',
                // Use a subdomains list if needed, OSM usually doesn't strictly require it for basic usage
              ),
              MarkerLayer(
                markers: [
                  // User Location Marker
                  if (_currentPosition != null && _errorMessage == null)
                    Marker(
                      point: _currentPosition!,
                      width: 60,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withAlpha(50),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(50),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Restaurant Markers
                  ...mockRestaurants.map((restaurant) {
                    return Marker(
                      point: LatLng(restaurant.lat, restaurant.lng),
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () => _showRestaurantDetails(restaurant),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(75),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.restaurant,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            // Triangle pointer (optional visual flair)
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
          // Floating Action Button to Center
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              onPressed: () {
                if (_currentPosition != null) {
                  _mapController.move(_currentPosition!, 15.0);
                }
              },
              backgroundColor: theme.colorScheme.surface,
              foregroundColor: theme.primaryColor,
              child: const Icon(Icons.my_location),
            ),
          ),
          // Back Button (if pushed)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: CircleAvatar(
              backgroundColor: theme.colorScheme.surface,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: theme.colorScheme.onSurface,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
