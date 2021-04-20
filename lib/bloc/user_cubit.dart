import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/model/user_model.dart';

class UserCubit extends Cubit<UserModel> {
  UserCubit() : super(UserModel('Joe Doe', '', ""));

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
    emit(newUserModel);
  }

  void setUserID(String uid) {
    final newUserModel = UserModel(state.name, state.profilePicture, uid);
    emit(newUserModel);
  }

  String getUserID() {
    return state.userID;
  }

  Future<void> setPicture() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    final storageRef = storage.ref().child("user/profile/${getUserID()}");
    var downloadUrl = await storageRef.getDownloadURL();
    print("cubit path:" + downloadUrl);
    final newUserModel = UserModel(state.name, downloadUrl, state.userID);
    emit(newUserModel);
  }

}