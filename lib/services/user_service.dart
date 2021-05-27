import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sport_buddy/model/user_model.dart';

class UserService {
  static final usersCollection = FirebaseFirestore.instance.collection('users');

  static final eventsCollection =
      FirebaseFirestore.instance.collection('events');

  static Future<UserModel> addUser(UserModel user) async {
    /*final docRef = await usersCollection.add(
      {
        'name': user.name,
        'profilePicture': user.profilePicture,
      },
    );*/
    await usersCollection.doc(user.id).set(
      {
        'name': user.name,
        'profilePicture': user.profilePicture,
      },
    );
    return UserModel(
      id: user.id,
      name: user.name,
      profilePicture: user.profilePicture,
    );
  }

  static Future<UserModel> fetchUser(String userId) async {
    final doc = await usersCollection.doc(userId).get();
    if (!doc.exists) {
      return null;
    }
    return UserModel(
      id: doc.id,
      name: doc.get('name'),
      profilePicture: doc.get('profilePicture'),
    );
  }

  static Future<void> updateUsername(String userId, String newName) async {
    return usersCollection.doc(userId).update(
      {
        'name': newName,
      },
    );
  }

  static Future<void> updateProfilePicture(
    String userId,
    String profilePicture,
  ) async {
    return usersCollection.doc(userId).update(
      {
        'profilePicture': profilePicture,
      },
    );
  }

  static Future<void> removeUser(String userId) async {
    return usersCollection.doc(userId).delete();
  }
}
