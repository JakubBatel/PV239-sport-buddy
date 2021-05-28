import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sport_buddy/components/activity_icon.dart';
import 'package:sport_buddy/components/loading.dart';
import 'package:sport_buddy/model/event_model.dart';

class EventRow extends StatelessWidget {
  final EventModel event;

  EventRow(this.event);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: ActivityIcon(
                activity: event.activity,
                size: 50,
              ),
            ),
            Text(
              event.name,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNumberOfParticipants(),
                SizedBox(height: 8),
                Text(DateFormat.yMMMd().format(event.time))
              ],
            ),
          ],
      ),
    );
  }

  Widget _buildNumberOfParticipants() {
    return FutureBuilder(
      future: event.participants,
      builder: (context, participantsSnapshot) {
        if (!participantsSnapshot.hasData) {
          return Loading();
        }

        return Text(
          "Participants: " +
              participantsSnapshot.data.length.toString() +
              "/" +
              (event.unlimitedParticipants ? '-' : event.maxParticipants.toString()),
        );
      },
    );
  }
}
