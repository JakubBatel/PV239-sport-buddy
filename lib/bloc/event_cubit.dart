import 'package:flutter/src/material/time.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/enum/activity_enum.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/services/DatabaseService.dart';

class EventCubit extends Cubit<EventModel> {
  EventCubit()
      : super(
          EventModel(
            id: '',
            name: '',
            description: '',
            activity: Activity.other,
            time: DateTime.now(),
            owner: '',
            maxParticipants: 8,
            unlimitedParticipants: false,
            participants: [],
            pendingParticipants: [],
          ),
        );

  EventCubit.fromEventModel(EventModel model) : super(model);

  updateName(String newName) {
    final newEventModel = EventModel(
      id: state.id,
      name: newName,
      description: state.description,
      activity: state.activity,
      time: state.time,
      owner: state.owner,
      maxParticipants: state.maxParticipants,
      unlimitedParticipants: state.unlimitedParticipants,
      participants: state.participants,
      pendingParticipants: state.pendingParticipants,
    );
    emit(newEventModel);
  }

  updateDescription(String text) {
    final newEventModel = EventModel(
      id: state.id,
      name: state.name,
      description: text,
      activity: state.activity,
      time: state.time,
      owner: state.owner,
      maxParticipants: state.maxParticipants,
      unlimitedParticipants: state.unlimitedParticipants,
      participants: state.participants,
      pendingParticipants: state.pendingParticipants,
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
      id: state.id,
      name: state.name,
      description: state.description,
      activity: state.activity,
      time: newDate,
      owner: state.owner,
      maxParticipants: state.maxParticipants,
      unlimitedParticipants: state.unlimitedParticipants,
      participants: state.participants,
      pendingParticipants: state.pendingParticipants,
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
      id: state.id,
      name: state.name,
      description: state.description,
      activity: state.activity,
      time: newDate,
      owner: state.owner,
      maxParticipants: state.maxParticipants,
      unlimitedParticipants: state.unlimitedParticipants,
      participants: state.participants,
      pendingParticipants: state.pendingParticipants,
    );
    emit(newEventModel);
  }

  void updateMaxParticipants(double value) {
    final newEventModel = EventModel(
      id: state.id,
      name: state.name,
      description: state.description,
      activity: state.activity,
      time: state.time,
      owner: state.owner,
      maxParticipants: value.round(),
      unlimitedParticipants: state.unlimitedParticipants,
      participants: state.participants,
      pendingParticipants: state.pendingParticipants,
    );
    emit(newEventModel);
  }

  void updateUnlimitedParticipants(bool value) {
    final newEventModel = EventModel(
      id: state.id,
      name: state.name,
      description: state.description,
      activity: state.activity,
      time: state.time,
      owner: state.owner,
      maxParticipants: state.maxParticipants,
      unlimitedParticipants: value,
      participants: state.participants,
      pendingParticipants: state.pendingParticipants,
    );
    emit(newEventModel);
  }

  void updateActivity(Activity activity) {
    final newEventModel = EventModel(
      id: state.id,
      name: state.name,
      description: state.description,
      activity: activity,
      time: state.time,
      owner: state.owner,
      maxParticipants: state.maxParticipants,
      unlimitedParticipants: state.unlimitedParticipants,
      participants: state.participants,
      pendingParticipants: state.pendingParticipants,
    );
    emit(newEventModel);
  }

  addOwner(String ownerId) {
    final addOwnerAsParticipants = [...state.participants, ownerId];
    final newEventModel = EventModel(
      id: state.id,
      name: state.name,
      description: state.description,
      activity: state.activity,
      time: state.time,
      owner: ownerId,
      maxParticipants: state.maxParticipants,
      unlimitedParticipants: state.unlimitedParticipants,
      participants: addOwnerAsParticipants,
      pendingParticipants: state.pendingParticipants,
    );
    emit(newEventModel);
  }

  addParticipant(String participantId, String eventId) {
    final newParticipants = [...state.participants, participantId];
    final newPendingParticipants = state.pendingParticipants.where((id) => id != participantId).toList();
    final newEventModel = EventModel(
      id: state.id,
      name: state.name,
      description: state.description,
      activity: state.activity,
      time: state.time,
      owner: state.owner,
      maxParticipants: state.maxParticipants,
      unlimitedParticipants: state.unlimitedParticipants,
      participants: newParticipants,
      pendingParticipants: newPendingParticipants,
    );
    emit(newEventModel);
    DatabaseService().addParticipant(participantId, eventId);
  }

  addParticipantToPending(String participantId, String eventId) {
    final newPendingParticipants = [...state.pendingParticipants, participantId];
    final newEventModel = EventModel(
      id: state.id,
      name: state.name,
      description: state.description,
      activity: state.activity,
      time: state.time,
      owner: state.owner,
      maxParticipants: state.maxParticipants,
      unlimitedParticipants: state.unlimitedParticipants,
      participants: state.participants,
      pendingParticipants: newPendingParticipants,
    );
    emit(newEventModel);
    DatabaseService().addParticipantToPending(participantId, eventId);
  }

  deleteParticipant(String participantId, String eventId) {
    final newParticipants = state.participants.where((id) => id != participantId).toList();
    final newEventModel = EventModel(
      id: state.id,
      name: state.name,
      description: state.description,
      activity: state.activity,
      time: state.time,
      owner: state.owner,
      maxParticipants: state.maxParticipants,
      unlimitedParticipants: state.unlimitedParticipants,
      participants: newParticipants,
      pendingParticipants: state.pendingParticipants,
    );
    emit(newEventModel);
    DatabaseService().deleteParticipant(participantId, eventId);
  }


  deletePendingParticipant(String participantId, String eventId) {
    final newPendingParticipants = state.pendingParticipants.where((id) => id != participantId).toList();
    final newEventModel = EventModel(
      id: state.id,
      name: state.name,
      description: state.description,
      activity: state.activity,
      time: state.time,
      owner: state.owner,
      maxParticipants: state.maxParticipants,
      unlimitedParticipants: state.unlimitedParticipants,
      participants: state.participants,
      pendingParticipants: newPendingParticipants,
    );
    emit(newEventModel);
    DatabaseService().deletePendingParticipant(participantId, eventId);
  }

  setId(String id) {
    final newEventModel = EventModel(
      id: id,
      name: state.name,
      description: state.description,
      activity: state.activity,
      time: state.time,
      owner: state.owner,
      maxParticipants: state.maxParticipants,
      unlimitedParticipants: state.unlimitedParticipants,
      participants: state.participants,
      pendingParticipants: state.pendingParticipants,
    );
    emit(newEventModel);
  }

  setDefaultSliderValueIfUnlimitedParticipants() {
    if (state.unlimitedParticipants == true) {
      final newEventModel = EventModel(
        id: state.id,
        name: state.name,
        description: state.description,
        activity: state.activity,
        time: state.time,
        owner: state.owner,
        maxParticipants: 8,
        unlimitedParticipants: state.unlimitedParticipants,
        participants: state.participants,
        pendingParticipants: state.pendingParticipants,
      );
      emit(newEventModel);
    }
  }


}
