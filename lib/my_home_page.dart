import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttermocklocation/fluttermocklocation.dart';
import 'package:geolocator/geolocator.dart';

/// Klasa główna aplikacji
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  /// Flagi i zmienne do obsługi błędów
  bool _error = false;
  String _positionUpdated = '';
  String _errorString = '';

  /// Instancja pluginu do mockowania lokalizacji
  final _fluttermocklocationPlugin = Fluttermocklocation();

  /// Kontrolery tekstowe dla pól wprowadzania danych
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  final TextEditingController _altitudeController = TextEditingController();
  final TextEditingController _delayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    /// Subskrypcja aktualizacji lokalizacji z pluginu
    _fluttermocklocationPlugin.locationUpdates.listen((locationData) {
      /// Pobieranie aktualnego czasu
      final DateTime now = DateTime.now();
      final String formattedTimestamp =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} "
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

      /// Formatowanie danych o pozycji
      final String positionString = 'latitude: ${locationData['latitude']}\n'
          'longitude: ${locationData['longitude']}\n'
          'altitude: ${locationData['altitude']}\n'
          'timestamp: $formattedTimestamp';

      /// Aktualizacja stanu z nową pozycją
      setState(() {
        _positionUpdated = positionString;
      });

      print(_positionUpdated);
    });
  }

  @override
  void dispose() {
    /// Czyszczenie zasobów (w tym kontrolerów) przed zniszczeniem widżetu
    super.dispose();
  }

  /// Funkcja do aktualizacji lokalizacji mockowanej
  void _updateLocation() async {
    try {
      setState(() {
        _error = false;
        _errorString = '';
      });

      /// Pobieranie danych wejściowych od użytkownika
      final double latitude = double.parse(_latController.text);
      final double longitude = double.parse(_lngController.text);
      final double altitude = double.parse(_altitudeController.text);
      final int delay = int.tryParse(_delayController.text) ?? 5000;

      try {
        /// Aktualizacja lokalizacji mockowanej
        await Fluttermocklocation().updateMockLocation(
          latitude,
          longitude,
          altitude: altitude,
          delay: delay,
        );
        print("Mock location updated: $latitude, $longitude, $altitude with delay $delay ms");
      } catch (e) {
        /// Obsługa błędów związanych z ustawianiem lokalizacji
        print("Error updating the location: $e");
        setState(() {
          _errorString =
          'To use this application, please enable Developer Options on your Android device.\n\nWithin Developer Options select\n\n"Select mock location app"\n\nand choose this app.';
          _error = true;
        });
      }
    } catch (e) {
      /// Obsługa błędów związanych z błędnymi danymi wejściowymi
      setState(() {
        _errorString = 'Invalid latitude, longitude, or delay.';
        _error = true;
      });
    }
  }

  /// Funkcja do pobrania bieżącej lokalizacji
  Future<void> _getCurrentLocation() async {
    try {
      /// Sprawdzanie, czy usługi lokalizacyjne są włączone
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorString = 'Location services are disabled.';
          _error = true;
        });
        return;
      }

      /// Sprawdzanie i żądanie uprawnień lokalizacyjnych
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorString = 'Location permissions are denied';
            _error = true;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorString = 'Location permissions are permanently denied.';
          _error = true;
        });
        return;
      }

      /// Pobranie bieżącej pozycji
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        /// Ustawianie wartości w polach tekstowych
        _latController.text = position.latitude.toString();
        _lngController.text = position.longitude.toString();
        _altitudeController.text = position.altitude.toString();
      });

      print('Current location: ${position.latitude}, ${position.longitude}, ${position.altitude}');
    } catch (e) {
      /// Obsługa błędów podczas pobierania lokalizacji
      setState(() {
        _errorString = 'Failed to get current location: $e';
        _error = true;
      });
    }
  }

  /// Budowanie interfejsu użytkownika
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              /// Pola wprowadzania dla lokalizacji
              TextField(
                controller: _latController,
                decoration: const InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _lngController,
                decoration: const InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _altitudeController,
                decoration: const InputDecoration(labelText: 'Altitude'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _delayController,
                decoration: const InputDecoration(labelText: 'Delay (ms)'),
                keyboardType: TextInputType.number,
              ),
              /// Przycisk do ustawienia mockowanej lokalizacji
              ElevatedButton(
                onPressed: _updateLocation,
                child: const Text('Set Mock Location'),
              ),
              /// Przycisk do pobrania bieżącej lokalizacji
              ElevatedButton(
                onPressed: _getCurrentLocation,
                child: const Text('Get Current Location'),
              ),
              const SizedBox(
                height: 20,
              ),
              /// Wyświetlanie zaktualizowanej pozycji
              (_positionUpdated != '')
                  ? Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    _positionUpdated,
                  ),
                ),
              )
                  : Container(),
              /// Wyświetlanie komunikatów o błędach
              _error
                  ? Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    _errorString,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
