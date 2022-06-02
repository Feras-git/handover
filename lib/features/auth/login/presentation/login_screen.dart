import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handover/core/constants.dart';
import 'package:handover/core/enums.dart';
import 'package:handover/core/widgets/custom_button.dart';
import 'package:handover/features/auth/auth/auth_bloc.dart';
import 'package:handover/features/auth/helpers/auth_validator.dart';
import 'package:handover/features/auth/login/cubit/login_cubit.dart';
import 'package:handover/features/auth/signup/presentation/signup_screen.dart';
import 'package:handover/features/home_gate/presentation/home_gate.dart';
import 'package:handover/repositories/auth_repository/auth_repository.dart';
import 'package:handover/repositories/user_data_repository/user_data_repository.dart';
import 'package:handover/utils/app_dialogs.dart';
import 'package:sizer/sizer.dart';
import 'package:handover/core/widgets/entry_field.dart';

class LoginScreen extends StatefulWidget {
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
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(
        authBloc: context.read<AuthBloc>(),
        authRepository: context.read<AuthRepository>(),
        userDataRepository: context.read<UserDataRepository>(),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<LoginCubit, LoginState>(
          listenWhen: (previous, current) => previous.status != current.status,
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
            return SafeArea(
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
                        onChanged: (value) {
                          context.read<LoginCubit>().emailChanged(value);
                        },
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
                        onChanged: (value) {
                          context.read<LoginCubit>().passwordChanged(value);
                        },
                        errorText: state.password.isEmpty ||
                                AuthValidator.isPasswordValid(state.password)
                            ? null
                            : 'Password should be 6 characters minimum',
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: CustomButton(
                          text: 'Login',
                          onPressed: () async {
                            if (AuthValidator.isEmailValid(state.email) &&
                                AuthValidator.isPasswordValid(state.password)) {
                              await context.read<LoginCubit>().login();
                            } else {}
                          },
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
            );
          },
        ),
      ),
    );
  }
}
