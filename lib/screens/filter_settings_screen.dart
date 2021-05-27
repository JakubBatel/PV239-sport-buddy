import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/bloc/map_data_cubit.dart';
import 'package:sport_buddy/components/activity_icon.dart';
import 'package:sport_buddy/components/gradient_app_bar.dart';
import 'package:sport_buddy/enum/activity_enum.dart';
import 'package:sport_buddy/model/map_data_model.dart';
import 'package:sport_buddy/utils/activity_utils.dart';

class FilterSettingsScreen extends StatelessWidget {
  Widget _buildIconWithName(BuildContext context, Activity activity) {
    return Row(
      children: [
        ActivityIcon(
          activity: activity,
          size: 36,
        ),
        SizedBox(width: 15),
        Text(
          getActivityName(activity),
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }

  Widget _buildSwitch(
    BuildContext context,
    Activity activity,
    MapDataModel mapData,
  ) {
    return Switch(
      value: !mapData.filter[activity],
      onChanged: (bool newValue) =>
          BlocProvider.of<MapDataCubit>(context).setFilter(activity, !newValue),
    );
  }

  Widget _buildSwitchRow(
    BuildContext context,
    Activity activity,
    MapDataModel mapData,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconWithName(context, activity),
          _buildSwitch(context, activity, mapData),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, MapDataModel mapData) {
    return ListView(
      children: Activity.values
          .map(
            (activity) => _buildSwitchRow(context, activity, mapData),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(),
      body: BlocBuilder<MapDataCubit, MapDataModel>(
        builder: (context, mapData) => _buildList(context, mapData),
      ),
    );
  }
}
