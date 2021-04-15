import 'package:flutter/material.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/enum/acitivity_enum.dart';

class EventRow extends StatelessWidget {

  final EventModel event;

  EventRow(this.event);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(padding: EdgeInsets.all(10.0),
          child:Image.asset(choosePicture(),
            height: 50,
            width: 50,)),
        Text(event.name)
      ],
    );
  }

  String choosePicture(){
    String path;

    switch(event.activity) {
      case Activity.football:
        path = 'assets/images/El.png';
        break;
      default:
        path = 'assets/images/El.png';
    }

    return path;

  }

}