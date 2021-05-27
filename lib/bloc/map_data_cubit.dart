import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/model/location_model.dart';
import 'package:sport_buddy/model/map_data_model.dart';
import 'package:sport_buddy/services/EventService.dart';

class MapDataCubit extends Cubit<MapDataModel> {
  MapDataCubit() : super(MapDataModel(center: null, events: [])) {
    setToCurrentLocation();
  }

  void setToCurrentLocation() async {
    final currentPosition = await Geolocator.getCurrentPosition();
    setToLocation(
      LocationModel(
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude,
      ),
    );
  }

  void setToLocation(LocationModel center) {
    emit(MapDataModel(center: center, events: state.events));
    fetchEvents();
  }

  void fetchEvents() async {
    final events = await EventService.fetchEventsWithinRadius(state.center, 10); // TODO figure out good radius
    emit(MapDataModel(center: state.center, events: events));
  }
}
