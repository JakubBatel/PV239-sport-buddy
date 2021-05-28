import 'package:flutter/material.dart';
import 'package:sport_buddy/bloc/event_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/utils/activity_utils.dart';

class ActivityDropdown extends StatefulWidget {
  final String selected;

  const ActivityDropdown(this.selected);

  @override
  State<StatefulWidget> createState() => _ActivityDropdownState(selected);
}

class _ActivityDropdownState extends State<ActivityDropdown> {
  String _selected;

  _ActivityDropdownState(selected) {
    this._selected = _activityJson
        .firstWhere((element) => element['name'] == selected)['id']
        .toString();
    if (this._selected == '') this._selected = '1';
  }

  String get getSelectedActivity =>
      _activityJson.firstWhere((a) => a['id'].toString() == _selected)['name'];

  List<Map> _activityJson = [
    {'id': 1, 'image': 'assets/icons_png/other.png', 'name': 'other'},
    {'id': 2, 'image': 'assets/icons_png/badminton.png', 'name': 'badminton'},
    {'id': 3, 'image': 'assets/icons_png/basketball.png', 'name': 'basketball'},
    {'id': 4, 'image': 'assets/icons_png/run.png', 'name': 'run'},
    {'id': 5, 'image': 'assets/icons_png/bicycle.png', 'name': 'bicycle'},
    {'id': 6, 'image': 'assets/icons_png/box.png', 'name': 'box'},
    {'id': 7, 'image': 'assets/icons_png/football.png', 'name': 'football'},
    {'id': 8, 'image': 'assets/icons_png/hockey.png', 'name': 'hockey'},
    {'id': 9, 'image': 'assets/icons_png/ping_pong.png', 'name': 'pingPong'},
    {
      'id': 10,
      'image': 'assets/icons_png/rollerblade.png',
      'name': 'rollerblade'
    },
    {'id': 11, 'image': 'assets/icons_png/rugby.png', 'name': 'rugby'},
    {'id': 12, 'image': 'assets/icons_png/ski.png', 'name': 'ski'},
    {'id': 13, 'image': 'assets/icons_png/snowboard.png', 'name': 'snowboard'},
    {'id': 14, 'image': 'assets/icons_png/tennis.png', 'name': 'tennis'},
    {
      'id': 15,
      'image': 'assets/icons_png/volleyball.png',
      'name': 'volleyball'
    },
    {'id': 16, 'image': 'assets/icons_png/workout.png', 'name': 'workout'},
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
      child: DropdownButtonHideUnderline(
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
      ),
    );
  }

  void _updateState(newVal) {
    final eventCubit = context.read<EventCubit>();
    setState(() {
      _selected = newVal;
    });
    eventCubit.updateActivity(
        getActivityFromString(getSelectedActivity.toLowerCase()));
  }
}
