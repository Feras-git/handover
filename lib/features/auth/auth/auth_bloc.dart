import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handover/repositories/auth_repository/auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.authRepository,
  }) : super(const AuthState.unknown());

  final AuthRepository authRepository;

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    }
    if (event is AuthLogInRequested) {
      yield* _mapAuthLogInRequestedToState(user: event.user);
    }
    if (event is AuthSignUpRequested) {
      yield* _mapAuthSignUpRequestedToState(user: event.user);
    }
    if (event is AuthLogoutRequested) {
      yield* _mapAuthLogOutRequestedToState();
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    try {
      final bool isSignedIn = authRepository.isSignIn();
      if (!isSignedIn) {
        yield AuthState.unauthenticated();
      } else {
        User user = authRepository.getCurrentUser()!;
        yield AuthState.authenticated(user);
      }
    } catch (error) {
      print('ERROR IN _mapAppStartedToState: $error');
      yield AuthState.unauthenticated();
    }
  }

  Stream<AuthState> _mapAuthLogInRequestedToState({User? user}) async* {
    if (user != null) {
      yield AuthState.authenticated(user);
    } else {
      yield AuthState.unauthenticated();
    }
  }

  Stream<AuthState> _mapAuthSignUpRequestedToState({User? user}) async* {
    if (user != null) {
      yield AuthState.authenticated(user);
    } else {
      yield AuthState.unauthenticated();
    }
  }

  Stream<AuthState> _mapAuthLogOutRequestedToState() async* {
    yield AuthState.unauthenticated();
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
