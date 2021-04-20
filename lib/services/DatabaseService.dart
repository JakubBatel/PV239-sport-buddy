import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sport_buddy/model/event_model.dart';

class DatabaseService {

  final String uid;

  DatabaseService(this.uid);

  final CollectionReference eventsCollection =
        FirebaseFirestore.instance.collection('events');

  final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');


  Future<void> addEvent(EventModel event) {
      return eventsCollection.add({
          'name': event.name,
          'description': event.description,
          //TODO 'activity': event.activity,
          //TODO 'location': event.location,
          'time': event.time,
          'owner': event.owner,
          'maxParticipants': event.maxParticipants,
          'participants': event.participants
      });

  }

    Stream<QuerySnapshot> returnPastParticipatedEvents() {
      CollectionReference events = FirebaseFirestore.instance.collection('events');
      return events.where('participants', arrayContains: uid)
          .where('time', isLessThan: DateTime.now())
          .orderBy('time', descending: true)
          .snapshots();
    }

    Stream<QuerySnapshot> returnUserOwnEvents() {
      CollectionReference events = FirebaseFirestore.instance.collection('events');

      return events.where('owner', isEqualTo: uid).snapshots();
    }


  }


