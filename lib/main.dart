import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/bloc/auth_bloc.dart';
import 'package:sport_buddy/model/event/auth_event.dart';
import 'package:sport_buddy/services/AuthService.dart';
import 'package:sport_buddy/sport_buddy_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().whenComplete(() =>
      runApp(
          BlocProvider<AuthBloc>(
            create: (context) {
              final authService = AuthService();
              return AuthBloc(authService)..add(AppLoaded());
            },
            child: SportBuddyApp(),
          ),
      ));
}
