import 'package:find_the_way/form_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ListPage extends StatefulWidget {
  final List<Place>? places; // Accept list of places

  ListPage({this.places}); // Constructor to receive data

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Place> nearbyPlaces = [];

  @override
  void initState() {
    super.initState();
    // If data is passed, populate the list
    if (widget.places != null) {
      nearbyPlaces = widget.places!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nearby Places')),
      body: Column(
        children: [
          // Always visible button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormPage()),
                ).then((result) {
                  if (result != null) {
                    setState(() {
                      nearbyPlaces = result;
                    });
                  }
                });
              },
              child: Text('Go to Search Form'),
            ),
          ),

          // Display list of places if available
          const SizedBox(height: 10),
          Expanded(
            child: nearbyPlaces.isEmpty
                ? const Center(child: Text('No nearby places found.'))
                : ListView.builder(
                    itemCount: nearbyPlaces.length,
                    itemBuilder: (context, index) {
                      final place = nearbyPlaces[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        color: Colors.grey[850],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(place.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
                              if (place.rating != null) Text('Rating: ${place.rating}', style: const TextStyle(color: Colors.white70)),
                              if (place.googleMapsUri != null)
                                ElevatedButton(
                                  onPressed: () async {
                                    final Uri url = Uri.parse(place.googleMapsUri!);
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
                    },
                  ),
          ),
        ],
      ),
    );
  }
}