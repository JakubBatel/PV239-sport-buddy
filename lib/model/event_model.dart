import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sport_buddy/model/location_model.dart';
import 'package:sport_buddy/model/user_model.dart';
import 'package:sport_buddy/enum/activity_enum.dart';

class EventModel {
  final String name;
  final String description;
  final Activity activity;
  final LocationModel location;
  final Timestamp time;
  //final UserModel owner;
  final int maxParticipants;
  final List<String> participants;
  //final List<UserModel> participants;

  final String owner;

  EventModel({
    this.name,
    this.description,
    this.activity,
    this.location,
    this.time,
    this.owner,
    this.maxParticipants,
    this.participants,
  });

//EventModel(this.name,this.description, this.activity, this.location, this.time, this.owner, this.maxParticipants, this.participants);
}
