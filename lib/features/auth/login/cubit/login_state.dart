part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.status = StateStatus.initial,
    this.errorMessage = '',
  });

  final String email;
  final String password;
  final String errorMessage;
  final StateStatus status;

  @override
  List<Object> get props => [email, password, errorMessage, status];

  LoginState copyWith({
    String? email,
    String? password,
    String? errorMessage,
    StateStatus? status,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}
