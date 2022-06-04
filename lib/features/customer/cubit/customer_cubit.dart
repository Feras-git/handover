import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:handover/core/enums.dart';
import 'package:handover/core/models/product.dart';
import 'package:handover/features/auth/user_data/user_data_cubit.dart';
import 'package:handover/repositories/orders_repository/orders_repository.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit({
    required this.userDataCubit,
    required this.ordersRepository,
  }) : super(CustomerState()) {
    _initCurrentOrder();
  }

  final UserDataCubit userDataCubit;
  final OrdersRepository ordersRepository;

  Future _initCurrentOrder() async {
    emit(state.copyWith(
      stateStatus: StateStatus.loading,
    ));
    try {
      Order? currentOrder = await ordersRepository.getCurrentOrder(
          userId: userDataCubit.state.userData!.id, isCustomer: true);
      emit(state.copyWith(
        currentOrder: currentOrder,
        stateStatus: StateStatus.successful,
      ));
    } catch (error) {
      print(error);
      emit(state.copyWith(
        stateStatus: StateStatus.failure,
        errorMessage: 'Failed to fetch current order!',
      ));
    }
  }

  /// Should deal with total price but for testing the value 30 is passed as default..
  Future addNewOrder({
    required Product product,
  }) async {
    emit(state.copyWith(stateStatus: StateStatus.loading));
    try {
      Order newOrder = await ordersRepository.addNewOrder(
        order: Order(
          productName: product.name,
          totalPrice: product.price,
          customerId: userDataCubit.state.userData!.id,
          customerLocation: await Geolocator.getCurrentPosition()
              .then((value) => GeoPoint(value.latitude, value.longitude)),
          orderTime: DateTime.now(),
        ),
      );

      emit(state.copyWith(
        currentOrder: newOrder,
        stateStatus: StateStatus.successful,
      ));
    } catch (error) {
      print(error);
      emit(state.copyWith(
        stateStatus: StateStatus.failure,
        errorMessage: 'Failed to add new order!',
      ));
    }
  }
}
