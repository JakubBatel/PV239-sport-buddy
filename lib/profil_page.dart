import 'package:flutter/material.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/enum/acitivity_enum.dart';
import 'package:sport_buddy/model/location_model.dart';
import 'package:sport_buddy/model/user_model.dart';
import 'components/event_row.dart';
import 'components/gradient_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/bloc/user_cubit.dart';

class ProfilPage extends StatelessWidget {




  @override
  Widget build(BuildContext context) {

    final userCubit = context.read<UserCubit>();
    //TODO: real events
    EventModel e = EventModel('Event1', 'desc', Activity.football, LocationModel(1,22), DateTime.now(), User('Joe', ""), 6, []);
    final List<EventModel> eventsMock = [e, e, e, e, e, ];

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
            Container(
              height: 300,
              child: Image.asset('assets/images/ProfilPlaceHolder.jpg', height: 200, width: 200)
            ),
            Center(
              child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child:Text(userCubit.state.name,
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                )))),
            Container(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Align(
                      alignment: Alignment.centerLeft,
                        child: Text("Past Events:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          ))),
                      ...(eventsMock.map((event) => EventRow(event)).toList())
                      ]
                  ),
                ),
            )
          ],
        )
        )
    );
  }



  void _editProfile(BuildContext context) async {
    //await Navigator.push(context, MaterialPageRoute(builder: (context) => Page()));
  }


}