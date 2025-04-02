import 'package:flutter/material.dart';
import 'form_page.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nearby Places')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FormPage()),
            );
          },
          child: Text('Go to Search Form'),
        ),
      ),
    );
  }
}
