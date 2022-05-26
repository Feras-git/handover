import 'package:flutter/material.dart';
import 'package:handover/core/constants.dart';
import 'package:handover/core/widgets/custom_button.dart';
import 'package:sizer/sizer.dart';
import 'package:handover/core/widgets/entry_field.dart';

import '../../signup/presentation/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));

    _fadeAnimation =
        Tween<double>(begin: .2, end: 1).animate(_animationController!);

    _animationController?.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: FadeTransition(
                opacity: _fadeAnimation!,
                child: Text(
                  'HANDOVER',
                  style: TextStyle(
                    fontSize: 25.sp,
                    letterSpacing: 4.sp,
                    fontWeight: FontWeight.bold,
                    color: kMainColor,
                  ),
                ),
              ),
            ),
            ListView(
              padding: EdgeInsets.symmetric(
                horizontal: 7.w,
              ),
              shrinkWrap: true,
              children: [
                Text(
                  'Login to your account',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 3.h),
                EntryField(
                  hintText: 'Email',
                  icon: Icons.email,
                ),
                SizedBox(height: 3.h),
                EntryField(
                  hintText: 'Password',
                  icon: Icons.password,
                  obscureText: true,
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: CustomButton(
                    text: 'Login',
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?    '),
                    GestureDetector(
                      child: Text(
                        'Sign up here',
                        style: TextStyle(
                          color: kMainColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
