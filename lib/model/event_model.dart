import 'package:sport_buddy/enum/activity_enum.dart';
import 'package:sport_buddy/model/location_model.dart';

class EventModel {
  final String id;
  final String name;
  final String description;
  final Activity activity;
  final LocationModel location;
  final DateTime time;
  //final UserModel owner;
  final int maxParticipants;
  final bool unlimitedParticipants;
  final List<String> participants;
  final String owner;
  final List<String> pendingParticipants;

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
    this.participants,
    this.pendingParticipants,
  });

}
