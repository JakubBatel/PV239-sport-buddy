import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/model/user_model.dart';

class UserCubit extends Cubit<User> {
  UserCubit() : super(User('Joe Doe', ''));


  void updatePicturePath(String newPicturePath) {
    final newUserModel = User(state.name, newPicturePath);
    emit(newUserModel);
  }


}