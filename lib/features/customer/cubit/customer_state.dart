part of 'customer_cubit.dart';

class CustomerState extends Equatable {
  const CustomerState({
    this.currentOrder,
    this.stateStatus = StateStatus.initial,
    this.errorMessage = '',
  });

  final Order? currentOrder;
  final StateStatus stateStatus;
  final String errorMessage;

  @override
  List<Object?> get props => [currentOrder, stateStatus, errorMessage];

  CustomerState copyWith({
    Order? currentOrder,
    StateStatus? stateStatus,
    String? errorMessage,
  }) {
    return CustomerState(
      currentOrder: currentOrder ?? this.currentOrder,
      stateStatus: stateStatus ?? this.stateStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
