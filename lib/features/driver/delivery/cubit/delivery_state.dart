part of 'delivery_cubit.dart';

class DeliveryState extends Equatable {
  const DeliveryState({
    required this.driverLiveLocation,
    this.finishedDelivery = false,
    this.status = StateStatus.initial,
    this.errorMessage = '',
  });

  final Position driverLiveLocation;
  final bool finishedDelivery;
  final StateStatus status;
  final String errorMessage;

  @override
  List<Object?> get props => [
        driverLiveLocation,
        finishedDelivery,
        status,
        errorMessage,
      ];

  DeliveryState copyWith({
    Position? driverLiveLocation,
    bool? finishedDelivery,
    StateStatus? status,
    String? errorMessage,
  }) {
    return DeliveryState(
      driverLiveLocation: driverLiveLocation ?? this.driverLiveLocation,
      finishedDelivery: finishedDelivery ?? this.finishedDelivery,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
