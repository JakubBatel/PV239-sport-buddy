import 'package:sport_buddy/enum/activity_enum.dart';
import 'package:sport_buddy/model/location_model.dart';
import 'package:sport_buddy/model/user_model.dart';

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
  final List<UserModel> participants;
  final List<UserModel> pendingParticipants;

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
