import 'package:find_the_way/form_page.dart';
import 'package:find_the_way/noti_service.dart';
import 'package:find_the_way/place_card_widget.dart';
import 'package:flutter/material.dart';

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
                    NotiService().showNotification(
                      title: 'Nearby Places',
                      body: 'You have ${nearbyPlaces.length} places nearby.',
                    );
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
                    return PlaceCardWidget(
                      name: place.name,
                      rating: place.rating,
                      googleMapsUri: place.googleMapsUri,
                    );
                  },
                )
          ),
        ],
      ),
    );
  }
}

