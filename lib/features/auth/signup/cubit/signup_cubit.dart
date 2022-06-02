import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handover/core/enums.dart';
import 'package:handover/features/auth/auth/auth_bloc.dart';
import 'package:handover/repositories/auth_repository/auth_repository.dart';
import 'package:handover/repositories/user_data_repository/user_data_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({
    required this.authRepository,
    required this.userDataRepository,
    required this.authBloc,
  }) : super(SignupState());

  final AuthRepository authRepository;
  final UserDataRepository userDataRepository;
  final AuthBloc authBloc;

  void fullNameChanged(String value) {
    emit(state.copyWith(fullName: value.trim()));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value.trim()));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value));
  }

  void accountTypeChanged(AccountType value) {
    emit(state.copyWith(accountType: value));
  }

  Future signup() async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      // Sign up
      await authRepository.signUp(email: state.email, password: state.password);
      //user id:
      String userId = authRepository.getCurrentUser()!.uid;
      // Register user's data in database
      await userDataRepository.addNewUser(
        userData: UserData(
          id: userId,
          fullName: state.fullName,
          accountType: state.accountType,
        ),
      );
      // Register user's token
      await userDataRepository.registerUserToken(userId: userId);

      emit(state.copyWith(status: StateStatus.successful));

      authBloc.add(AuthSignUpRequested(authRepository.getCurrentUser()));
    } on AuthException catch (error) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: error.message,
      ));
    }
  }
}
