import 'package:flutter/material.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/enum/activity_enum.dart';
import 'package:sport_buddy/model/location_model.dart';
import 'package:sport_buddy/model/user_model.dart';
import 'components/event_row.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/bloc/user_cubit.dart';

class ProfilPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          title: Text('My profile'),
          actions: [IconButton(
              icon: Icon(Icons.mode_edit),
              onPressed: () => _editProfile(context)
          )],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildUserInfo(context),
            _buildPastEvents()
          ],
        )
        )
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    return Column(
      children: [
        Container(
            height: 250,
            child: Image.asset(userCubit.state.profilePicture, height: 200, width: 200)
        ),
        Center(
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child:Text(userCubit.state.name,
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    )
                )
            )
        ),
      ],
    );
  }

  Widget _buildPastEvents() {
    //TODO: real events
    EventModel e = EventModel('Fotbal na Svoboďáku', 'desc', Activity.football, LocationModel(1,22), DateTime.now(), User('Joe', ""), 6, []);
    EventModel e2 = EventModel('StreetWorkout', 'desc', Activity.workout, LocationModel(1,22), DateTime.now(), User('Joe', ""), 6, []);
    EventModel e3 = EventModel('Čunča', 'desc', Activity.basketball, LocationModel(1,22), DateTime.now(), User('Joe', ""), 6, []);
    final List<EventModel> eventsMock = [e, e2, e3, e2,e2, e3, e2, e,e];


    return Column(
      children:[
        Align(
            alignment: Alignment.centerLeft,
            child: Text("Past Events:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18
                )
            )
        ),
        Container(
          height: 310,
          child: ListView(
              children: [
                ...(eventsMock.map((event) => EventRow(event)).toList())
              ],
          ),
        ),
      ]
    );
  }




  void _editProfile(BuildContext context) async {
    // TODO: implement edit profile
  }


}