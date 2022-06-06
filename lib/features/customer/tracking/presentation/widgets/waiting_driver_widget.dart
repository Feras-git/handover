import 'package:flutter/material.dart';
import 'package:handover/core/constants.dart';
import 'package:sizer/sizer.dart';

class WaitingDriverWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 25.h,
          child: Image(
            image: AssetImage(
              kWaitingImagePath,
            ),
          ),
        ),
        Text(
          'Looking for a driver to serve you ...',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
