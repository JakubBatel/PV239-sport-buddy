import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/bloc/event_cubit.dart';
import 'package:sport_buddy/components/activity_icon.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/screens/event_detail.dart';

class EventMarkerIconButton extends StatelessWidget {
  final EventModel event;

  EventMarkerIconButton({this.event});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: ActivityIcon(
        activity: event.activity,
      ),
      onPressed: () {
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
      },
    );
  }
}
