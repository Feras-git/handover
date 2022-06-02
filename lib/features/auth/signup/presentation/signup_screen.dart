import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handover/core/constants.dart';
import 'package:handover/core/enums.dart';
import 'package:handover/core/widgets/custom_button.dart';
import 'package:handover/features/auth/auth/auth_bloc.dart';
import 'package:handover/features/auth/helpers/auth_validator.dart';
import 'package:handover/features/home_gate/presentation/home_gate.dart';
import 'package:handover/repositories/auth_repository/auth_repository.dart';
import 'package:handover/repositories/user_data_repository/user_data_repository.dart';
import 'package:handover/utils/app_dialogs.dart';
import 'package:sizer/sizer.dart';
import 'package:handover/core/widgets/entry_field.dart';

import '../cubit/signup_cubit.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
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
    return BlocProvider<SignupCubit>(
      create: (context) => SignupCubit(
          authBloc: context.read<AuthBloc>(),
          authRepository: context.read<AuthRepository>(),
          userDataRepository: context.read<UserDataRepository>()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: BlocConsumer<SignupCubit, SignupState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == StateStatus.loading) {
                AppDialogs.showLoading();
              } else {
                AppDialogs.dismissLoading();
                if (state.status == StateStatus.failure) {
                  AppDialogs.showCustomAlert(
                      context: context,
                      title: 'Something wrong!',
                      content: state.errorMessage);
                } else if (state.status == StateStatus.successful) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeGate(),
                    ),
                    (route) => false,
                  );
                }
              }
            },
            builder: (context, state) {
              return Column(
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
                      EntryField(
                        hintText: 'Full Name',
                        icon: Icons.perm_identity,
                        onChanged: (value) =>
                            context.read<SignupCubit>().fullNameChanged(value),
                        errorText: state.fullName.isEmpty ||
                                AuthValidator.isFullNameValid(state.fullName)
                            ? null
                            : 'Please enter a valid fullname!',
                      ),
                      SizedBox(height: 3.h),
                      EntryField(
                        hintText: 'Email',
                        icon: Icons.email,
                        onChanged: (value) =>
                            context.read<SignupCubit>().emailChanged(value),
                        errorText: state.email.isEmpty ||
                                AuthValidator.isEmailValid(state.email)
                            ? null
                            : 'Email should be like email@example.com',
                      ),
                      SizedBox(height: 3.h),
                      EntryField(
                        hintText: 'Password',
                        icon: Icons.password,
                        obscureText: true,
                        onChanged: (value) =>
                            context.read<SignupCubit>().passwordChanged(value),
                        errorText: state.password.isEmpty ||
                                AuthValidator.isPasswordValid(state.password)
                            ? null
                            : 'Password should be 6 characters minimum',
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
                                fillColor: MaterialStateProperty.all<Color>(
                                    kMainColor),
                                value: AccountType.customer,
                                groupValue: state.accountType,
                                onChanged: (value) {
                                  context
                                      .read<SignupCubit>()
                                      .accountTypeChanged(value!);
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
                                fillColor: MaterialStateProperty.all<Color>(
                                    kMainColor),
                                value: AccountType.driver,
                                groupValue: state.accountType,
                                onChanged: (value) {
                                  context
                                      .read<SignupCubit>()
                                      .accountTypeChanged(value!);
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
                          onPressed: () async {
                            if (AuthValidator.isFullNameValid(state.fullName) &&
                                AuthValidator.isEmailValid(state.email) &&
                                AuthValidator.isPasswordValid(state.password)) {
                              await context.read<SignupCubit>().signup();
                            } else {
                              AppDialogs.showCustomAlert(
                                context: context,
                                title: 'Missed data!',
                                content: 'Please fill data correctly!',
                              );
                            }
                          },
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
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
