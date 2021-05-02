import 'package:flutter/src/material/time.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/enum/activity_enum.dart';
import 'package:sport_buddy/model/event_model.dart';

class EventCubit extends Cubit<EventModel> {
  EventCubit()
      : super(
          EventModel(
            name: '',
            description: '',
            activity: Activity.other,
            time: DateTime.now(),
            owner: '',
            maxParticipants: 8,
            unlimitedParticipants: false,
            participants: [],
          ),
        );

  updateName(String newName) {
    final newEventModel = EventModel(
      name: newName,
      description: state.description,
      activity: state.activity,
      time: state.time,
      owner: state.owner,
      maxParticipants: state.maxParticipants,
      unlimitedParticipants: state.unlimitedParticipants,
      participants: state.participants,
    );
    emit(newEventModel);
  }

  updateDescription(String text) {
    final newEventModel = EventModel(
      name: state.name,
      description: text,
      activity: state.activity,
      time: state.time,
      owner: state.owner,
      maxParticipants: state.maxParticipants,
      unlimitedParticipants: state.unlimitedParticipants,
      participants: state.participants,
    );
    emit(newEventModel);
  }

  updateDate(DateTime date) {
    final newDate = DateTime(
      date.year,
      date.month,
      date.day,
      state.time.hour,
      state.time.minute,
    );
    final newEventModel = EventModel(
      name: state.name,
      description: state.description,
      activity: state.activity,
      time: newDate,
      owner: state.owner,
      maxParticipants: state.maxParticipants,
      unlimitedParticipants: state.unlimitedParticipants,
      participants: state.participants,
    );
    emit(newEventModel);
  }

  void updateTime(TimeOfDay newTime) {
    final newDate = DateTime(
      state.time.year,
      state.time.month,
      state.time.day,
      newTime.hour,
      newTime.minute,
    );
    final newEventModel = EventModel(
      name: state.name,
      description: state.description,
      activity: state.activity,
      time: newDate,
      owner: state.owner,
      maxParticipants: state.maxParticipants,
      unlimitedParticipants: state.unlimitedParticipants,
      participants: state.participants,
    );
    emit(newEventModel);
  }

  void updateMaxParticipants(double value) {
    final newEventModel = EventModel(
      name: state.name,
      description: state.description,
      activity: state.activity,
      time: state.time,
      owner: state.owner,
      maxParticipants: value.round(),
      unlimitedParticipants: state.unlimitedParticipants,
      participants: state.participants,
    );
    emit(newEventModel);
  }

  void updateUnlimitedParticipants(bool value) {
    final newEventModel = EventModel(
      name: state.name,
      description: state.description,
      activity: state.activity,
      time: state.time,
      owner: state.owner,
      maxParticipants: state.maxParticipants,
      unlimitedParticipants: value,
      participants: state.participants,
    );
    emit(newEventModel);
  }

  void updateActivity(Activity activity) {
    final newEventModel = EventModel(
      name: state.name,
      description: state.description,
      activity: activity,
      time: state.time,
      owner: state.owner,
      maxParticipants: state.maxParticipants,
      unlimitedParticipants: state.unlimitedParticipants,
      participants: state.participants,
    );
    emit(newEventModel);
  }

  addOwner(String ownerId) {
    final addOwnerAsParticipants = [...state.participants, '/users/$ownerId'];
    final newEventModel = EventModel(
      name: state.name,
      description: state.description,
      activity: state.activity,
      time: state.time,
      owner: ownerId,
      maxParticipants: state.maxParticipants,
      unlimitedParticipants: state.unlimitedParticipants,
      participants: addOwnerAsParticipants,
    );
    emit(newEventModel);
  }
}
