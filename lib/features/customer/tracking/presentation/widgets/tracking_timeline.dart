import 'package:flutter/material.dart';
import 'package:handover/core/enums.dart';
import 'package:timelines/timelines.dart';
import 'package:sizer/sizer.dart';

class TrackingTimeline extends StatelessWidget {
  final OrderStatus currentOrderStatus;

  /// Color of nodes (and their connecters) that are in progress.
  final Color pendingColor;

  /// Color of nodes (and their connecters) which their progress is done.
  final Color doneColor;
  TrackingTimeline({
    required this.currentOrderStatus,
    this.pendingColor = Colors.black,
    this.doneColor = Colors.white,
  });

  String _getOrderStatusString(OrderStatus status) {
    switch (status) {
      case OrderStatus.onTheWay:
        return 'On the way';
      case OrderStatus.pickedUpDelivery:
        return 'Picked up delivery';
      case OrderStatus.nearDeliveryDestination:
        return 'Near delivery destination';
      default:
        return 'Delivered package';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 5.w,
      ),
      child: FixedTimeline.tileBuilder(
        theme: TimelineTheme.of(context).copyWith(
          nodePosition: 0,
        ),
        builder: TimelineTileBuilder(
          itemCount: OrderStatus.values.length,
          contentsAlign: ContentsAlign.basic,
          contentsBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(
              vertical: 3.5.h,
              horizontal: 5.w,
            ),
            child: Text(
              _getOrderStatusString(OrderStatus.values[index]),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: index <= OrderStatus.values.indexOf(currentOrderStatus)
                    ? pendingColor
                    : doneColor,
              ),
            ),
          ),
          indicatorBuilder: (_, index) => Indicator.dot(
            color: index <= OrderStatus.values.indexOf(currentOrderStatus)
                ? pendingColor
                : doneColor,
          ),
          startConnectorBuilder: (_, index) => index == 0
              ? null
              : Connector.solidLine(
                  color: index <= OrderStatus.values.indexOf(currentOrderStatus)
                      ? pendingColor
                      : doneColor,
                ),
          endConnectorBuilder: (_, index) => index ==
                  OrderStatus.values.length - 1
              ? null
              : Connector.solidLine(
                  color: index <= OrderStatus.values.indexOf(currentOrderStatus)
                      ? pendingColor
                      : doneColor,
                ),
        ),
      ),
    );
  }
}
