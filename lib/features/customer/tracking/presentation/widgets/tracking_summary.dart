import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';

class TrackingSummary extends StatelessWidget {
  /// Initial rating is a number from 1 to 5
  final int initialRating;
  final Function onRatingUpdate;
  final Color ratingStarsColor;
  final TimeOfDay? pickupTime;
  final TimeOfDay? deliveryTime;
  final double totalPrice;
  final Function onSubmit;

  TrackingSummary({
    required this.initialRating,
    required this.onRatingUpdate(int rating),
    this.ratingStarsColor = Colors.white,
    required this.pickupTime,
    required this.deliveryTime,
    required this.totalPrice,
    required this.onSubmit,
  }) : assert(initialRating >= 1 && initialRating <= 5);

  @override
  Widget build(BuildContext context) {
    double contentHorizontalPadding = 14.w;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: RatingBar.builder(
            initialRating: initialRating.toDouble(),
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(
              horizontal: 1.w,
            ),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: ratingStarsColor,
            ),
            onRatingUpdate: (rating) => onRatingUpdate(rating.toInt()),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 6.h,
            horizontal: contentHorizontalPadding,
          ),
          child: Column(
            children: [
              _TimingInfoRow(
                infoText: 'Pickup Time',
                infoTime: pickupTime,
              ),
              SizedBox(height: 3.h),
              _TimingInfoRow(
                infoText: 'Delivery Time',
                infoTime: deliveryTime,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: contentHorizontalPadding,
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '\$$totalPrice',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              Spacer(),
              _SubmitButton(onSubmit: onSubmit),
            ],
          ),
        )
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  final Function onSubmit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSubmit(),
      child: Container(
        padding: EdgeInsets.only(
          right: 4.w,
          left: 10.w,
          top: 1.5.h,
          bottom: 1.5.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(20.sp),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Submit',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 9.w),
            Icon(
              Icons.arrow_forward,
            )
          ],
        ),
      ),
    );
  }
}

class _TimingInfoRow extends StatelessWidget {
  final String infoText;
  final TimeOfDay? infoTime;

  const _TimingInfoRow({
    required this.infoText,
    required this.infoTime,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          infoText,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Spacer(),
        Text(
          infoTime == null ? '--:--' : infoTime!.format(context),
        ),
      ],
    );
  }
}
