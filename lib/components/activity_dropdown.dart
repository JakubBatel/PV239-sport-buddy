import 'package:flutter/material.dart';
import 'package:sport_buddy/bloc/event_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/enum/activity_enum.dart';

class ActivityDropdown extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ActivityDropdownState();
}

class _ActivityDropdownState extends State<ActivityDropdown> {
  String _selected = '1';

  String get getSelectedActivity =>
      _activityJson.firstWhere((a) => a['id'].toString() == _selected)['name'];

  List<Map> _activityJson = [
    {'id': 1, 'image': 'assets/icons_png/other.png', 'name': 'Other'},
    {'id': 2, 'image': 'assets/icons_png/badminton.png', 'name': 'Badminton'},
    {'id': 3, 'image': 'assets/icons_png/basketball.png', 'name': 'Basketball'},
    {'id': 4, 'image': 'assets/icons_png/run.png', 'name': 'Run'},
    {'id': 5, 'image': 'assets/icons_png/bicycle.png', 'name': 'Bicycle'},
    {'id': 6, 'image': 'assets/icons_png/box.png', 'name': 'Box'},
    {'id': 7, 'image': 'assets/icons_png/football.png', 'name': 'Football'},
    {'id': 8, 'image': 'assets/icons_png/hockey.png', 'name': 'Hockey'},
    {'id': 9, 'image': 'assets/icons_png/ping_pong.png', 'name': 'PingPong'},
    {
      'id': 10,
      'image': 'assets/icons_png/rollerblade.png',
      'name': 'Rollerblade'
    },
    {'id': 11, 'image': 'assets/icons_png/rugby.png', 'name': 'Rugby'},
    {'id': 12, 'image': 'assets/icons_png/ski.png', 'name': 'Ski'},
    {'id': 13, 'image': 'assets/icons_png/snowboard.png', 'name': 'Snowboard'},
    {'id': 14, 'image': 'assets/icons_png/tennis.png', 'name': 'Tennis'},
    {
      'id': 15,
      'image': 'assets/icons_png/volleyball.png',
      'name': 'Volleyball'
    },
    {'id': 16, 'image': 'assets/icons_png/workout.png', 'name': 'Workout'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(60.0)),
        ),
      ),
      child: DropdownButton(
        onChanged: (newVal) => _updateState(newVal),
        value: _selected,
        items: _activityJson.map((item) {
          return DropdownMenuItem(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 0),
              child: Image.asset(item['image'], width: 70),
            ),
            value: item['id'].toString(),
          );
        }).toList(),
      ),
    );
  }

  void _updateState(newVal) {
    final eventCubit = context.read<EventCubit>();
    setState(() {
      _selected = newVal;
    });
    eventCubit.updateActivity(
        ActivityConverter.fromJSON(getSelectedActivity.toLowerCase()));
  }
}
