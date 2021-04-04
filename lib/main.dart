import 'package:flutter/material.dart';

void main() {
  runApp(SportBuddyApp());
}

class SportBuddyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PV239 Sport Buddy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('PV239 Sport buddy'),
          ),
          body: null
      ),
    );
  }
}
