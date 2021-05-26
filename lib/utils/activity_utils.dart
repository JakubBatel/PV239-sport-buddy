import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sport_buddy/enum/activity_enum.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:sport_buddy/model/event_model.dart';

String getActivityName(Activity activity) {
  return EnumToString.convertToString(activity);
}

Activity getActivityFromString(String activity) {
  return EnumToString.fromString(Activity.values, activity);
}

String getActivityIconPath(Activity activity) {
  return 'assets/icons_png/${getActivityName(activity)}.png';
}

EventModel getEventFromSnapshot(Map<String, dynamic> eventSnapshot) {
  List<dynamic> pendingParticipants = eventSnapshot['pendingParticipants'];

  if (pendingParticipants == null) {
    pendingParticipants = [];
  } else {
    pendingParticipants =
        List.from(pendingParticipants).map((ref) => ref.id.toString()).toList();
  }

  List<dynamic> participants = eventSnapshot['pendingParticipants'];

  if (participants == null) {
    participants = [];
  } else {
    participants = List.from(participants).map((ref) => ref.id.toString()).toList();
  }

  return EventModel(
      name: eventSnapshot['name'],
      description: eventSnapshot['description'],
      activity: getActivityFromString(eventSnapshot['activity']),
      time: (eventSnapshot['time']).toDate(),
      owner: (eventSnapshot['owner']).toString(),
      maxParticipants: eventSnapshot['maxParticipants'],
      unlimitedParticipants: eventSnapshot['maxParticipants'] < 1,
      participants: participants.map((ref) => ref.toString()).toList(),
      pendingParticipants: pendingParticipants.map((ref) => ref.toString()).toList()
  );
}
