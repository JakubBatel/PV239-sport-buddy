import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'bloc/user_cubit.dart';

import 'model/user_model.dart';
import 'views/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().whenComplete(() => runApp(SportBuddyApp()));
}

class SportBuddyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserCubit>(
        create: (context) => UserCubit(),
        child: MaterialApp(
            title: 'PV239 Sport Buddy',
            theme: ThemeData(
              primarySwatch: Colors.red,
            ),
            home: _content(context)));
  }

  Widget _content(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return BlocBuilder<UserCubit, UserModel>(builder: (context, state) {
        final userCubit = context.read<UserCubit>();
        userCubit.updateUserName(FirebaseAuth.instance.currentUser.displayName);
        return MainScreen();
      });
    } else {
      return Login();
    }
  }
}
