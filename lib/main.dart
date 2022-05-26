import 'package:flutter/material.dart';
import 'package:handover/core/constants.dart';
import 'package:handover/features/auth/login/presentation/login_screen.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Handover',
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            selectionHandleColor: kMainColor,
          ),
        ),
        home: LoginScreen(),
      );
    });
  }
}
