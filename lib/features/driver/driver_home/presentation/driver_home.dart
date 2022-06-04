import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handover/core/enums.dart';
import 'package:handover/core/widgets/location_accessories/location_granted_enabled_wrapper.dart';
import 'package:handover/features/auth/login/presentation/login_screen.dart';
import 'package:handover/features/auth/logout/cubit/logout_cubit.dart';
import 'package:handover/features/auth/user_data/user_data_cubit.dart';
import 'package:handover/features/driver/cubit/driver_cubit.dart';
import 'package:handover/features/driver/driver_home/presentation/widgets/order_widger.dart';
import 'package:handover/repositories/orders_repository/orders_repository.dart';
import 'package:handover/utils/app_dialogs.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/constants.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LocationGrantedEnabledWrapper(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: kMainColor,
            title: Text('Handover (Driver)'),
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
          body: BlocProvider<DriverCubit>(
            create: (context) => DriverCubit(
              userDataCubit: context.read<UserDataCubit>(),
              ordersRepository: context.read<OrdersRepository>(),
            ),
            child: BlocConsumer<DriverCubit, DriverState>(
              listener: (context, state) {
                if (state.stateStatus == StateStatus.loading) {
                  AppDialogs.showLoading();
                } else {
                  AppDialogs.dismissLoading();
                  if (state.stateStatus == StateStatus.failure) {
                    //TODO deal with failure
                    AppDialogs.showCustomAlert(
                        context: context,
                        title: 'Error',
                        content: state.errorMessage);
                  }
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    SizedBox(height: 4.h),
                    Text(
                      'Pick an order and go!',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    StreamBuilder<List<Order>>(
                        stream: context.read<DriverCubit>().ordersStream(),
                        builder: (context, snapshot) {
                          List<Order> ordersList =
                              snapshot.hasData ? snapshot.data! : [];
                          return ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                              vertical: 5.h,
                              horizontal: 5.w,
                            ),
                            itemCount: ordersList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  OrderWidget(
                                    productName: ordersList[index].productName,
                                    distanceByKilometers:
                                        state.driverLocation == null
                                            ? null
                                            : context
                                                .read<DriverCubit>()
                                                .distanceToOrderDestination(
                                                  order: ordersList[index],
                                                  unit: DistanceUnit.kilometers,
                                                ),
                                  ),
                                  SizedBox(height: 2.h),
                                ],
                              );
                            },
                          );
                        }),
                  ],
                );
              },
            ),
          )),
    );
  }
}
