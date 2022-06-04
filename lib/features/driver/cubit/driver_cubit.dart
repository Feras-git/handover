import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:handover/core/enums.dart';
import 'package:handover/features/auth/user_data/user_data_cubit.dart';
import 'package:handover/repositories/orders_repository/orders_repository.dart';

part 'driver_state.dart';

class DriverCubit extends Cubit<DriverState> {
  DriverCubit({
    required this.userDataCubit,
    required this.ordersRepository,
  }) : super(DriverState()) {
    _initCurrentOrder();
    _initDriverLocation();
  }

  final UserDataCubit userDataCubit;
  final OrdersRepository ordersRepository;

  Future _initCurrentOrder() async {
    emit(state.copyWith(
      stateStatus: StateStatus.loading,
    ));
    try {
      Order? currentOrder = await ordersRepository.getCurrentOrder(
          userId: userDataCubit.state.userData!.id, isCustomer: false);
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

  Future _initDriverLocation() async {
    try {
      var location = await Geolocator.getCurrentPosition();
      emit(state.copyWith(
        driverLocation: location,
      ));
    } catch (error) {
      emit(state.copyWith(
        stateStatus: StateStatus.failure,
        errorMessage: 'Failed to fetch driver\'s location!',
      ));
    }
  }

  Stream<List<Order>> ordersStream() {
    return ordersRepository.ordersWaitingForPickUpStream();
  }

  /// Distance from driver's current location to order's customer destination
  double? distanceToOrderDestination({
    required Order order,
    required DistanceUnit unit,
  }) {
    if (state.driverLocation != null) {
      double distance = Geolocator.distanceBetween(
        state.driverLocation!.latitude,
        state.driverLocation!.longitude,
        order.customerLocation.latitude,
        order.customerLocation.longitude,
      );

      return unit == DistanceUnit.meters ? distance : distance / 1000;
    }
    return null;
  }
}
