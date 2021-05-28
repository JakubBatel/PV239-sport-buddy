import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/model/user_model.dart';

class EventDetailModel {
  EventModel event;
  final List<UserModel> participants;
  final List<UserModel> pendingParticipants;

  EventDetailModel({
    this.event,
    this.participants,
    this.pendingParticipants
  });
}
