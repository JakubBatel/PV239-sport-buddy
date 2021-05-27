import 'package:flutter/src/material/time.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/enum/activity_enum.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/model/location_model.dart';
import 'package:sport_buddy/model/user_model.dart';
import 'package:sport_buddy/services/EventService.dart';

class EventCubit extends Cubit<EventModel> {
  EventCubit()
      : super(
          EventModel(
            id: '',
            name: '',
            description: '',
            activity: Activity.other,
            time: DateTime.now(),
            location: LocationModel(
              latitude: 49.2099,
              longitude: 16.5990,
            ),
            owner: null,
            maxParticipants: 8,
            unlimitedParticipants: false,
          ),
        );

  EventCubit.fromEventModel(EventModel model) : super(model);

  void setEvent(EventModel event) {
    emit(event);
  }

  void updateName(String name) {
    emit(
      EventModel(
        id: state.id,
        name: name,
        description: state.description,
        activity: state.activity,
        time: state.time,
        location: state.location,
        owner: state.owner,
        maxParticipants: state.maxParticipants,
        unlimitedParticipants: state.unlimitedParticipants,
      ),
    );
  }

  void updateDescription(String description) {
    emit(
      EventModel(
        id: state.id,
        name: state.name,
        description: description,
        activity: state.activity,
        time: state.time,
        location: state.location,
        owner: state.owner,
        maxParticipants: state.maxParticipants,
        unlimitedParticipants: state.unlimitedParticipants,
      ),
    );
  }

  void updateDate(DateTime date) {
    emit(
      EventModel(
        id: state.id,
        name: state.name,
        description: state.description,
        activity: state.activity,
        time: DateTime(
          date.year,
          date.month,
          date.day,
          state.time.hour,
          state.time.minute,
        ),
        location: state.location,
        owner: state.owner,
        maxParticipants: state.maxParticipants,
        unlimitedParticipants: state.unlimitedParticipants,
      ),
    );
  }

  void updateTime(TimeOfDay newTime) {
    emit(
      EventModel(
        id: state.id,
        name: state.name,
        description: state.description,
        activity: state.activity,
        time: DateTime(
          state.time.year,
          state.time.month,
          state.time.day,
          newTime.hour,
          newTime.minute,
        ),
        location: state.location,
        owner: state.owner,
        maxParticipants: state.maxParticipants,
        unlimitedParticipants: state.unlimitedParticipants,
      ),
    );
  }

  void updateMaxParticipants(double maxParticipants) {
    emit(
      EventModel(
        id: state.id,
        name: state.name,
        description: state.description,
        activity: state.activity,
        time: state.time,
        location: state.location,
        owner: state.owner,
        maxParticipants: maxParticipants.round(),
        unlimitedParticipants: state.unlimitedParticipants,
      ),
    );
  }

  void updateUnlimitedParticipants(bool unlimitedParticipants) {
    emit(
      EventModel(
        id: state.id,
        name: state.name,
        description: state.description,
        activity: state.activity,
        time: state.time,
        location: state.location,
        owner: state.owner,
        maxParticipants: state.maxParticipants,
        unlimitedParticipants: unlimitedParticipants,
      ),
    );
  }

  Future<void> updateActivity(Activity activity) async {
    emit(EventModel(
      id: state.id,
      name: state.name,
      description: state.description,
      activity: activity,
      time: state.time,
      location: state.location,
      owner: state.owner,
      maxParticipants: state.maxParticipants,
      unlimitedParticipants: state.unlimitedParticipants,
    ));
  }

  Future<void> updateOwner(UserModel owner) async {
    if (state.owner != null) {
      EventService.removeUserFromParticipants(
          state.owner.id, state.id);
    }
    EventService.addUserToParticipants(owner.id, state.id);
    emit(
      EventModel(
        id: state.id,
        name: state.name,
        description: state.description,
        activity: state.activity,
        time: state.time,
        location: state.location,
        owner: owner,
        maxParticipants: state.maxParticipants,
        unlimitedParticipants: state.unlimitedParticipants,
      ),
    );
  }

  setId(String id) {
    emit(
      EventModel(
        id: id,
        name: state.name,
        description: state.description,
        activity: state.activity,
        time: state.time,
        location: state.location,
        owner: state.owner,
        maxParticipants: state.maxParticipants,
        unlimitedParticipants: state.unlimitedParticipants,
      ),
    );
  }
}
