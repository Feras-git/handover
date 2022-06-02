import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handover/core/constants.dart';
import 'package:handover/core/enums.dart';
import 'package:handover/features/auth/login/presentation/login_screen.dart';
import 'package:handover/features/auth/user_data/user_data_cubit.dart';
import 'package:handover/features/customer/customer_home/presentation/customer_home.dart';
import 'package:handover/features/driver/driver_home/presentation/driver_home.dart';

class HomeGate extends StatefulWidget {
  @override
  State<HomeGate> createState() => _HomeGateState();
}

class _HomeGateState extends State<HomeGate> {
  @override
  void initState() {
    context.read<UserDataCubit>().loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataCubit, UserDataState>(
      builder: (context, state) {
        switch (state.stateStatus) {
          case StateStatus.loading:
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: kMainColor,
                ),
              ),
            );
          case StateStatus.successful:
            return state.userData!.accountType == AccountType.customer
                ? CustomerHomeScreen()
                : DriverHomeScreen();
          default:
            // TODO deal with failure
            return LoginScreen();
        }
      },
    );
  }
}
