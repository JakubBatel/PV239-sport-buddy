import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/model/user_model.dart';
import 'package:sport_buddy/utils/activity_utils.dart';

class DatabaseService {

  DatabaseService();

  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('events');

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<String> addEvent(EventModel event) async {
    final docRef = await eventsCollection.add({
      'name': event.name,
      'description': event.description,
      'activity': getActivityName(event.activity),
      //TODO 'location': event.location,
      'time': event.time,
      'owner': event.owner,
      'maxParticipants': event.unlimitedParticipants ? 0 : event.maxParticipants,
      'participants': [usersCollection.doc(event.owner)],
      'pendingParticipants': [],
    });
    return docRef.id;
  }

  Future<void> updateEvent(EventModel event) {
    return eventsCollection
      .doc(event.id)
      .update({
        'name': event.name,
        'description': event.description,
        'activity': getActivityName(event.activity),
        //TODO 'location': event.location,
        'time': event.time,
        'maxParticipants': event.unlimitedParticipants ? 0 : event.maxParticipants,
      });
  }

  void deleteEvent(String eventId) {
    eventsCollection.doc(eventId).delete();
  }

  Stream<QuerySnapshot> getPastParticipatedEvents(String uid) {
    final now = Timestamp.fromDate(DateTime.now());
    DocumentReference userRef = usersCollection.doc(uid);
    print(uid);
    return eventsCollection
        .where('participants', arrayContains: userRef)
        .where('time', isLessThan: now)
        .orderBy('time', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getUpcomingEvents(String uid) {
    return eventsCollection
        // .where('participants', arrayContains: '/users/$uid')
        // .where('time', isGreaterThan: DateTime.now())
        .orderBy('time', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserOwnEvents(String uid) {
    return eventsCollection.where('owner', isEqualTo: uid).snapshots();
  }

  Future<EventModel> fetchEvent(String eventId) async {
    // TODO: this does not work
    final id = eventsCollection.doc(eventId).id;
    final doc = await eventsCollection.doc(eventId).get();
    return EventModel(
      id: id,
      name: doc['name'],
      description: doc['description'],
      activity: getActivityFromString(doc['activity']),
      time: DateTime.parse(doc['time'].toDate().toString()),
      owner: doc['owner'],
      maxParticipants: doc['maxParticipants'],
      unlimitedParticipants: doc['maxParticipants'] == 0,
      participants: doc['participants'],
      pendingParticipants: doc['pendingParticipants'],
    );
  }

  void addParticipantToPending(String participantId, String eventId) {
    DocumentReference user = usersCollection.doc(participantId);
    eventsCollection.doc(eventId).update({
      'pendingParticipants': FieldValue.arrayUnion([user])
    });
  }

  void addParticipant(String participantId, String eventId) {
    DocumentReference user = usersCollection.doc(participantId);
    eventsCollection.doc(eventId).update({
      'participants': FieldValue.arrayUnion([user])
    });
    eventsCollection.doc(eventId).update({
      'pendingParticipants': FieldValue.arrayRemove([user])
    });
  }

  void deleteParticipant(String participantId, String eventId) {
    DocumentReference user = usersCollection.doc(participantId);
    eventsCollection.doc(eventId).update({
      'participants': FieldValue.arrayRemove([user])
    });
  }

  void deletePendingParticipant(String participantId, String eventId) {
    DocumentReference user = usersCollection.doc(participantId);
    eventsCollection.doc(eventId).update({
      'pendingParticipants': FieldValue.arrayRemove([user])
    });
  }

  Future<void> updateUser(UserModel user) {
    return usersCollection.doc(user.userID).update({
      'name' : user.name,
      'pictureUrl': user.profilePicture
    });
  }

  Future<void> createUser(UserModel user) {
    return usersCollection.add({
      'id': user.userID,
      'name' : user.name,
      'pictureUrl': user.profilePicture
    });
  }
}
