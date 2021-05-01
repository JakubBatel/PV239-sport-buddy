import 'package:flutter/src/material/time.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/enum/activity_enum.dart';
import 'package:sport_buddy/model/event_model.dart';

class EventCubit extends Cubit<EventModel> {
  EventCubit()
      : super(EventModel(
            '', '', Activity.other, DateTime.now(), '', 8, false, []));

  updateName(String newName) {
    final newEventModel = EventModel(
        newName,
        state.description,
        state.activity,
        state.time,
        state.owner,
        state.maxParticipants,
        state.unlimitedParticipants,
        state.participants);
    emit(newEventModel);
  }

  updateDescription(String text) {
    final newEventModel = EventModel(
        state.name,
        text,
        state.activity,
        state.time,
        state.owner,
        state.maxParticipants,
        state.unlimitedParticipants,
        state.participants);
    emit(newEventModel);
  }

  updateDate(DateTime date) {
    final newDate = DateTime(
        date.year, date.month, date.day, state.time.hour, state.time.minute);
    final newEventModel = EventModel(
        state.name,
        state.description,
        state.activity,
        newDate,
        state.owner,
        state.maxParticipants,
        state.unlimitedParticipants,
        state.participants);
    emit(newEventModel);
  }

  void updateTime(TimeOfDay newTime) {
    final newDate = DateTime(state.time.year, state.time.month, state.time.day,
        newTime.hour, newTime.minute);
    final newEventModel = EventModel(
        state.name,
        state.description,
        state.activity,
        newDate,
        state.owner,
        state.maxParticipants,
        state.unlimitedParticipants,
        state.participants);
    emit(newEventModel);
  }

  void updateMaxParticipants(double value) {
    final newEventModel = EventModel(
        state.name,
        state.description,
        state.activity,
        state.time,
        state.owner,
        value.round(),
        state.unlimitedParticipants,
        state.participants);
    emit(newEventModel);
  }

  void updateUnlimitedParticipants(bool value) {
    final newEventModel = EventModel(
        state.name,
        state.description,
        state.activity,
        state.time,
        state.owner,
        state.maxParticipants,
        value,
        state.participants);
    emit(newEventModel);
  }

  void updateActivity(Activity activity) {
    final newEventModel = EventModel(
        state.name,
        state.description,
        activity,
        state.time,
        state.owner,
        state.maxParticipants,
        state.unlimitedParticipants,
        state.participants);
    emit(newEventModel);
  }

  addOwner(String ownerId) {
    final addOwnerAsParticipants = [...state.participants, '/users/$ownerId'];
    final newEventModel = EventModel(
        state.name,
        state.description,
        state.activity,
        state.time,
        ownerId,
        state.maxParticipants,
        state.unlimitedParticipants,
        addOwnerAsParticipants);
    emit(newEventModel);
  }
}
