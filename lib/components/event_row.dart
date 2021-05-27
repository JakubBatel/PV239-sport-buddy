import 'package:flutter/material.dart';
import 'package:sport_buddy/components/activity_icon.dart';
import 'package:sport_buddy/model/event_model.dart';

class EventRow extends StatelessWidget {
  final EventModel event;

  EventRow(this.event);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ActivityIcon(
              activity: event.activity,
              size: 50,
            ),
          ),
          Text(event.name),
          Column(
            children: [
              Text("Participants: " + event.participants.length.toString() + "/" + event.maxParticipants.toString()),
              SizedBox(height: 8),
              Text("Date:" + event.time.toString())
            ],
          )
        ],
      ),
    );
  }
}
