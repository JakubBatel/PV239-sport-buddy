import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sport_buddy/sport_buddy_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().whenComplete(() => runApp(SportBuddyApp()));
}
