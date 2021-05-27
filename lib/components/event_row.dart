import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: ActivityIcon(
                activity: event.activity,
                size: 50,
              ),
            ),
            Text(event.name)
          ]),
          Text(DateFormat('kk:mm  dd. MM. yyyy').format(event.time).toString(),
              style: Theme.of(context).textTheme.headline4),
        ],
      ),
    );
  }
}
