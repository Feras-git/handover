part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLogInRequested extends AuthEvent {
  final User? user;

  AuthLogInRequested(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthSignUpRequested extends AuthEvent {
  final User? user;

  AuthSignUpRequested(this.user);

  @override
  List<Object?> get props => [user];
}

class AppStarted extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}
