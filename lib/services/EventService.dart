import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/model/location_model.dart';
import 'package:sport_buddy/model/user_model.dart';
import 'package:sport_buddy/utils/activity_utils.dart';

class EventService {
  static final eventsCollection =
      FirebaseFirestore.instance.collection('events');

  static final usersCollection = FirebaseFirestore.instance.collection('users');

  static Future<UserModel> _fetchUser(DocumentReference reference) async {
    final doc = await reference.get();
    return UserModel(
      id: doc.id,
      name: doc.get('name'),
      profilePicture: doc.get('profilePicture'),
    );
  }

  static Future<List<UserModel>> _fetchUsers(
    List<DocumentReference> references,
  ) async {
    List<UserModel> users = [];
    for (final reference in references) {
      users.add(await _fetchUser(reference));
    }
    return users;
  }

  static Future<EventModel> _mapToEventModel(
    DocumentSnapshot eventSnapshot,
  ) async {
    return EventModel(
      id: eventSnapshot.reference.id,
      name: eventSnapshot.get('name'),
      description: eventSnapshot.get('description'),
      activity: getActivityFromString(eventSnapshot.get('activity')),
      location: LocationModel(
        latitude: eventSnapshot.get('latitude'),
        longitude: eventSnapshot.get('longitude'),
      ),
      time: DateTime.parse(eventSnapshot.get('time').toDate().toString()),
      owner: await _fetchUser(eventSnapshot.get('owner')),
      maxParticipants: eventSnapshot.get('maxParticipants'),
      unlimitedParticipants: eventSnapshot.get('maxParticipants') == 0,
      participants: await _fetchUsers(eventSnapshot.get('participants')),
      pendingParticipants:
          await _fetchUsers(eventSnapshot.get('pendingParticipants')),
    );
  }

  static Future<void> addEvent(EventModel event) async {
    return eventsCollection.add(
      {
        'name': event.name,
        'description': event.description,
        'activity': getActivityName(event.activity),
        'latitude': event.location.latitude,
        'longitude': event.location.longitude,
        'time': event.time,
        'owner': usersCollection.doc(event.owner.id),
        'maxParticipants':
            event.unlimitedParticipants ? 0 : event.maxParticipants,
        'participants': event.participants
            .map((participant) => usersCollection.doc(participant.id))
            .toList(),
        'pendingParticipants': event.pendingParticipants
            .map((participant) => usersCollection.doc(participant.id))
            .toList(),
      },
    );
  }

  static Future<void> updateEvent(EventModel event) async {
    // TODO
  }

  static Future<EventModel> fetchEvent(String eventId) async {
    return _mapToEventModel(await eventsCollection.doc(eventId).get());
  }

  static Future<List<EventModel>> fetchEventsWithinRadius(
    LocationModel center,
    double radius,
  ) async {
    final latitudeMin = center.latitude - radius;
    final latitudeMax = center.latitude + radius;
    final longitudeMin = center.longitude - radius;
    final longitudeMax = center.longitude + radius;

    final querySnapshot = await eventsCollection
        .where('latitude', isGreaterThanOrEqualTo: latitudeMin)
        .where('latitude', isLessThanOrEqualTo: latitudeMax)
        .where('longitude', isGreaterThanOrEqualTo: longitudeMin)
        .where('longitude', isLessThanOrEqualTo: longitudeMax)
        .get();

    List<EventModel> events = [];
    for (final eventSnapshot in querySnapshot.docs) {
      events.add(await _mapToEventModel(eventSnapshot));
    }
    return events;
  }

  static Future<void> deleteEvent(String eventId) async {
    return eventsCollection.doc(eventId).delete();
  }

  static Future<void> addUserToPendingParticipant(
    String userId,
    String eventId,
  ) async {
    DocumentReference userRef = usersCollection.doc();
    return eventsCollection.doc(eventId).update({
      'pendingParticipants': FieldValue.arrayUnion([userRef])
    });
  }

  static Future<void> removeUserFromPendingParticipants(
    String userId,
    String eventId,
  ) async {
    DocumentReference userRef = usersCollection.doc(userId);
    return eventsCollection.doc(eventId).update({
      'pendingParticipants': FieldValue.arrayRemove([userRef])
    });
  }

  static Future<void> addUserToParticipants(
    String userId,
    String eventId,
  ) async {
    DocumentReference userRef = usersCollection.doc(userId);
    return eventsCollection.doc(eventId).update({
      'participants': FieldValue.arrayUnion([userRef])
    });
  }

  static Future<void> removeUserFromParticipants(
    String userId,
    String eventId,
  ) async {
    DocumentReference userRef = usersCollection.doc(userId);
    return eventsCollection.doc(eventId).update({
      'participants': FieldValue.arrayRemove([userRef])
    });
  }

  static Future<void> moveUserFromPendingToParticipants(
    String userId,
    String eventId,
  ) async {
    removeUserFromPendingParticipants(userId, eventId);
    addUserToParticipants(userId, eventId);
  }

}
