import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/services/event_service.dart';

class UserModel {
  final String id;
  final String name;
  final String profilePicture;

  Future<List<EventModel>> get events => EventService.fetchUsersEvents(id);

  UserModel({
    this.id,
    this.name,
    this.profilePicture,
  });
}
