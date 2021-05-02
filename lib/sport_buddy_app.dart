import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/bloc/map_data_cubit.dart';
import 'package:sport_buddy/bloc/user_cubit.dart';
import 'package:sport_buddy/model/user_model.dart';
import 'package:sport_buddy/screens/main_screen.dart';
import 'package:sport_buddy/screens/login_screen.dart';

import 'bloc/user_cubit.dart';

class SportBuddyApp extends StatelessWidget {
  Widget _buildHome(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return BlocBuilder<UserCubit, UserModel>(
        builder: (context, state) => MainScreen(),
      );
    }
    return LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserCubit(),
        ),
        BlocProvider(
          create: (context) => MapDataCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'PV239 Sport Buddy',
        theme: ThemeData(
          primarySwatch: Colors.red,
          textTheme: TextTheme(
             headline4: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
             headline5: TextStyle(fontWeight: FontWeight.bold),
             headline6: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),

          ),
        ),
        home: _buildHome(context),
      ),
    );
  }
}
