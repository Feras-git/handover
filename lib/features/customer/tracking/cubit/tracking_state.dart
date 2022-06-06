part of 'tracking_cubit.dart';

class TrackingState extends Equatable {
  const TrackingState({
    required this.currentOrder,
    this.serviceRating = 3,
    this.submittionStatus = StateStatus.initial,
    this.errorMessage = '',
  });

  final Order currentOrder;
  final double serviceRating;
  final StateStatus submittionStatus;
  final String errorMessage;

  @override
  List<Object> get props =>
      [currentOrder, serviceRating, submittionStatus, errorMessage];

  TrackingState copyWith({
    Order? currentOrder,
    double? serviceRating,
    StateStatus? submittionStatus,
    String? errorMessage,
  }) {
    return TrackingState(
      currentOrder: currentOrder ?? this.currentOrder,
      serviceRating: serviceRating ?? this.serviceRating,
      submittionStatus: submittionStatus ?? this.submittionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
