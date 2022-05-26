import 'package:flutter/material.dart';
import 'package:handover/core/constants.dart';
import 'package:handover/core/widgets/custom_button.dart';
import 'package:sizer/sizer.dart';
import 'package:handover/core/widgets/entry_field.dart';

import '../../../../core/enums.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  AccountType _accountType = AccountType.customer;

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
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                horizontal: 7.w,
              ),
              children: [
                Text(
                  'Create new account',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 3.h),
                EntryField(hintText: 'Full Name', icon: Icons.perm_identity),
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
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Text(
                      'Account Type: ',
                      style: TextStyle(
                        color: kMainColor,
                        fontSize: 12.sp,
                      ),
                    ),
                    Row(
                      children: [
                        Radio<AccountType>(
                          fillColor:
                              MaterialStateProperty.all<Color>(kMainColor),
                          value: AccountType.customer,
                          groupValue: _accountType,
                          onChanged: (value) {
                            setState(() {
                              _accountType = value ?? _accountType;
                            });
                          },
                        ),
                        Text('Customer'),
                      ],
                    ),
                    //
                    SizedBox(width: 3.w),
                    //
                    Row(
                      children: [
                        Radio<AccountType>(
                          fillColor:
                              MaterialStateProperty.all<Color>(kMainColor),
                          value: AccountType.driver,
                          groupValue: _accountType,
                          onChanged: (value) {
                            setState(() {
                              _accountType = value ?? _accountType;
                            });
                          },
                        ),
                        Text('Driver'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: CustomButton(
                    text: 'Register',
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account   '),
                    GestureDetector(
                      child: Text(
                        'Back to login',
                        style: TextStyle(
                          color: kMainColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => SignUpScreen(),
                        //   ),
                        // );
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
