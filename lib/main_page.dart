import 'package:flutter/material.dart';
import 'package:sport_buddy/profil_page.dart';

import 'components/gradient_app_bar.dart';
import 'components/gradient_button.dart';

class MainScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
          title: Text('PV239 Sport buddy'),
        ),
        body: GradientButton(
          child: Text('Show profile'),
          onPressed: () {
          _showProfile(context);
          },
      )
    );

  }


  void _showProfile(BuildContext context) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilPage()));
  }

}