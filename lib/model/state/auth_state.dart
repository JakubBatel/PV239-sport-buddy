import 'package:equatable/equatable.dart';
import 'package:sport_buddy/model/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInit extends AuthState {}

class AuthLoading extends AuthState {}

class NotAuthenticated extends AuthState {}

class Authenticated extends AuthState {
  final UserModel user;

  Authenticated({this.user});

  @override
  List<Object> get props => [user];
}

class AuthError extends AuthState {
  final String message;

  AuthError({this.message});

  @override
  List<Object> get props => [message];
}
