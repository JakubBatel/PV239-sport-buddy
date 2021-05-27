import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInWithEmailButtonPressed extends LoginEvent {
  final String email;
  final String password;

  LoginInWithEmailButtonPressed({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}

class LoginWithGoogleButtonPressed extends LoginEvent {}

class LoginWithFacebookButtonPressed extends LoginEvent {}

class RegisterWithEmailButtonPressed extends LoginEvent {
  final String email;
  final String password;

  RegisterWithEmailButtonPressed({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}
