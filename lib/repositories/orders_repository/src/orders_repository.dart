import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handover/core/enums.dart';
import 'package:handover/repositories/orders_repository/src/models/models.dart';

class OrdersRepository {
  final CollectionReference<Map<String, dynamic>> _ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  ///- Add new order (when customer order new package) to database.
  ///
  ///- It returns a copy of the order carrying the [orderId]
  Future<Order> addNewOrder({required Order order}) async {
    var doc = await _ordersCollection.add(order.toJson());
    return order.copyWith(orderId: doc.id);
  }

  /// Get order by order's id.
  Future<Order> getOrder({required String orderId}) async {
    return await _ordersCollection
        .doc(orderId)
        .get()
        .then((doc) => Order.fromJson(doc.id, doc.data() as Map));
  }

  /// Tracking changes of order document
  Stream<Order> orderStream({required String orderId}) {
    return _ordersCollection.doc(orderId).snapshots().map((doc) {
      return Order.fromJson(orderId, doc.data()!);
    }).distinct();
  }

  /// The customer recieved the package successfully.
  ///
  /// Submit summary providing [rating] of service.
  ///
  /// The function updates necessary data in database.
  ///
  /// Returns the updated order.
  Future<Order> submitSummary({
    required Order order,
    required double rating,
  }) async {
    Order updatedOrder = order.copyWith(
      rating: rating,
      isReceived: true,
    );

    await _ordersCollection.doc(order.orderId).update(updatedOrder.toJson());

    return updatedOrder;
  }

  /// Live tracking of driver's location for an order.
  Stream<GeoPoint> driverLocationStream({required String orderId}) {
    return _ordersCollection
        .doc(orderId)
        .snapshots()
        .map((snap) => snap['driverLocation'] as GeoPoint)
        .distinct();
  }

  /// Update driver's location in database
  ///
  /// Returns the updated order
  Future<Order> updateDriverLocation({
    required Order order,
    required GeoPoint driverLocation,
  }) async {
    await _ordersCollection.doc(order.orderId).update({
      'driverLocation': driverLocation,
    });

    return order.copyWith(
      driverLocation: driverLocation,
    );
  }

  /// List of orders that are waiting for driver to serve
  Stream<List<Order>> pendingOrdersStream() {
    var query = _ordersCollection.where('isPending', isEqualTo: true);

    return query.snapshots().map((snap) {
      List<Order> result = snap.docs.map((doc) {
        return Order.fromJson(doc.id, doc.data());
      }).toList();

      return result;
    });
  }

  /// A driver get responsibility of an order.
  ///
  /// The function updates order's necessary data in database.
  ///
  /// returns the updated order.
  Future<Order> serveOrder({
    required driverId,
    required GeoPoint driverLocation,
    required Order order,
  }) async {
    var servedOrder = order.copyWith(
      driverId: driverId,
      isPending: false,
      driverLocation: driverLocation,
      startTime: DateTime.now(),
      orderStatus: OrderStatus.onTheWay,
    );
    await _ordersCollection.doc(order.orderId).update(servedOrder.toJson());

    return servedOrder;
  }

  /// A driver reached near to the pick up destination.
  ///
  /// The function updates order's necessary data in database.
  ///
  /// returns the updated order.
  Future<Order> nearToPickUp({required Order order}) async {
    var nearOrder = order.copyWith(
      isNearToPickUp: true,
    );

    await _ordersCollection.doc(order.orderId).update(nearOrder.toJson());

    return nearOrder;
  }

  /// A driver arrived pickup destination and will pick up the order.
  ///
  /// The function updates order's necessary data in database.
  ///
  /// returns the updated order.
  Future<Order> pickUpOrder({required Order order}) async {
    var pickedUpOrder = order.copyWith(
      pickUpTime: DateTime.now(),
      isPickedUp: true,
      orderStatus: OrderStatus.pickedUpDelivery,
    );

    await _ordersCollection.doc(order.orderId).update(pickedUpOrder.toJson());

    return pickedUpOrder;
  }

  /// A driver reached near to the destination of the customer.
  ///
  /// The function updates order's necessary data in database.
  ///
  /// returns the updated order.
  Future<Order> nearToCustomer({required Order order}) async {
    var nearOrder = order.copyWith(
      isNearToCustomer: true,
      orderStatus: OrderStatus.nearDeliveryDestination,
    );

    await _ordersCollection.doc(order.orderId).update(nearOrder.toJson());

    return nearOrder;
  }

  /// A driver delivered the order to customer.
  ///
  /// The function updates order's necessary data in database.
  ///
  /// returns the updated order.
  Future<Order> deliveredOrder({required Order order}) async {
    var deliveredOrder = order.copyWith(
      deliveryTime: DateTime.now(),
      isDelivered: true,
      orderStatus: OrderStatus.deliveredPackage,
    );

    await _ordersCollection.doc(order.orderId).update(deliveredOrder.toJson());

    return deliveredOrder;
  }

  /// Get current order for the user, Or Null if the user has no current order
  ///
  /// Provides [userId] and [isCustomer]
  ///
  /// The [isCustomer] is true for customer and false for driver
  Future<Order?> getCurrentOrder({
    required String userId,

    /// True if customer, false if driver
    required bool isCustomer,
  }) async {
    return await _ordersCollection
        .where(isCustomer ? 'customerId' : 'driverId', isEqualTo: userId)
        .where(isCustomer ? 'isReceived' : 'isDelivered', isEqualTo: false)
        .limit(1)
        .get()
        .then((snap) {
      if (snap.docs.isEmpty) {
        return null;
      }
      return Order.fromJson(snap.docs.first.id, snap.docs.first.data());
    });
  }
}
