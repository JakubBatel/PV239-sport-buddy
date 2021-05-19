import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/model/event/auth_event.dart';
import 'package:sport_buddy/model/event/login_event.dart';
import 'package:sport_buddy/model/state/login_state.dart';
import 'package:sport_buddy/services/AuthenticationService.dart';

import 'auth_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc _authenticationBloc;
  final AuthService _authenticationService;

  LoginBloc(AuthBloc authenticationBloc, AuthService authenticationService)
      : assert(authenticationBloc != null),
        assert(authenticationService != null),
        _authenticationBloc = authenticationBloc,
        _authenticationService = authenticationService,
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginInWithEmailButtonPressed) {
      yield* _mapLoginWithEmailToState(event);
    }

    if (event is LoginWithGoogleButtonPressed) {
      yield* _mapLoginWithGoogleToState(event);
    }

    if (event is LoginWithFacebookButtonPressed) {
      yield* _mapLoginWithFacebookToState(event);
    }

    if (event is RegisterWithEmailButtonPressed) {
     yield*  _mapRegisterWithEmailToState(event);
    }
  }

  Stream<LoginState> _mapLoginWithEmailToState(
      LoginInWithEmailButtonPressed event) async* {
    yield LoginLoading();
    final result = await _authenticationService.signInWithEmailAndPassword(
        event.email, event.password);
    final user = _authenticationService.getCurrentUser();
    if (user != null) {
      _authenticationBloc.add(UserLoggedIn(user: user));
      yield LoginSuccess();
      yield LoginInitial();
    } else {
      yield LoginFailure(error: 'Firebase login error');
    }
  }

  Stream<LoginState> _mapLoginWithGoogleToState(
      LoginWithGoogleButtonPressed event) async* {
    yield LoginLoading();
    final result = await _authenticationService.signInWithGoogle();
    final user = _authenticationService.getCurrentUser();
    if (user != null) {
      _authenticationBloc.add(UserLoggedIn(user: user));
      yield LoginSuccess();
      yield LoginInitial();
    } else {
      yield LoginFailure(error: 'Firebase login error');
    }
  }

  Stream<LoginState> _mapRegisterWithEmailToState(
      RegisterWithEmailButtonPressed event) async* {
    yield LoginLoading();
    final result = await _authenticationService.registerWithEmailAndPassword(event.email, event.password);
    final user = _authenticationService.getCurrentUser();
    if (user != null) {
      _authenticationBloc.add(UserLoggedIn(user: user));
      yield LoginSuccess();
      yield LoginInitial();
    } else {
      yield LoginFailure(error: 'Firebase login error');
    }
  }
  Stream<LoginState> _mapLoginWithFacebookToState(
      LoginWithFacebookButtonPressed event) async* {
    yield LoginLoading();
    // TODO: IMPLEMENT!!!
  }
}
