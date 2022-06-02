import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handover/core/enums.dart';
import 'package:handover/features/auth/auth/auth_bloc.dart';
import 'package:handover/repositories/auth_repository/auth_repository.dart';
import 'package:handover/repositories/user_data_repository/user_data_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required this.authRepository,
    required this.userDataRepository,
    required this.authBloc,
  }) : super(LoginState());

  final AuthRepository authRepository;
  final UserDataRepository userDataRepository;
  final AuthBloc authBloc;

  void emailChanged(String value) {
    emit(state.copyWith(email: value.trim()));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value));
  }

  Future login() async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      // Sign in
      await authRepository.signIn(email: state.email, password: state.password);
      // Register user's token
      await userDataRepository.registerUserToken(
          userId: authRepository.getCurrentUser()!.uid);

      emit(state.copyWith(status: StateStatus.successful));

      authBloc.add(AuthLogInRequested(authRepository.getCurrentUser()));
    } on AuthException catch (error) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: error.message,
      ));
    }
  }
}
