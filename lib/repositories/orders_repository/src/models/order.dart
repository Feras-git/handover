import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Order extends Equatable {
  /// The id of the order
  final String? orderId;

  /// The name of the ordered product
  final String productName;

  /// The userId of the customer who ordered the package
  final String customerId;

  /// The userId of the driver who picked up the package
  final String? driverId;

  /// The location of customer
  final GeoPoint customerLocation;

  /// The live location of driver
  final GeoPoint? driverLocation;

  /// The package is picked up by driver and went to delivery
  final bool isPickedUp;

  /// The package is delivered to the customer
  final bool isDelivered;

  /// The customer received the order and submitted that.
  final bool isReceived;

  /// The time when the customer ordered the package
  final DateTime orderTime;

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
    required this.customerLocation,
    this.driverLocation,
    this.isPickedUp = false,
    this.isDelivered = false,
    this.isReceived = false,
    required this.orderTime,
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
    GeoPoint? customerLocation,
    GeoPoint? driverLocation,
    bool? isPickedUp,
    bool? isDelivered,
    bool? isReceived,
    DateTime? orderTime,
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
      customerLocation: customerLocation ?? this.customerLocation,
      driverLocation: driverLocation ?? this.driverLocation,
      isPickedUp: isPickedUp ?? this.isPickedUp,
      isDelivered: isDelivered ?? this.isDelivered,
      isReceived: isReceived ?? this.isReceived,
      orderTime: orderTime ?? this.orderTime,
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
      customerLocation,
      driverLocation,
      isPickedUp,
      isDelivered,
      isReceived,
      orderTime,
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
      'customerLocation': customerLocation,
      'driverLocation': driverLocation,
      'isPickedUp': isPickedUp,
      'isDelivered': isDelivered,
      'isReceived': isReceived,
      'orderTime': orderTime,
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
      customerLocation: map['customerLocation'],
      driverLocation: map['driverLocation'],
      isPickedUp: map['isPickedUp'],
      isDelivered: map['isDelivered'],
      isReceived: map['isReceived'],
      orderTime: DateTime.parse(map['orderTime'].toDate().toString()),
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
