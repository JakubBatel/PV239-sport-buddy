import 'package:flutter/material.dart';
import 'package:sport_buddy/screens/main_screen.dart';

void main() {
  runApp(SportBuddyApp());
}

class SportBuddyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PV239 Sport Buddy',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MainScreen(),
    );
  }
}
