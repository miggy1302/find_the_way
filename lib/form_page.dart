import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Place {
  final String name;
  final double? rating;
  final String? googleMapsUri;
  final String? priceRange;

  Place({
    required this.name,
    this.rating,
    this.googleMapsUri,
    this.priceRange
  });

  // Updated Factory Method
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['displayName']?['text'] ?? "Unknown", // Get 'text' from nested map
      rating: json['rating']?.toDouble(),
      googleMapsUri: json['googleMapsUri'],
      priceRange: json['priceRange'],
    );
  }
}

class FormPage extends StatefulWidget {
  
  const FormPage({super.key});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  String locationMessage = "Location not available";
  String selectedRadius = '250';
  String selectedPlaceType = 'pharmacy';
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

  Future<List<Place>> _submitForm() async {
    const apiKey = 'AIzaSyBOdHxzQvUP8hT40j9ny3TTaTM3dMzlmA0';
    final url = Uri.parse(
      'https://places.googleapis.com/v1/places:searchNearby?key=$apiKey');
    await _getCurrentLocation();
    if (currentPosition != null) {
          // JSON body for POST request
      final requestBody = jsonEncode({
        "includedTypes": [selectedPlaceType],
        "maxResultCount": 20,
        "locationRestriction": {
          "circle": {
            "center": {"latitude": currentPosition!.latitude, "longitude": currentPosition!.longitude},
            "radius": int.parse(selectedRadius)
          }
        }
      });

      // Send POST request
      try {
        final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "X-Goog-FieldMask":
                "places.displayName,places.rating,places.googleMapsUri",
                // "*"
          },
          body: requestBody,
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          List<Place> places = data['places']

              .map<Place>((json) => Place.fromJson(json))
              .toList();

          return places;
        } else {
          print("Error: ${response.statusCode}");
          return [];
        }
      } catch (e) {
        print("Exception occurred: $e");
        return [];
      }
    }else {
      print('Location not available');
      return [];
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
              items: ['pharmacy', 'supermarket', 'grocery_store', 'bus_stop', 'restaurant', 'atm', 'bank', 'hotel *'].map((value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async{
                List<Place> places = await _submitForm();
                Navigator.pop(context, places); // Pass the list of places back to the previous screen
              },
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
