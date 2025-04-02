import 'package:find_the_way/form_page.dart';
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
      body: nearbyPlaces.isEmpty
          ? Center(
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
            )
          : ListView.builder(
              itemCount: nearbyPlaces.length,
              itemBuilder: (context, index) {
                final place = nearbyPlaces[index];
                return ListTile(
                  title: Text(place.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (place.rating != null) Text("Rating: ${place.rating}"),
                      if (place.googleMapsUri != null) Text("Google Maps: ${place.googleMapsUri}"),
                      if (place.priceRange != null) Text("Price Range: ${place.priceRange}")
                    ],
                  ),
                );
              },
            ),
    );
  }
}
