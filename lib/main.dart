import 'package:flutter/material.dart';
import 'package:sport_buddy/components/gradient_app_bar.dart';
import 'package:sport_buddy/components/gradient_button.dart';

import 'views/login.dart';

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
      home: Scaffold(
          appBar: GradientAppBar(
            title: Text('PV239 Sport buddy'),
          ),
          body: Login()
      ),
    );
  }
}
