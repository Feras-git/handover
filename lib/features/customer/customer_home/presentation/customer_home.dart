import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handover/core/constants.dart';
import 'package:handover/core/widgets/custom_button.dart';
import 'package:handover/features/auth/login/presentation/login_screen.dart';
import 'package:handover/features/auth/logout/cubit/logout_cubit.dart';
import 'package:handover/utils/app_dialogs.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text('Handover (Customer)'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              AppDialogs.showLoading();
              await context.read<LogoutCubit>().logout();
              AppDialogs.dismissLoading();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
                (route) => false,
              );
            },
          )
        ],
      ),
      body: Center(
        child: CustomButton(
          text: '  Get my package to my location  ',
        ),
      ),
    );
  }
}
