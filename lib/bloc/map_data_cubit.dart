import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sport_buddy/enum/activity_enum.dart';
import 'package:sport_buddy/model/location_model.dart';
import 'package:sport_buddy/model/map_data_model.dart';
import 'package:sport_buddy/services/event_service.dart';

class MapDataCubit extends Cubit<MapDataModel> {
  MapDataCubit()
      : super(
          MapDataModel(
            center: null,
            events: [],
            filter: Map.fromEntries(
              Activity.values.map(
                (activity) => MapEntry(activity, false),
              ),
            ),
          ),
        ) {
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
    emit(
      MapDataModel(
        center: center,
        events: state.events,
        filter: state.filter,
      ),
    );
    fetchEvents();
  }

  void fetchEvents() async {
    final events = await EventService.fetchEventsWithinRadius(
        state.center, 10); // TODO figure out good radius

    emit(
      MapDataModel(
        center: state.center,
        events: events
            .where((event) => !state.filter[event.activity])
            .where((event) => !event.isPast)
            .toList(),
        filter: state.filter,
      ),
    );
  }

  void setFilter(Activity activity, bool filterOut) {
    emit(
      MapDataModel(
        center: state.center,
        events: state.events,
        filter: {
          ...state.filter,
          activity: filterOut,
        },
      ),
    );
    fetchEvents();
  }
}
