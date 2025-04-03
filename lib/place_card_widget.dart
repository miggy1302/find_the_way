import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceCardWidget extends StatelessWidget {
  final String name;
  final double? rating;
  final String? googleMapsUri;

  PlaceCardWidget({required this.name, this.rating, this.googleMapsUri});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            if (rating != null) Text('Rating: $rating', style: const TextStyle(color: Colors.white70)),
            if (googleMapsUri != null)
              ElevatedButton(
                onPressed: () async {
                  final Uri url = Uri.parse(googleMapsUri!);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                child: const Text('Open in Google Maps'),
              ),
          ],
        ),
      ),
    );
  }
}
