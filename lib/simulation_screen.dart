import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttermocklocation/fluttermocklocation.dart';

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({super.key});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _speedController = TextEditingController();
  double? _calculatedTime;
  bool _isButtonEnabled = false;
  Position? _currentPosition;
  Position? _startPosition;
  Timer? _timer;
  double _elapsedTime = 0.0; // Time elapsed during the simulation
  double _currentLatitude = 0.0;
  double _currentLongitude = 0.0;
  final _fluttermocklocationPlugin = Fluttermocklocation();

  void _calculateTime() {
    try {
      final double distance = double.parse(_distanceController.text);
      final double speed = double.parse(_speedController.text);

      if (distance > 0 && speed > 0) {
        final double time = distance / speed;
        setState(() {
          _calculatedTime = time;
          _isButtonEnabled = true;
        });
      } else {
        setState(() {
          _calculatedTime = null;
          _isButtonEnabled = false;
        });
      }
    } catch (e) {
      setState(() {
        _calculatedTime = null;
        _isButtonEnabled = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Lokalizacja jest wyłączona');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Uprawnienia do lokalizacji są wyłączone');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Uprawnienia do lokalizacji są na stałe wyłączone');
    }

    final Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
      _startPosition = position;
      _currentLatitude = position.latitude;
      _currentLongitude = position.longitude;
    });
  }

  void _startSimulation() {
    if (_isButtonEnabled) {
      _getCurrentLocation();
      _startPosition = _currentPosition; // Store the initial position
      _elapsedTime = 0.0; // Reset elapsed time
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _updateLocation();
      });
    }
  }

  void _updateLocation() async {
    if (_startPosition == null) return;

    final double distance = double.parse(_distanceController.text);
    final double speed = double.parse(_speedController.text);

    final double distanceTraveled = speed * _elapsedTime;

    if (distanceTraveled <= distance) {
      // Update latitude based on distance traveled
      final double latitudeOffset = distanceTraveled / 111320; // 1 degree is approximately 111.32 km
      final double newLatitude = _startPosition!.latitude + latitudeOffset;

      // Mock the location update using the Fluttermocklocation plugin
      await _fluttermocklocationPlugin.updateMockLocation(
        newLatitude,
        _startPosition!.longitude,
        altitude: _startPosition!.altitude,
      );

      setState(() {
        _currentLatitude = newLatitude;
        _currentLongitude = _startPosition!.longitude;
        _elapsedTime += 1; // Increase time by 1 second
      });
    } else {
      _timer?.cancel(); // Stop the simulation when the full distance is covered
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is destroyed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 200,
              maxWidth: 400,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black38,
            ),
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _distanceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Dystans (m)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => _calculateTime(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _speedController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Prędkość (m/s)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => _calculateTime(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_calculatedTime == null)
                  const FittedBox(
                    child: Text(
                      'Wprowadź dystans w metrach i prędkość w m/s',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (_calculatedTime != null)
                  Text(
                    'Czas trwania: ${_calculatedTime!.toStringAsFixed(2)} sekund',
                    style: const TextStyle(fontSize: 16),
                  ),
                if (_calculatedTime != null) const SizedBox(height: 16),
                if (_calculatedTime != null)
                  ElevatedButton(
                    onPressed: _isButtonEnabled ? _startSimulation : null,
                    child: const Text('Rozpocznij'),
                  ),
                const SizedBox(height: 16),
                if (_startPosition != null)
                  Text(
                    'Początkowa lokalizacja:\n'
                        'Latitude: ${_startPosition!.latitude}, Longitude: ${_startPosition!.longitude}',
                    textAlign: TextAlign.center,
                  ),
                if (_currentPosition != null)
                  Text(
                    '\nAktualna lokalizacja:\n'
                        'Latitude: ${_currentLatitude}, Longitude: ${_currentLongitude}',
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
