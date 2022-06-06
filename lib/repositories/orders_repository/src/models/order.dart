import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:handover/core/enums.dart';

class Order extends Equatable {
  /// The id of the order
  final String? orderId;

  /// The name of the ordered product
  final String productName;

  /// The userId of the customer who ordered the package
  final String customerId;

  /// The userId of the driver who picked up the package
  final String? driverId;

  /// The current status of the order
  final OrderStatus? orderStatus;

  /// The location of customer
  final GeoPoint customerLocation;

  /// The location of pickup
  final GeoPoint pickUpLocation;

  /// The live location of driver
  final GeoPoint? driverLocation;

  /// The order is on wait list looking for driver to serve it
  final bool isPending;

  /// The driver is near to the pick up destination
  final bool isNearToPickUp;

  /// The driver is near to the customer destination
  final bool isNearToCustomer;

  /// The package is picked up by driver and went to delivery
  final bool isPickedUp;

  /// The package is delivered to the customer
  final bool isDelivered;

  /// The customer received the order and submitted that.
  final bool isReceived;

  /// The time when the customer ordered the package
  final DateTime orderTime;

  /// The time when the driver start the journey
  final DateTime? startTime;

  /// The time when the driver picked up the package to delivery
  final DateTime? pickUpTime;

  /// The time when the package is delivered
  final DateTime? deliveryTime;

  /// Total price of the package
  final double totalPrice;

  /// The Service rating by customer
  final double? rating;

  Order({
    this.orderId,
    required this.productName,
    required this.customerId,
    this.driverId,
    this.orderStatus,
    required this.customerLocation,
    required this.pickUpLocation,
    this.driverLocation,
    this.isPending = true,
    this.isNearToPickUp = false,
    this.isNearToCustomer = false,
    this.isPickedUp = false,
    this.isDelivered = false,
    this.isReceived = false,
    required this.orderTime,
    this.startTime,
    this.pickUpTime,
    this.deliveryTime,
    required this.totalPrice,
    this.rating,
  });

  Order copyWith({
    String? orderId,
    String? productName,
    String? customerId,
    String? driverId,
    OrderStatus? orderStatus,
    GeoPoint? customerLocation,
    GeoPoint? pickUpLocation,
    GeoPoint? driverLocation,
    bool? isPending,
    bool? isNearToPickUp,
    bool? isNearToCustomer,
    bool? isPickedUp,
    bool? isDelivered,
    bool? isReceived,
    DateTime? orderTime,
    DateTime? startTime,
    DateTime? pickUpTime,
    DateTime? deliveryTime,
    double? totalPrice,
    double? rating,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      productName: productName ?? this.productName,
      customerId: customerId ?? this.customerId,
      driverId: driverId ?? this.driverId,
      orderStatus: orderStatus ?? this.orderStatus,
      customerLocation: customerLocation ?? this.customerLocation,
      pickUpLocation: pickUpLocation ?? this.pickUpLocation,
      driverLocation: driverLocation ?? this.driverLocation,
      isPending: isPending ?? this.isPending,
      isNearToPickUp: isNearToPickUp ?? this.isNearToPickUp,
      isNearToCustomer: isNearToCustomer ?? this.isNearToCustomer,
      isPickedUp: isPickedUp ?? this.isPickedUp,
      isDelivered: isDelivered ?? this.isDelivered,
      isReceived: isReceived ?? this.isReceived,
      orderTime: orderTime ?? this.orderTime,
      startTime: startTime ?? this.startTime,
      pickUpTime: pickUpTime ?? this.pickUpTime,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      totalPrice: totalPrice ?? this.totalPrice,
      rating: rating ?? this.rating,
    );
  }

  @override
  List<Object?> get props {
    return [
      orderId,
      productName,
      customerId,
      driverId,
      orderStatus,
      customerLocation,
      pickUpLocation,
      driverLocation,
      isPending,
      isNearToPickUp,
      isNearToCustomer,
      isPickedUp,
      isDelivered,
      isReceived,
      orderTime,
      startTime,
      pickUpTime,
      deliveryTime,
      totalPrice,
      rating,
    ];
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'customerId': customerId,
      'driverId': driverId,
      'orderStatus': orderStatus?.name,
      'customerLocation': customerLocation,
      'pickUpLocation': pickUpLocation,
      'driverLocation': driverLocation,
      'isPending': isPending,
      'isNearToPickUp': isNearToPickUp,
      'isNearToCustomer': isNearToCustomer,
      'isPickedUp': isPickedUp,
      'isDelivered': isDelivered,
      'isReceived': isReceived,
      'orderTime': orderTime,
      'startTime': startTime,
      'pickUpTime': pickUpTime,
      'deliveryTime': deliveryTime,
      'totalPrice': totalPrice,
      'rating': rating,
    };
  }

  factory Order.fromJson(String orderId, Map map) {
    return Order(
      orderId: orderId,
      productName: map['productName'],
      customerId: map['customerId'] ?? '',
      driverId: map['driverId'],
      orderStatus: map['orderStatus'] == null
          ? null
          : OrderStatus.values
              .firstWhere((value) => value.name == map['orderStatus']),
      customerLocation: map['customerLocation'],
      pickUpLocation: map['pickUpLocation'],
      driverLocation: map['driverLocation'],
      isPending: map['isPending'],
      isNearToPickUp: map['isNearToPickUp'],
      isNearToCustomer: map['isNearToCustomer'],
      isPickedUp: map['isPickedUp'],
      isDelivered: map['isDelivered'],
      isReceived: map['isReceived'],
      orderTime: DateTime.parse(map['orderTime'].toDate().toString()),
      startTime: map['startTime'] == null
          ? null
          : DateTime.parse(map['startTime'].toDate().toString()),
      pickUpTime: map['pickUpTime'] == null
          ? null
          : DateTime.parse(map['pickUpTime'].toDate().toString()),
      deliveryTime: map['deliveryTime'] == null
          ? null
          : DateTime.parse(map['deliveryTime'].toDate().toString()),
      totalPrice: map['totalPrice'],
      rating: map['rating'],
    );
  }
}
