import 'package:flutter/material.dart';
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetail(
              //event: event,
            ),
          ),
        );
      },
    );
  }
}
