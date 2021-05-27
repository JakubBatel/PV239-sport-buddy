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
            participants: [],
            pendingParticipants: [],
          ),
        );

  EventCubit.fromEventModel(EventModel model) : super(model);

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
        participants: state.participants,
        pendingParticipants: state.pendingParticipants,
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
        participants: state.participants,
        pendingParticipants: state.pendingParticipants,
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
        participants: state.participants,
        pendingParticipants: state.pendingParticipants,
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
        participants: state.participants,
        pendingParticipants: state.pendingParticipants,
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
        participants: state.participants,
        pendingParticipants: state.pendingParticipants,
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
        participants: state.participants,
        pendingParticipants: state.pendingParticipants,
      ),
    );
  }

  Future<void> updateActivity(Activity activity) {
    final newEventModel = EventModel(
      id: state.id,
      name: state.name,
      description: state.description,
      activity: activity,
      time: state.time,
      location: state.location,
      owner: state.owner,
      maxParticipants: state.maxParticipants,
      unlimitedParticipants: state.unlimitedParticipants,
      participants: state.participants,
      pendingParticipants: state.pendingParticipants,
    );
    emit(newEventModel);
  }

  void updateOwner(UserModel owner) {
    if (state.owner != null) {
      removeParticipant(state.owner);
    }
    addParticipant(owner);
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
        participants: state.participants,
        pendingParticipants: state.pendingParticipants,
      ),
    );
  }

  void addParticipant(UserModel participant) async {
    await EventService.addUserToParticipants(participant.id, state.id);
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
        unlimitedParticipants: state.unlimitedParticipants,
        participants: [...state.participants, participant],
        pendingParticipants: state.pendingParticipants,
      ),
    );
  }

  Future<void> addParticipantToPending(UserModel participant) async {
    await EventService.addUserToPendingParticipant(participant.id, state.id);
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
        unlimitedParticipants: state.unlimitedParticipants,
        participants: state.participants,
        pendingParticipants: [...state.pendingParticipants, participant],
      ),
    );
  }

  void moveToParticipantsFromPending(UserModel participant) {
    removePendingParticipant(participant);
    addParticipant(participant);
  }

  Future<void> removeParticipant(UserModel participant) async {
    await EventService.removeUserFromParticipants(participant.id, state.id);
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
        unlimitedParticipants: state.unlimitedParticipants,
        participants:
            state.participants.where((p) => p != participant).toList(),
        pendingParticipants: state.pendingParticipants,
      ),
    );
  }

  Future<void> removePendingParticipant(UserModel participant) async {
    await EventService.removeUserFromPendingParticipants(
        participant.id, state.id);
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
        unlimitedParticipants: state.unlimitedParticipants,
        participants: state.participants,
        pendingParticipants:
            state.pendingParticipants.where((p) => p != participant).toList(),
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
        participants: state.participants,
        pendingParticipants: state.pendingParticipants,
      ),
    );
  }
}
