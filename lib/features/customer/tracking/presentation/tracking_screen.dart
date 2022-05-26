import 'package:flutter/material.dart';
import 'package:handover/core/constants.dart';
import 'package:handover/core/enums.dart';
import 'package:handover/features/customer/tracking/presentation/widgets/tracking_summary.dart';
import 'package:handover/features/customer/tracking/presentation/widgets/tracking_timeline.dart';
import 'package:sizer/sizer.dart';

import 'widgets/tracking_bottom_sheet.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrderStatus orderStatus = OrderStatus.deliveredPackage;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Text('Map should appear here...'),
          ),
          TrackingBottomSheet(
            avatar: AssetImage(kDefaultAvatarPath),
            column: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'User Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                orderStatus != OrderStatus.deliveredPackage
                    ? TrackingTimeline(
                        currentOrderStatus: orderStatus,
                      )
                    : TrackingSummary(
                        initialRating: 3,
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                        pickupTime: TimeOfDay(hour: 10, minute: 0),
                        deliveryTime: TimeOfDay(hour: 10, minute: 30),
                        totalPrice: 30,
                        onSubmit: () {
                          print('Submitted');
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
