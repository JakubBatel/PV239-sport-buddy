import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/model/location_model.dart';
import 'package:sport_buddy/model/map_data_model.dart';

class MapDataCubit extends Cubit<MapDataModel> {
  MapDataCubit() : super(MapDataModel(center: null, events: []));

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
    final List<EventModel> events = []; // TODO implement fetching
    emit(MapDataModel(center: state.center, events: events));
  }
}
