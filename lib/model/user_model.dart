import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/services/event_service.dart';
import 'package:quiver/core.dart';

class UserModel {
  final String id;
  final String name;
  final String profilePicture;

  Future<List<EventModel>> get events => EventService.fetchUsersEvents(id);

  @override
  bool operator ==(Object other) =>
      other is UserModel &&
      id == other.id &&
      name == other.name &&
      profilePicture == other.profilePicture;

  @override
  int get hashCode => hashObjects([id, name, profilePicture]);

  UserModel({
    this.id,
    this.name,
    this.profilePicture,
  });
}
