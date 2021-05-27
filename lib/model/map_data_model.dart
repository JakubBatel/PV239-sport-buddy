import 'package:flutter_map/flutter_map.dart';
import 'package:sport_buddy/enum/activity_enum.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/model/location_model.dart';

class MapDataModel {
  final LocationModel center;
  final List<EventModel> events;
  final MapController mapController;
  final Map<Activity, bool> filter;

  MapDataModel({
    this.center,
    this.events,
    this.mapController,
    this.filter,
  });
}
