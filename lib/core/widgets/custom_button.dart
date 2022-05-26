import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function? onPressed;
  final Color? borderColor;
  final Color? color;
  final TextStyle? textStyle;
  final IconData? icon;
  final Color? textColor;

  CustomButton({
    required this.text,
    this.onPressed,
    this.borderColor,
    this.color,
    this.textStyle,
    this.icon,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          vertical: 3.h,
        ),
        backgroundColor: color ?? kMainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: borderColor ?? Colors.transparent),
        ),
      ),
      onPressed: onPressed as void Function()?,
      child: Text(
        text,
        style: textStyle ??
            TextStyle(
              color: textColor ?? Colors.black54,
              fontSize: 12.sp,
              letterSpacing: 1.5.sp,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
