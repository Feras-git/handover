part of 'driver_cubit.dart';

class DriverState extends Equatable {
  const DriverState({
    this.currentOrder,
    this.driverLocation,
    this.stateStatus = StateStatus.initial,
    this.errorMessage = '',
  });

  final Order? currentOrder;
  final Position? driverLocation;
  final StateStatus stateStatus;
  final String errorMessage;

  @override
  List<Object?> get props =>
      [currentOrder, driverLocation, stateStatus, errorMessage];

  DriverState copyWith({
    Order? currentOrder,
    Position? driverLocation,
    StateStatus? stateStatus,
    String? errorMessage,
  }) {
    return DriverState(
      currentOrder: currentOrder ?? this.currentOrder,
      driverLocation: driverLocation ?? this.driverLocation,
      stateStatus: stateStatus ?? this.stateStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
