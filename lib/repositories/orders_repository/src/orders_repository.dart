import 'package:cloud_firestore/cloud_firestore.dart';
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

  /// Insert service rating for order to database.
  Future rateOrder({
    required String orderId,
    required double rating,
  }) async {
    await _ordersCollection.doc(orderId).update({
      'rating': rating,
    });
  }

  /// Live tracking of driver's location for an order.
  Stream<GeoPoint> driverLocationStream({required String orderId}) {
    return _ordersCollection
        .doc(orderId)
        .snapshots()
        .map((snap) => snap['driverLocation'] as GeoPoint)
        .distinct();
  }

  /// List of orders that are waiting for driver to pick up.
  Stream<List<Order>> ordersWaitingForPickUpStream() {
    var query = _ordersCollection.where('isPickedUp', isEqualTo: false);

    return query.snapshots().map((snap) {
      List<Order> result = snap.docs.map((doc) {
        return Order.fromJson(doc.id, doc.data());
      }).toList();

      return result;
    });
  }

  /// A driver picks up an order.
  ///
  /// The function updates order's necessary data in database.
  Future pickUpOrder({
    required driverId,
    required GeoPoint driverLocation,
    required Order order,
  }) async {
    var pickedOrder = order.copyWith(
      driverId: driverId,
      isPickedUp: true,
      driverLocation: driverLocation,
      pickUpTime: DateTime.now(),
    );
    await _ordersCollection.doc(order.orderId).update(pickedOrder.toJson());
  }

  /// A driver delivered the order to customer.
  ///
  /// The function updates order's necessary data in database.
  Future deliverOrder({required Order order}) async {
    var deliveredOrder = order.copyWith(
      deliveryTime: DateTime.now(),
      isDelivered: true,
    );

    await _ordersCollection.doc(order.orderId).update(deliveredOrder.toJson());
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
