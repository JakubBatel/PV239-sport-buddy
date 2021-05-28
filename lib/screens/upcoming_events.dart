import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/bloc/event_cubit.dart';
import 'package:sport_buddy/bloc/user_cubit.dart';
import 'package:sport_buddy/components/event_row.dart';
import 'package:sport_buddy/components/loading.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/model/user_model.dart';
import 'package:sport_buddy/screens/event_detail.dart';

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
    return BlocBuilder<UserCubit, UserModel>(
      builder: (context, user) {
        return FutureBuilder(
          future: user.events,
          builder: (context, eventsSnapshot) {
            if (eventsSnapshot.hasError) {
              return Text(eventsSnapshot.error.toString());
            }
            if (!eventsSnapshot.hasData) {
              return Loading();
            }

            final events = eventsSnapshot.data
                .where((event) => DateTime.now().isBefore(event.time))
                .map<Widget>(
                  (event) => GestureDetector(
                    onTap: () {
                      _openEventDetail(context, event);
                    },
                    child: EventRow(event),
                  ),
                )
                .toList();

            if (events.isEmpty) {
              return Center(
                child: Text("You have no upcoming events"),
              );
            }
            return ListView(padding: EdgeInsets.all(15.0), children: events);
          },
        );
      },
    );
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
