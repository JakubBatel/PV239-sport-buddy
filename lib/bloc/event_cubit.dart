import 'package:flutter/src/material/time.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sport_buddy/enum/activity_enum.dart';
import 'package:sport_buddy/model/event_detail_model.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/model/location_model.dart';
import 'package:sport_buddy/model/user_model.dart';
import 'package:sport_buddy/services/event_service.dart';

class EventCubit extends Cubit<EventDetailModel> {
  EventCubit()
      : super(
          EventDetailModel(
            event: EventModel(
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
            participants: [],
            pendingParticipants: [],
          ),
        );

  EventCubit.fromEventModel(EventModel model)
      : super(EventDetailModel(
            event: model, participants: [], pendingParticipants: [])) {
    fetchParticipantsFromDB();
    fetchPendingParticipantsFromDB();
  }

  Future<void> fetchParticipantsFromDB() async {
    emit(
      EventDetailModel(
        event: state.event,
        participants: await state.event.participants,
        pendingParticipants: state.pendingParticipants,
      ),
    );
  }

  Future<void> fetchPendingParticipantsFromDB() async {
    emit(
      EventDetailModel(
        event: state.event,
        participants: state.participants,
        pendingParticipants: await state.event.pendingParticipants,
      ),
    );
  }

  void setEvent(EventModel event) async {
    emit(
      EventDetailModel(
        event: event,
        participants: await event.participants,
        pendingParticipants: await event.pendingParticipants,
      ),
    );
  }

  Future<void> setToCurrentLocation() async {
    final currentPosition = await Geolocator.getCurrentPosition();
    updateLocation(
      LocationModel(
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude,
      ),
    );
  }

  void updateLocation(LocationModel location) {
    emit(
      EventDetailModel(
        event: EventModel(
          id: state.event.id,
          name: state.event.name,
          description: state.event.description,
          activity: state.event.activity,
          time: state.event.time,
          location: location,
          owner: state.event.owner,
          maxParticipants: state.event.maxParticipants,
          unlimitedParticipants: state.event.unlimitedParticipants,
        ),
        participants: state.participants,
        pendingParticipants: state.pendingParticipants,
      ),
    );
  }

  void updateName(String name) {
    emit(
      EventDetailModel(
        event: EventModel(
          id: state.event.id,
          name: name,
          description: state.event.description,
          activity: state.event.activity,
          time: state.event.time,
          location: state.event.location,
          owner: state.event.owner,
          maxParticipants: state.event.maxParticipants,
          unlimitedParticipants: state.event.unlimitedParticipants,
        ),
        participants: state.participants,
        pendingParticipants: state.pendingParticipants,
      ),
    );
  }

  void updateDescription(String description) {
    emit(
      EventDetailModel(
        event: EventModel(
          id: state.event.id,
          name: state.event.name,
          description: description,
          activity: state.event.activity,
          time: state.event.time,
          location: state.event.location,
          owner: state.event.owner,
          maxParticipants: state.event.maxParticipants,
          unlimitedParticipants: state.event.unlimitedParticipants,
        ),
        participants: state.participants,
        pendingParticipants: state.pendingParticipants,
      ),
    );
  }

  void updateDate(DateTime date) {
    emit(
      EventDetailModel(
        event: EventModel(
          id: state.event.id,
          name: state.event.name,
          description: state.event.description,
          activity: state.event.activity,
          time: DateTime(
            date.year,
            date.month,
            date.day,
            state.event.time.hour,
            state.event.time.minute,
          ),
          location: state.event.location,
          owner: state.event.owner,
          maxParticipants: state.event.maxParticipants,
          unlimitedParticipants: state.event.unlimitedParticipants,
        ),
        participants: state.participants,
        pendingParticipants: state.pendingParticipants,
      ),
    );
  }

  void updateTime(TimeOfDay newTime) {
    emit(
      EventDetailModel(
        event: EventModel(
          id: state.event.id,
          name: state.event.name,
          description: state.event.description,
          activity: state.event.activity,
          time: DateTime(
            state.event.time.year,
            state.event.time.month,
            state.event.time.day,
            newTime.hour,
            newTime.minute,
          ),
          location: state.event.location,
          owner: state.event.owner,
          maxParticipants: state.event.maxParticipants,
          unlimitedParticipants: state.event.unlimitedParticipants,
        ),
        participants: state.participants,
        pendingParticipants: state.pendingParticipants,
      ),
    );
  }

  void updateMaxParticipants(double maxParticipants) {
    emit(
      EventDetailModel(
        event: EventModel(
          id: state.event.id,
          name: state.event.name,
          description: state.event.description,
          activity: state.event.activity,
          time: state.event.time,
          location: state.event.location,
          owner: state.event.owner,
          maxParticipants: maxParticipants.round(),
          unlimitedParticipants: state.event.unlimitedParticipants,
        ),
        participants: state.participants,
        pendingParticipants: state.pendingParticipants,
      ),
    );
  }

  void updateUnlimitedParticipants(bool unlimitedParticipants) {
    emit(
      EventDetailModel(
        event: EventModel(
          id: state.event.id,
          name: state.event.name,
          description: state.event.description,
          activity: state.event.activity,
          time: state.event.time,
          location: state.event.location,
          owner: state.event.owner,
          maxParticipants: state.event.maxParticipants,
          unlimitedParticipants: unlimitedParticipants,
        ),
        participants: state.participants,
        pendingParticipants: state.pendingParticipants,
      ),
    );
  }

  Future<void> updateActivity(Activity activity) async {
    emit(EventDetailModel(
      event: EventModel(
        id: state.event.id,
        name: state.event.name,
        description: state.event.description,
        activity: activity,
        time: state.event.time,
        location: state.event.location,
        owner: state.event.owner,
        maxParticipants: state.event.maxParticipants,
        unlimitedParticipants: state.event.unlimitedParticipants,
      ),
      participants: state.participants,
      pendingParticipants: state.pendingParticipants,
    ));
  }


  Future<void> updateOwner(UserModel owner) async {
    emit(
      EventDetailModel(
        event: EventModel(
        id: state.event.id,
        name: state.event.name,
        description: state.event.description,
        activity: state.event.activity,
        time: state.event.time,
        location: state.event.location,
        owner: owner,
        maxParticipants: state.event.maxParticipants,
        unlimitedParticipants: state.event.unlimitedParticipants,
      ),
        participants: [...state.participants, owner],
        pendingParticipants: state.pendingParticipants,
    ));
  }





  void setId(String id) {
    emit(
      EventDetailModel(
        event: EventModel(
          id: id,
          name: state.event.name,
          description: state.event.description,
          activity: state.event.activity,
          time: state.event.time,
          location: state.event.location,
          owner: state.event.owner,
          maxParticipants: state.event.maxParticipants,
          unlimitedParticipants: state.event.unlimitedParticipants,
        ),
        participants: state.participants,
        pendingParticipants: state.pendingParticipants,
      ),
    );
  }

  void addParticipant(UserModel participant) {
    emit(
      EventDetailModel(
        event: EventModel(
          id: state.event.id,
          name: state.event.name,
          description: state.event.description,
          activity: state.event.activity,
          time: state.event.time,
          location: state.event.location,
          owner: state.event.owner,
          maxParticipants: state.event.maxParticipants,
          unlimitedParticipants: state.event.unlimitedParticipants,
        ),
        participants: [...state.participants, participant],
        pendingParticipants: state.pendingParticipants,
      ),
    );
  }

  void removeParticipant(UserModel participant) {
    EventService.removeUserFromParticipants(participant.id, state.event.id);
    emit(
      EventDetailModel(
        event: EventModel(
          id: state.event.id,
          name: state.event.name,
          description: state.event.description,
          activity: state.event.activity,
          time: state.event.time,
          location: state.event.location,
          owner: state.event.owner,
          maxParticipants: state.event.maxParticipants,
          unlimitedParticipants: state.event.unlimitedParticipants,
        ),
        participants: state.participants.where((p) => p != participant).toList(),
        pendingParticipants: state.pendingParticipants,
      ),
    );
  }

  void addPendingParticipant(UserModel participant) {
    EventService.addUserToPendingParticipant(participant.id, state.event.id);
    emit(
      EventDetailModel(
        event: EventModel(
          id: state.event.id,
          name: state.event.name,
          description: state.event.description,
          activity: state.event.activity,
          time: state.event.time,
          location: state.event.location,
          owner: state.event.owner,
          maxParticipants: state.event.maxParticipants,
          unlimitedParticipants: state.event.unlimitedParticipants,
        ),
        participants: state.participants,
        pendingParticipants: [...state.pendingParticipants, participant],
      ),
    );
  }

  void removePendingParticipant(UserModel participant) {
    EventService.removeUserFromPendingParticipants(participant.id, state.event.id);
    emit(
      EventDetailModel(
        event: EventModel(
          id: state.event.id,
          name: state.event.name,
          description: state.event.description,
          activity: state.event.activity,
          time: state.event.time,
          location: state.event.location,
          owner: state.event.owner,
          maxParticipants: state.event.maxParticipants,
          unlimitedParticipants: state.event.unlimitedParticipants,
        ),
        participants: state.participants,
        pendingParticipants: state.pendingParticipants.where((p) => p != participant).toList(),
      ),
    );
  }

  void moveToParticipants(UserModel participant) {
    EventService.removeUserFromPendingParticipants(participant.id, state.event.id);
    EventService.addUserToParticipants(participant.id, state.event.id);
    emit(
      EventDetailModel(
        event: EventModel(
          id: state.event.id,
          name: state.event.name,
          description: state.event.description,
          activity: state.event.activity,
          time: state.event.time,
          location: state.event.location,
          owner: state.event.owner,
          maxParticipants: state.event.maxParticipants,
          unlimitedParticipants: state.event.unlimitedParticipants,
        ),
        participants: [...state.participants, participant],
        pendingParticipants: state.pendingParticipants.where((p) => p != participant).toList(),
      ),
    );
  }
}
