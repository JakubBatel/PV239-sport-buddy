import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/model/event/auth_event.dart';
import 'package:sport_buddy/model/state/auth_state.dart';
import 'package:sport_buddy/services/AuthenticationService.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authenticationService;

  AuthBloc(AuthService authenticationService)
      : assert(authenticationService != null),
        _authenticationService = authenticationService,
        super(AuthInit());

  @override
  Stream<AuthState> mapEventToState(
      AuthEvent event) async* {
    if (event is AppLoaded) {
      yield* _mapAppLoadedToState(event);
    }

    if (event is UserLoggedIn) {
      yield* _mapUserLoggedInToState(event);
    }

    if (event is UserLoggedOut) {
      yield* _mapUserLoggedOutToState(event);
    }
  }

  Stream<AuthState> _mapAppLoadedToState(AppLoaded event) async* {
    yield AuthLoading();
    final currentUser = await _authenticationService.getCurrentUser();

    if (currentUser != null) {
      yield Authenticated(user: currentUser);
    } else {
      yield NotAuthenticated();
    }
  }

  Stream<AuthState> _mapUserLoggedInToState(
      UserLoggedIn event) async* {
    yield Authenticated(user: event.user);
  }

  Stream<AuthState> _mapUserLoggedOutToState(
      UserLoggedOut event) async* {
    await _authenticationService.signOut();
    yield NotAuthenticated();
  }
}
