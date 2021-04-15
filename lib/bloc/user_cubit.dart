import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/model/user_model.dart';

class UserCubit extends Cubit<UserModel> {
  UserCubit() : super(UserModel('Joe Doe', ''));


  void updatePicturePath(String newPicturePath) {
    final newUserModel = UserModel(state.name, newPicturePath);
    emit(newUserModel);
  }

  void updateUserName(String name) {
    final newUserModel = UserModel(name, state.profilePicture);
    emit(newUserModel);
  }
}