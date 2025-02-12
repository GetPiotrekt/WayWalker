import 'dart:async';
import 'package:geolocator/geolocator.dart';

class MovementSimulation {
  Position? _startPosition;
  Position? _currentPosition;
  Position? _midwayPosition;
  double _elapsedTime = 0.0;
  Timer? _timer;

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Sprawdź, czy usługa lokalizacji jest włączona
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Lokalizacja jest wyłączona';
    }

    // Sprawdź uprawnienia
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Uprawnienia do lokalizacji są wyłączone';
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw 'Uprawnienia do lokalizacji są na stałe wyłączone';
    }

    // Pobierz aktualną pozycję
    _currentPosition = await Geolocator.getCurrentPosition();
    _startPosition = _currentPosition;
    _calculateMidwayPosition();
  }

  void _calculateMidwayPosition() {
    if (_currentPosition != null) {
      final double distance = 200.0 / 2; // Przykładowy dystans
      final double latitudeOffset = distance / 111320; // 1 stopień to ~111.32 km
      final double newLatitude = _currentPosition!.latitude + latitudeOffset;

      _midwayPosition = Position(
        latitude: newLatitude,
        longitude: _currentPosition!.longitude,
        timestamp: DateTime.now(),
        accuracy: _currentPosition!.accuracy,
        altitude: _currentPosition!.altitude,
        heading: _currentPosition!.heading,
        speed: _currentPosition!.speed,
        speedAccuracy: _currentPosition!.speedAccuracy,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );
    }
  }

  void updateLocation(double distance, double speed) {
    if (_startPosition == null) return;

    final double distanceTraveled = speed * _elapsedTime;

    if (distanceTraveled <= distance) {
      final double latitudeOffset = distanceTraveled / 111320;
      final double newLatitude = _startPosition!.latitude + latitudeOffset;

      _currentPosition = Position(
        latitude: newLatitude,
        longitude: _startPosition!.longitude,
        timestamp: DateTime.now(),
        accuracy: _startPosition!.accuracy,
        altitude: _startPosition!.altitude,
        heading: _startPosition!.heading,
        speed: _startPosition!.speed,
        speedAccuracy: _startPosition!.speedAccuracy,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );
      _elapsedTime += 0.05;
    } else {
      _timer?.cancel();
    }
  }

  void startSimulation(double distance, double speed) {
    _elapsedTime = 0.0;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      updateLocation(distance, speed);
    });
  }

  Position? get currentPosition => _currentPosition;
  Position? get midwayPosition => _midwayPosition;
  Position? get startPosition => _startPosition;
}
