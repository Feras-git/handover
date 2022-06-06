import 'package:flutter/material.dart';
import 'package:handover/core/constants.dart';
import 'package:handover/core/helpers/round_double.dart';
import 'package:sizer/sizer.dart';

class OrderWidget extends StatelessWidget {
  final String productName;
  final double? distanceByKilometers;
  final Function onTap;

  OrderWidget({
    required this.productName,
    required this.distanceByKilometers,
    required this.onTap,
  });

  final TextStyle _textStyle = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => onTap()),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 2.h,
          horizontal: 4.w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              productName,
              style: _textStyle,
            ),
            Text(
              distanceByKilometers == null
                  ? '-- Km'
                  : '${roundDouble(distanceByKilometers!, 2)}  Km',
              style: _textStyle,
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: kMainColor,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}
