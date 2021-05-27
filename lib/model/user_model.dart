import 'package:sport_buddy/model/event_model.dart';

class UserModel {
  final String id;
  final String name;
  final String profilePicture;
  final List<EventModel> events;

  UserModel({
    this.id,
    this.name,
    this.profilePicture,
    this.events = const [],
  });
}
