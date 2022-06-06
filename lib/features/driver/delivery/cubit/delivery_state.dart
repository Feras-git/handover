part of 'delivery_cubit.dart';

class DeliveryState extends Equatable {
  const DeliveryState({
    required this.driverLiveLocation,
    this.finishedDelivery = false,
  });

  final Position driverLiveLocation;
  final bool finishedDelivery;

  @override
  List<Object?> get props => [
        driverLiveLocation,
        finishedDelivery,
      ];

  DeliveryState copyWith({
    Position? driverLiveLocation,
    bool? finishedDelivery,
  }) {
    return DeliveryState(
      driverLiveLocation: driverLiveLocation ?? this.driverLiveLocation,
      finishedDelivery: finishedDelivery ?? this.finishedDelivery,
    );
  }
}
