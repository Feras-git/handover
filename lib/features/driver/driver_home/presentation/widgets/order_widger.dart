import 'package:flutter/material.dart';
import 'package:handover/core/constants.dart';
import 'package:sizer/sizer.dart';

class OrderWidget extends StatelessWidget {
  final String customerName;
  final double distanceByKilometers;

  OrderWidget({
    required this.customerName,
    required this.distanceByKilometers,
  });

  final TextStyle _textStyle = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 2.h,
        horizontal: 4.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            customerName,
            style: _textStyle,
          ),
          Text(
            distanceByKilometers.toString() + ' Km',
            style: _textStyle,
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: kMainColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );
  }
}
