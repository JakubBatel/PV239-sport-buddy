import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/model/user_model.dart';
import 'package:sport_buddy/services/user_service.dart';

class UserCubit extends Cubit<UserModel> {
  UserCubit() : super(UserModel(id: '', name: '', profilePicture: ''));

  bool editUser = false;

  void changeEdit() {
    editUser = !editUser;
    emit(
      UserModel(
        id: state.id,
        name: state.name,
        profilePicture: state.profilePicture,
      ),
    );
  }

  Future<void> updatePicturePath(String newPicturePath) async {
    await UserService.updateProfilePicture(state.id, newPicturePath);
    emit(
      UserModel(
        id: state.id,
        name: state.name,
        profilePicture: newPicturePath,
      ),
    );
  }

  Future<void> updateUserName(String name) async {
    await UserService.updateUsername(state.id, name);
    emit(
      UserModel(
        id: state.id,
        name: name,
        profilePicture: state.profilePicture,
      ),
    );
  }

  void saveUserToDB(UserModel user) {
    final currentUserId = FirebaseAuth.instance.currentUser.uid;
    final document =
    FirebaseFirestore.instance.collection('users').doc(currentUserId);
    document.get().then(
          (dbUser) =>
      {
        if (dbUser.exists) {
          emit(UserModel(id: currentUserId, name: user.name, profilePicture: dbUser.data()['profilePicture']))
          }
        else
          {
            addUser(currentUserId, user.name)
          }
      },
    );
  }

  void addUser(userId, name) {
    final userModel = UserModel(
      id: userId,
      name: name,
      profilePicture: '',
    );
    UserService.addUser(userModel);
    emit(userModel);
  }

  void setPictureUrl(currentUserId, name) async {

    final storage = FirebaseStorage.instance;
    var picturePath = '';

    try {
      final storageRef = storage.ref().child('user/profile/$currentUserId');
      picturePath = await storageRef.getDownloadURL();
    } catch (e) {

    }

    emit(UserModel(
        id: currentUserId,
        profilePicture: picturePath,
        name: name
    ));
  }
}