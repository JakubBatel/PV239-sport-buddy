import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/model/location_model.dart';

class MapDataModel {
  final LocationModel center;
  final List<EventModel> events;

  MapDataModel({
    this.center,
    this.events,
  });
}
