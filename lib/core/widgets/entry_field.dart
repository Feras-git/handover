import 'package:flutter/material.dart';

import '../constants.dart';

class EntryField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final String? errorText;
  final String? initialValue;
  EntryField({
    this.controller,
    this.hintText = '',
    this.icon,
    this.onChanged,
    this.obscureText = false,
    this.errorText,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      onChanged: onChanged,
      cursorColor: kMainColor,
      obscureText: obscureText,
      decoration: InputDecoration(
        icon: icon != null
            ? Icon(
                icon,
                color: kMainColor,
              )
            : null,
        hintText: hintText,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kMainColor),
        ),
        errorText: errorText,
        errorStyle: TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }
}
