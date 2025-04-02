import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class FormPage extends StatefulWidget {
  
  const FormPage({super.key});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  String locationMessage = "Location not available";
  String selectedRadius = '250';
  String selectedPlaceType = 'pharmacies';
  Position? currentPosition;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        locationMessage = "Location services are disabled.";
      });
      return;
    }

    // Request permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          locationMessage = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        locationMessage =
            "Location permissions are permanently denied. Please enable them in settings.";
        return;
      });
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = position;
    });
  }

  void _submitForm() async {
    await _getCurrentLocation();
    if (currentPosition != null) {
      print('Radius: $selectedRadius');
      print('Place Type: $selectedPlaceType');
      print('Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}');
    } else {
      print('Location not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Nearby')), 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedRadius,
              onChanged: (value) => setState(() => selectedRadius = value!),
              items: ['250', '500', '1000'].map((value) {
                return DropdownMenuItem(value: value, child: Text('$value meters'));
              }).toList(),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedPlaceType,
              onChanged: (value) => setState(() => selectedPlaceType = value!),
              items: ['pharmacies', 'supermarkets', 'grocery stores'].map((value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
