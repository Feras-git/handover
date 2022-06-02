part of 'user_data_cubit.dart';

class UserDataState extends Equatable {
  const UserDataState({
    this.userData,
    this.stateStatus = StateStatus.initial,
  });

  final UserData? userData;
  final StateStatus stateStatus;

  @override
  List<Object?> get props => [userData, stateStatus];

  UserDataState copyWith({
    UserData? userData,
    StateStatus? stateStatus,
  }) {
    return UserDataState(
      userData: userData ?? this.userData,
      stateStatus: stateStatus ?? this.stateStatus,
    );
  }
}
