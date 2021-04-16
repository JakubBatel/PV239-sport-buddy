import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/enum/activity_enum.dart';
import 'package:sport_buddy/model/location_model.dart';
import 'package:sport_buddy/model/user_model.dart';
import 'package:sport_buddy/screens/main_screen.dart';
import 'package:sport_buddy/views/login.dart';
import 'components/event_row.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/bloc/user_cubit.dart';

class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My profile'),
          actions: [
            IconButton(
                icon: Icon(Icons.logout), onPressed: () => _openLogin(context))
          ],
        ),
        body: Center(
            child: ListView(
          padding: EdgeInsets.all(20.0),
          children: [
            _buildUserInfo(context),
            SizedBox(height: 20),
            _buildPastEvents(context)
          ],
        )));
  }

  Widget _buildUserInfo(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    return Column(
      children: [
        Container(
            height: 250,
            child: Image.asset(userCubit.state.profilePicture,
                height: 250, width: 200)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(userCubit.state.name,
                    style: Theme.of(context).textTheme.headline4),
              ),
            ),
            IconButton(icon: Icon(Icons.mode_edit), onPressed: () => {}),
          ],
        )
      ],
    );
  }

  Widget _buildPastEvents(BuildContext context) {
    //TODO: real events
    EventModel e = EventModel('Fotbal na Svoboďáku', 'desc', Activity.football,
        LocationModel(1, 22), DateTime.now(), UserModel('Joe', ""), 6, []);
    EventModel e2 = EventModel('StreetWorkout', 'desc', Activity.workout,
        LocationModel(1, 22), DateTime.now(), UserModel('Joe', ""), 6, []);
    EventModel e3 = EventModel('Čunča', 'desc', Activity.basketball,
        LocationModel(1, 22), DateTime.now(), UserModel('Joe', ""), 6, []);
    final List<EventModel> eventsMock = [e, e2, e3, e2, e2, e3, e2, e, e];

    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Text("Past Events:",
              style: Theme.of(context).textTheme.headline6)),
      Column(
        children: [...(eventsMock.map((event) => EventRow(event)).toList())],
      ),
    ]);
  }

  void _openLogin(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => BlocProvider.value(
                value: BlocProvider.of<UserCubit>(context), child: Login())));
  }
}
