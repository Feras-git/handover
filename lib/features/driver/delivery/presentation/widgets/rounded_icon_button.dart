import 'package:flutter/material.dart';
import 'package:handover/core/constants.dart';
import 'package:sizer/sizer.dart';

class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final Function onTap;

  RoundedIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: kMainColor,
        child: InkWell(
          splashColor: Colors.white,
          onTap: () => onTap(),
          child: SizedBox(
            width: 11.5.w,
            height: 11.5.w,
            child: Icon(icon),
          ),
        ),
      ),
    );
  }
}
