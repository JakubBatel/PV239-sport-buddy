import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/bloc/event_cubit.dart';
import 'package:sport_buddy/bloc/user_cubit.dart';
import 'package:sport_buddy/components/event_row.dart';
import 'package:sport_buddy/components/loading.dart';
import 'package:sport_buddy/model/event_model.dart';
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
    final user = BlocProvider.of<UserCubit>(context).state;

    return FutureBuilder(
      future: user.events,
      builder: (context, eventsSnapshot) {
        if (eventsSnapshot.hasError) {
          return Text(eventsSnapshot.error.toString());
        }
        if (!eventsSnapshot.hasData) {
          return Loading();
        }

        return ListView(
          padding: EdgeInsets.all(15.0),
          children: eventsSnapshot.data
              .where((event) => DateTime.now().isBefore(event.time))
              .map<Widget>(
                (event) => GestureDetector(
                  onTap: () {
                    _openEventDetail(context, event);
                  },
                  child: EventRow(event),
                ),
              )
              .toList(),
        );
      },
    );
  }

  void _openEventDetail(BuildContext context, EventModel event) {
    final eventCubit = context.read<EventCubit>();
    eventCubit.setEvent(event);
    eventCubit.setId(event.id);
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
