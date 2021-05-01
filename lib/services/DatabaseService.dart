import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sport_buddy/enum/activity_enum.dart';
import 'package:sport_buddy/model/event_model.dart';

class DatabaseService {
  final String uid;

  DatabaseService(this.uid);

  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('events');

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> addEvent(EventModel event) {
    return eventsCollection.add({
      'name': event.name,
      'description': event.description,
      'activity': ActivityConverter.toJSON(event.activity),
      //TODO 'location': event.location,
      'time': event.time,
      'owner': uid,
      'maxParticipants': event.unlimitedParticipants ? 0 : event.maxParticipants,
      'participants': [...event.participants, '/users/$uid']
    });
  }

  Stream<QuerySnapshot> getPastParticipatedEvents() {
    return eventsCollection
        .where('participants', arrayContains: uid)
        .where('time', isLessThan: DateTime.now())
        .orderBy('time', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserOwnEvents() {
    return eventsCollection.where('owner', isEqualTo: uid).snapshots();
  }

  Stream<DocumentSnapshot> getEvent(String eventId) {
    return eventsCollection.doc(eventId).snapshots();
  }

  void addParticipant(String participantId, String eventId) {
    DocumentReference user = usersCollection.doc(participantId);
    eventsCollection.doc(eventId).update({
      'participants': FieldValue.arrayUnion([user])
    });
  }

  void deleteParticipant(String participantId, String eventId) {
    DocumentReference user = usersCollection.doc(participantId);
    eventsCollection.doc(eventId).update({
      'participants': FieldValue.arrayRemove([user])
    });
  }
}
