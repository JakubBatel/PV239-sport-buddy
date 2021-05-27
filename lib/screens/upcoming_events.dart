import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/bloc/event_cubit.dart';
import 'package:sport_buddy/bloc/user_cubit.dart';
import 'package:sport_buddy/components/event_row.dart';
import 'package:sport_buddy/components/loading.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/screens/event_detail.dart';
import 'package:sport_buddy/services/DatabaseService.dart';
import 'package:sport_buddy/utils/activity_utils.dart';

class UpcomingEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Upcoming events'),
        ),
        body: _buildContent(context));
  }

  Widget _buildContent(BuildContext context) {
    final userCubit = BlocProvider.of<UserCubit>(context);

    return StreamBuilder<QuerySnapshot>(
        stream: DatabaseService().getUpcomingEvents(userCubit.state.userID),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }

          if (snapshot.data == null) return Loading();
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                final model = getEventFromSnapshot(snapshot.data.docs[index].data());

                return GestureDetector(
                  onTap: () {
                    _openEventDetail(context, model);
                  },
                  child: EventRow(model),
                );
              });
        });
  }

  void _openEventDetail(BuildContext context, EventModel event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<EventCubit>(
          create: (context) => EventCubit.fromEventModel(event),
          child: EventDetail(),
        ),
      ),
    );
  }
}
