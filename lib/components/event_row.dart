import 'package:flutter/material.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/enum/activity_enum.dart';

class EventRow extends StatelessWidget {

  final EventModel event;

  EventRow(this.event);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        children: [
          Padding(padding: EdgeInsets.all(10.0),
            child:Image.asset(choosePicture(),
              height: 50,
              width: 50,)),
          Text(event.name)
        ],
      ),
    );
  }

  String choosePicture(){
    String path;

    switch(event.activity) {
      case Activity.badminton:
        path = 'assets/icons_png/badminton.png';
        break;
      case Activity.basketball:
        path = 'assets/icons_png/basketball.png';
        break;
      case Activity.bicycle:
        path = 'assets/icons_png/bicycle.png';
        break;
      case Activity.box:
        path = 'assets/icons_png/box.png';
        break;
      case Activity.football:
        path = 'assets/icons_png/football.png';
        break;
      case Activity.hockey:
        path = 'assets/icons_png/hockey.png';
        break;
      case Activity.pingpong:
        path = 'assets/icons_png/ping_pong.png';
        break;
      case Activity.rollerblade:
        path = 'assets/icons_png/rollerblade.png';
        break;
      case Activity.rugby:
        path = 'assets/icons_png/rugby.png';
        break;
      case Activity.run:
        path = 'assets/icons_png/run.png';
        break;
      case Activity.ski:
        path = 'assets/icons_png/ski.png';
        break;
      case Activity.snowboard:
        path = 'assets/icons_png/snowboard.png';
        break;
      case Activity.tennis:
        path = 'assets/icons_png/tennis.png';
        break;
      case Activity.volleyball:
        path = 'assets/icons_png/volleyball.png';
        break;
      case Activity.workout:
        path = 'assets/icons_png/workout.png';
        break;

      default:
        path = 'assets/icons_png/other.png';
    }

    return path;

  }

}