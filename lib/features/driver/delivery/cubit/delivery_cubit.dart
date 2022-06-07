import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:handover/config/push_notifications_manager.dart';
import 'package:handover/features/driver/driver_home/cubit/driver_cubit.dart';
import 'package:handover/repositories/orders_repository/orders_repository.dart';
import 'package:handover/repositories/user_data_repository/src/user_data_repository.dart';

part 'delivery_state.dart';

class DeliveryCubit extends Cubit<DeliveryState> {
  DeliveryCubit({
    required this.ordersRepository,
    required this.driverCubit,
    required this.userDataRepository,
  }) : super(DeliveryState(
          driverLiveLocation: driverCubit.state.driverLocation!,
        )) {
    _locationListener();
  }

  final OrdersRepository ordersRepository;
  final DriverCubit driverCubit;
  final UserDataRepository userDataRepository;

  StreamSubscription? _locationStreamSub;

  /// Listen to driver's location and update changes in database
  _locationListener() {
    _locationStreamSub = Geolocator.getPositionStream().listen((pos) {
      // update location in state
      emit(state.copyWith(
        driverLiveLocation: pos,
      ));
      // update location in database
      ordersRepository
          .updateDriverLocation(
            order: driverCubit.state.currentOrder!,
            driverLocation: GeoPoint(
              pos.latitude,
              pos.longitude,
            ),
          )
          .then((value) => driverCubit.setCurrentOrder(updatedOrder: value));
      // Actions of way to pick up destination
      if (!driverCubit.state.currentOrder!.isPickedUp) {
        _wayToPickupActions();
      }
      // Actions of way to customer
      else if (!driverCubit.state.currentOrder!.isDelivered) {
        _wayToCustomerActions();
      }
      // The order is delivered
      else {
        // Stop the listener
        _locationStreamSub?.cancel();
        emit(state.copyWith(
          finishedDelivery: true,
        ));
      }
    });
  }

  Future _wayToPickupActions() async {
    // meters
    double distanceToPickUp = Geolocator.distanceBetween(
      state.driverLiveLocation.latitude,
      state.driverLiveLocation.longitude,
      driverCubit.state.currentOrder!.pickUpLocation.latitude,
      driverCubit.state.currentOrder!.pickUpLocation.longitude,
    );

    Order currentOrder = driverCubit.state.currentOrder!;

    if (!currentOrder.isNearToPickUp) {
      // Driver near to pick up
      if (distanceToPickUp <= 5000) {
        // Update in database
        Order updatedOrder =
            await ordersRepository.nearToPickUp(order: currentOrder);
        // Update locally
        driverCubit.setCurrentOrder(updatedOrder: updatedOrder);
        //! Send notification (driver near to pick up)
        _sendNotificationToCustomer(
          title: 'Near to pick up area',
          body:
              'The driver is near to pick up area and will carry your package very soon.',
        );
      }
    } else if (!currentOrder.isPickedUp) {
      // Driver arrived pick up
      if (distanceToPickUp <= 100) {
        // Update in database
        Order updatedOrder =
            await ordersRepository.pickUpOrder(order: currentOrder);
        // Update locally
        driverCubit.setCurrentOrder(updatedOrder: updatedOrder);
        //! Send notification (driver arrived pick up)
        _sendNotificationToCustomer(
          title: 'Arrived the pick up area',
          body:
              'The driver arrived the pick up area and is picking your package.',
        );
      }
    }
  }

  Future _wayToCustomerActions() async {
    // meters
    double distanceToCustomer = Geolocator.distanceBetween(
      state.driverLiveLocation.latitude,
      state.driverLiveLocation.longitude,
      driverCubit.state.currentOrder!.customerLocation.latitude,
      driverCubit.state.currentOrder!.customerLocation.longitude,
    );

    Order currentOrder = driverCubit.state.currentOrder!;

    if (!currentOrder.isNearToCustomer) {
      // Driver near to customer
      if (distanceToCustomer <= 5000) {
        // Update in database
        Order updatedOrder =
            await ordersRepository.nearToCustomer(order: currentOrder);
        // Update locally
        driverCubit.setCurrentOrder(updatedOrder: updatedOrder);
        //! Send notification (driver near to customer)
        _sendNotificationToCustomer(
          title: 'Near to your destination',
          body:
              'The driver is near to your destination and will arrive with the package very soon.',
        );
      }
    } else if (!currentOrder.isDelivered) {
      // Driver arrived to customer
      if (distanceToCustomer <= 100) {
        // Update in database
        Order updatedOrder =
            await ordersRepository.deliveredOrder(order: currentOrder);
        // Update locally
        driverCubit.setCurrentOrder(updatedOrder: updatedOrder);
        //! Send notification (driver arrived to customer)
        _sendNotificationToCustomer(
          title: 'Arrived to your destination',
          body: 'The driver arrived to your destination.',
        );
      }
    }
  }

  _sendNotificationToCustomer({
    required String title,
    required String body,
  }) {
    userDataRepository
        .getUserTokens(userId: driverCubit.state.currentOrder!.customerId)
        .then((tokens) {
      PushNotificationsManager.sendNotification(
        recieverTokens: tokens,
        title: title,
        body: body,
      );
    });
  }

  @override
  Future<void> close() async {
    await _locationStreamSub?.cancel();
    return super.close();
  }
}
