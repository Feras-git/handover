import 'package:flutter/material.dart';
import 'package:handover/core/constants.dart';
import 'package:sizer/sizer.dart';

class TrackingBottomSheet extends StatelessWidget {
  final ImageProvider avatar;

  /// Pass Column as child..
  final Column column;

  TrackingBottomSheet({
    required this.avatar,
    required this.column,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .5,
      minChildSize: .15,
      maxChildSize: .8,
      builder: (BuildContext context, ScrollController scrollController) {
        return Stack(
          children: [
            Positioned(
              top: 7.h,
              bottom: 0,
              child: Container(
                width: 100.w,
                padding: EdgeInsets.only(
                  top: 9.h,
                ),
                decoration: BoxDecoration(
                  color: kMainColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.sp),
                    topRight: Radius.circular(20.sp),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: column,
                ),
              ),
            ),
            SingleChildScrollView(
              controller: scrollController,
              child: Align(
                alignment: Alignment.topCenter,
                child: CircleAvatar(
                  backgroundImage: avatar,
                  radius: 7.h,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
