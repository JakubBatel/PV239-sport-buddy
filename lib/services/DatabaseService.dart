import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/utils/activity_utils.dart';

class DatabaseService {

  DatabaseService();

  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('events');

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> addEvent(EventModel event) {
    return eventsCollection.add({
      'name': event.name,
      'description': event.description,
      'activity': getActivityName(event.activity),
      //TODO 'location': event.location,
      'time': event.time,
      'owner': event.owner, // TODO: posilat referenci???
      'maxParticipants': event.unlimitedParticipants ? 0 : event.maxParticipants,
      'participants': [],
      'pendingParticipants': [],
    });
  }

  void deleteEvent(String eventId) {
    eventsCollection.doc(eventId).delete();
  }


  Stream<QuerySnapshot> getPastParticipatedEvents(String uid) {
    print(uid);
    return eventsCollection
        .where('participants', arrayContains: '/users/$uid')
        //.where('time', isLessThan: DateTime.now()) // TODO: only past events - this do not work
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
      participants: [],
      pendingParticipants: [],
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
  



  Future<void> updateUsername(String uid, String newName) {
    return usersCollection.doc(uid).update({
        'name' : newName
    });
  }


  Future<void> createUser(name) {
    return usersCollection.add({
        'name' : name
    });
  }

}
