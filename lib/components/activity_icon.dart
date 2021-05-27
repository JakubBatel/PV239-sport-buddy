import 'package:flutter/material.dart';
import 'package:sport_buddy/enum/activity_enum.dart';
import 'package:sport_buddy/utils/activity_utils.dart';

class ActivityIcon extends StatelessWidget {

  final Activity activity;
  final double size;

  ActivityIcon({this.activity, this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(getActivityIconPath(activity), width: size);
  }
}
