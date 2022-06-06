import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handover/core/enums.dart';
import 'package:handover/features/customer/customer_home/cubit/customer_cubit.dart';
import 'package:handover/repositories/orders_repository/orders_repository.dart';

part 'tracking_state.dart';

class TrackingCubit extends Cubit<TrackingState> {
  TrackingCubit({
    required Order currentOrder,
    required this.ordersRepository,
    required this.customerCubit,
  }) : super(TrackingState(
          currentOrder: currentOrder,
        )) {
    _orderUpdatesListener();
  }

  final OrdersRepository ordersRepository;
  final CustomerCubit customerCubit;

  _orderUpdatesListener() {
    ordersRepository
        .orderStream(orderId: state.currentOrder.orderId!)
        .listen((updatedOrder) {
      emit(state.copyWith(
        currentOrder: updatedOrder,
      ));

      // condition of end ....
    });
  }

  void serviceRatingChanged(double value) {
    emit(state.copyWith(
      serviceRating: value,
    ));
  }

  Future submit() async {
    emit(state.copyWith(submittionStatus: StateStatus.loading));
    try {
      Order submittedOrder = await ordersRepository.submitSummary(
          order: state.currentOrder, rating: state.serviceRating);

      customerCubit.orderIsRecieved(recievedOrder: submittedOrder);

      emit(state.copyWith(
        currentOrder: submittedOrder,
        submittionStatus: StateStatus.successful,
      ));
    } catch (error) {
      emit(state.copyWith(
        submittionStatus: StateStatus.failure,
        errorMessage:
            'Failed to submit! Please check your connection and try again.',
      ));
    }
  }
}
