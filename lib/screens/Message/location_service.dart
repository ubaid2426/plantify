import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // Request location permissions
  Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permission denied, handle accordingly
        // print('Location permission denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle permission denied forever
      // print('Location permission permanently denied');
      return;
    }
  }

  // Get the current position
  Future<Position?> getCurrentPosition() async {
    try {
      // Request permission first
      await requestLocationPermission();

      // Check if permission is granted
      if (await Geolocator.isLocationServiceEnabled()) {
        Position position = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high,
        );
        return position;
      } else {
        // Handle location services disabled
        // print('Location services are disabled.');
        return null;
      }
    } catch (e) {
      // print('Error occurred while fetching location: $e');
      return null;
    }
  }
}

void main() {
  runApp(GetcurrentLocation());
}

class GetcurrentLocation extends StatelessWidget {
  final LocationService locationService = LocationService();

  GetcurrentLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Location Example')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              Position? position = await locationService.getCurrentPosition();
              if (position != null) {
                // print('Location: ${position.latitude}, ${position.longitude}');
              }
            },
            child: const Text('Get Location'),
          ),
        ),
      ),
    );
  }
}
