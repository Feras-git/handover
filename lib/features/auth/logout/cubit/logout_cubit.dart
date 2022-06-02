import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handover/features/auth/auth/auth_bloc.dart';
import 'package:handover/repositories/auth_repository/auth_repository.dart';
import 'package:handover/repositories/user_data_repository/user_data_repository.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit({
    required this.authRepository,
    required this.authBloc,
    required this.userDataRepository,
  }) : super(const LogoutState());

  final AuthRepository authRepository;
  final AuthBloc authBloc;
  final UserDataRepository userDataRepository;

  Future<void> logout() async {
    //Unregister fcmToken
    await userDataRepository
        .unRegisterUserToken(userId: authBloc.state.user!.uid)
        .onError((error, _) {
      print(error.toString());
    });
    // logout
    await authRepository.signOut();
    authBloc.add(AuthLogoutRequested());
  }
}
