import 'package:flutter/material.dart';
import 'package:sport_buddy/components/gradient_app_bar.dart';
import 'package:sport_buddy/components/gradient_button.dart';
import 'package:sport_buddy/main_page.dart';
import 'package:sport_buddy/profil_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/user_cubit.dart';


void main() {
  runApp(SportBuddyApp());
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
            home: MainScreen()
        )
    );
    }
}


