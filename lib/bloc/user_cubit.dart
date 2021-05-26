import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/model/user_model.dart';
import 'package:sport_buddy/services/DatabaseService.dart';

class UserCubit extends Cubit<UserModel> {
  UserCubit() : super(UserModel('Joe Doe', '', ''));

  bool editUser = false;

  void changeEdit() {
    editUser = !editUser;
    emit(UserModel(state.name, state.profilePicture, state.userID));
  }

  void updatePicturePath(String newPicturePath) {
    final newUserModel = UserModel(state.name, newPicturePath, state.userID);
    emit(newUserModel);
  }

  void updateUserName(String name) {
    final newUserModel = UserModel(name, state.profilePicture, state.userID);
    DatabaseService().updateUsername(state.userID, name);
    emit(newUserModel);
  }

  void setUser(String uid) {
    final document = FirebaseFirestore.instance.collection('users').doc(uid);
    document.get().then((user) => {
        if (user.exists) {
          emit(UserModel(user.get('name'), state.profilePicture, uid))
        } else {
          //create user
          DatabaseService().createUser(FirebaseAuth.instance.currentUser.displayName)
        }
    });
  }

  String getUserID() {
    return state.userID;
  }

  Future<void> setPicture() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    final storageRef = storage.ref().child("user/profile/${getUserID()}");
    try {
      var downloadUrl = await storageRef.getDownloadURL();
      final newUserModel = UserModel(state.name, downloadUrl, state.userID);
      emit(newUserModel);
    } catch (e) {
      print("User do not have any picture");
    }
  }
}