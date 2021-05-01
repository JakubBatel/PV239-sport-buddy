import 'package:sport_buddy/enum/activity_enum.dart';

class EventModel {
  final String name;
  final String description;
  final Activity activity;

  //final LocationModel location;
  final DateTime time;
  final int maxParticipants;
  final bool unlimitedParticipants;
  final List<String> participants;
  final String owner;

  EventModel(this.name, this.description, this.activity, this.time, this.owner,
      this.maxParticipants, this.unlimitedParticipants, this.participants);
}
