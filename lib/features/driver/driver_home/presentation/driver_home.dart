import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handover/core/constants.dart';
import 'package:handover/core/enums.dart';
import 'package:handover/core/widgets/custom_button.dart';
import 'package:handover/core/widgets/location_accessories/location_granted_enabled_wrapper.dart';
import 'package:handover/features/auth/login/presentation/login_screen.dart';
import 'package:handover/features/auth/logout/cubit/logout_cubit.dart';
import 'package:handover/features/driver/driver_home/cubit/driver_cubit.dart';
import 'package:handover/features/driver/delivery/presentation/delivery_screen.dart';
import 'package:handover/features/driver/driver_home/presentation/widgets/order_widget.dart';
import 'package:handover/repositories/orders_repository/orders_repository.dart';
import 'package:handover/utils/app_dialogs.dart';
import 'package:sizer/sizer.dart';

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
          body: BlocConsumer<DriverCubit, DriverState>(
            listener: (context, state) {
              if (state.stateStatus == StateStatus.loading) {
                AppDialogs.showLoading();
              } else {
                AppDialogs.dismissLoading();
                if (state.stateStatus == StateStatus.failure) {
                  AppDialogs.showCustomAlert(
                      context: context,
                      title: 'Error',
                      content: state.errorMessage);
                }
              }
            },
            builder: (context, state) {
              return state.currentOrder != null &&
                      !state.currentOrder!.isDelivered
                  ? Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                      ),
                      child: CustomButton(
                        text:
                            '  You are delivering a package, continue to delivery  ',
                        textStyle: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DeliveryScreen(),
                          ));
                        },
                      ),
                    )
                  : Column(
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
                                        onTap: () {
                                          context
                                              .read<DriverCubit>()
                                              .serveOrder(
                                                  order: ordersList[index]);
                                        },
                                        productName:
                                            ordersList[index].productName,
                                        distanceByKilometers: state
                                                    .driverLocation ==
                                                null
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
          )),
    );
  }
}
