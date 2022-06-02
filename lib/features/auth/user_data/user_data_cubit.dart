import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handover/core/enums.dart';
import 'package:handover/features/auth/auth/auth_bloc.dart';
import 'package:handover/repositories/user_data_repository/user_data_repository.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  UserDataCubit({
    required this.userDataRepository,
    required this.authBloc,
  }) : super(UserDataState());

  final UserDataRepository userDataRepository;
  final AuthBloc authBloc;

  Future loadData() async {
    try {
      if (authBloc.state.status == AuthStatus.authenticated) {
        emit(state.copyWith(stateStatus: StateStatus.loading));
        UserData userData = await userDataRepository.getUserData(
            userId: authBloc.state.user!.uid);
        emit(state.copyWith(
            userData: userData, stateStatus: StateStatus.successful));
      }
    } catch (error) {
      print('error');
      //TODO deal with failure
      emit(state.copyWith(stateStatus: StateStatus.failure));
    }
  }
}
