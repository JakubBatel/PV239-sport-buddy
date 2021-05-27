import 'package:cloud_firestore/cloud_firestore.dart';
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

EventModel getEventFromDocument(DocumentSnapshot doc) {
  return EventModel(
    id: doc.id,
    name: doc.data()['name'],
    description: doc.data()['description'],
    activity: getActivityFromString(doc.data()['activity']),
    time: (doc.data()['time']).toDate(),
    owner: (doc.data()['owner']).toString(),
    maxParticipants: doc.data()['maxParticipants'],
    unlimitedParticipants: doc.data()['maxParticipants'] < 1,
      participants: (List.from(doc.data()['participants']))
          .map((ref) => ref.id.toString())
          .toList(),
      //participants: [],
    pendingParticipants: []
  );
}
