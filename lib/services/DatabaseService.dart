import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/utils/activity_utils.dart';

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
      'activity': getActivityName(event.activity),
      //TODO 'location': event.location,
      'time': event.time,
      'owner': uid,
      'maxParticipants': event.unlimitedParticipants ? 0 : event.maxParticipants,
      'participants': [...event.participants, '/users/$uid']
    });
  }

  Stream<QuerySnapshot> getPastParticipatedEvents() {
    print(uid);
    return eventsCollection
        .where('participants', arrayContains: '/users/$uid')
        //.where('time', isLessThan: DateTime.now()) // TODO: only past events - this do not work
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

  Future<void> updateUsername(String newName) {
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
