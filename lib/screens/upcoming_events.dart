import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/bloc/event_cubit.dart';
import 'package:sport_buddy/bloc/user_cubit.dart';
import 'package:sport_buddy/components/event_row.dart';
import 'package:sport_buddy/components/loading.dart';
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
        body: _buildContent(context)
    );
  }

  Widget _buildContent(BuildContext context) {
    final userCubit = BlocProvider.of<UserCubit>(context);
    final eventCubit = BlocProvider.of<EventCubit>(context);

    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Text("Upcoming Events:",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline4)),
      StreamBuilder<QuerySnapshot>(
          stream: DatabaseService().getUpcomingEvents(userCubit.state.userID),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Center(child: Text(snapshot.error.toString()));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }

            if (snapshot.data == null) return Loading();
            return Column(
                children: snapshot.data.docs
                    .map((DocumentSnapshot doc) {
                  final model = getEventFromDocument(doc);

                  return GestureDetector(
                    onTap: () {
                      eventCubit.emit(model);
                      _openEventDetail(context);
                    },
                    child: EventRow(model),
                  );
                }
                )
                    .toList());
          }),
    ]);
  }

  void _openEventDetail(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) =>
                BlocProvider.value(
                  value: BlocProvider.of<EventCubit>(context),
                  child: Scaffold(
                      appBar: AppBar(
                        title: Text('Upcoming events'),
                      ),
                      body: EventDetail()
                  ),
                )
        )
    );
  }
}