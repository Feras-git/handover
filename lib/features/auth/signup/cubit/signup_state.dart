part of 'signup_cubit.dart';

class SignupState extends Equatable {
  const SignupState({
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.accountType = AccountType.customer,
    this.status = StateStatus.initial,
    this.errorMessage = '',
  });

  final String fullName;
  final String email;
  final String password;
  final AccountType accountType;
  final String errorMessage;
  final StateStatus status;

  @override
  List<Object> get props {
    return [
      fullName,
      email,
      password,
      accountType,
      errorMessage,
      status,
    ];
  }

  SignupState copyWith({
    String? fullName,
    String? email,
    String? password,
    AccountType? accountType,
    String? errorMessage,
    StateStatus? status,
  }) {
    return SignupState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      accountType: accountType ?? this.accountType,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}
