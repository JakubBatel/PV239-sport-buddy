import 'package:equatable/equatable.dart';
import 'package:sport_buddy/model/user_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppLoaded extends AuthEvent {}

class UserLoggedIn extends AuthEvent {
  final UserModel user;

  UserLoggedIn({this.user});

  @override
  List<Object> get props => [user];
}

class UserLoggedOut extends AuthEvent {}