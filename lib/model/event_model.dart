import 'package:quiver/core.dart';
import 'package:sport_buddy/enum/activity_enum.dart';
import 'package:sport_buddy/model/location_model.dart';
import 'package:sport_buddy/model/user_model.dart';
import 'package:sport_buddy/services/event_service.dart';

class EventModel {
  final String id;
  final String name;
  final String description;
  final Activity activity;
  final LocationModel location;
  final DateTime time;
  final int maxParticipants;
  final bool unlimitedParticipants;
  final UserModel owner;

  Future<List<UserModel>> get participants =>
      EventService.fetchParticipants(id);

  Future<List<UserModel>> get pendingParticipants =>
      EventService.fetchPendingParticipants(id);

  @override
  bool operator ==(Object other) =>
      other is EventModel &&
      id == other.id &&
      name == other.name &&
      description == other.description &&
      activity == other.activity &&
      location == other.location &&
      time == other.time &&
      maxParticipants == other.maxParticipants &&
      unlimitedParticipants == other.unlimitedParticipants &&
      owner == other.owner;

  @override
  int get hashCode => hashObjects(
        [
          id,
          name,
          description,
          activity,
          location,
          time,
          maxParticipants,
          unlimitedParticipants,
          owner
        ],
      );

  EventModel({
    this.id,
    this.name,
    this.description,
    this.activity,
    this.location,
    this.time,
    this.owner,
    this.maxParticipants,
    this.unlimitedParticipants,
  });
}
