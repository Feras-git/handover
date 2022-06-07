import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handover/core/constants.dart';
import 'package:handover/core/widgets/custom_map_view.dart';
import 'package:handover/features/auth/login/presentation/login_screen.dart';
import 'package:handover/features/auth/logout/cubit/logout_cubit.dart';
import 'package:handover/features/driver/driver_home/cubit/driver_cubit.dart';
import 'package:handover/features/driver/delivery/cubit/delivery_cubit.dart';
import 'package:handover/core/widgets/rounded_icon_button.dart';
import 'package:handover/repositories/orders_repository/orders_repository.dart';
import 'package:handover/repositories/user_data_repository/user_data_repository.dart';
import 'package:handover/utils/app_dialogs.dart';

class DeliveryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GoogleMapController? _mapController;

    return BlocProvider<DeliveryCubit>(
      create: (context) => DeliveryCubit(
        driverCubit: context.read<DriverCubit>(),
        ordersRepository: context.read<OrdersRepository>(),
        userDataRepository: context.read<UserDataRepository>(),
      ),
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
        body: BlocConsumer<DeliveryCubit, DeliveryState>(
          listener: (context, state) {
            if (state.finishedDelivery) {
              AppDialogs.showCustomAlert(
                  context: context,
                  title: 'Well done!',
                  content:
                      'Thanks for your service.. it\'s time to leave for another order!',
                  onBtnPressed: () {
                    Navigator.pop(context);
                  });
            }
          },
          builder: (context, state) {
            LatLng driverLiveLatLng = LatLng(
              state.driverLiveLocation.latitude,
              state.driverLiveLocation.longitude,
            );

            LatLng customerLatLng = LatLng(
              context
                  .read<DriverCubit>()
                  .state
                  .currentOrder!
                  .customerLocation
                  .latitude,
              context
                  .read<DriverCubit>()
                  .state
                  .currentOrder!
                  .customerLocation
                  .longitude,
            );

            LatLng pickUpLatLng = LatLng(
                context
                    .read<DriverCubit>()
                    .state
                    .currentOrder!
                    .pickUpLocation
                    .latitude,
                context
                    .read<DriverCubit>()
                    .state
                    .currentOrder!
                    .pickUpLocation
                    .longitude);
            return Stack(
              children: [
                CustomMapView(
                  doWithMapController: (controller) {
                    _mapController = controller;
                  },
                  initialCameraLocation: driverLiveLatLng,
                  pickupPosition: pickUpLatLng,
                  customerPosition: customerLatLng,
                  userLivePosition: driverLiveLatLng,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      // animate to driver location
                      RoundedIconButton(
                        icon: Icons.directions_bike,
                        onTap: () {
                          _mapController?.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: driverLiveLatLng,
                                zoom: 15,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 8),
                      // animate to pick up location
                      RoundedIconButton(
                        icon: Icons.shopping_basket,
                        onTap: () {
                          _mapController?.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: pickUpLatLng,
                                zoom: 15,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 8),
                      // animate to customer location
                      RoundedIconButton(
                        icon: Icons.location_history,
                        onTap: () {
                          _mapController?.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: customerLatLng,
                                zoom: 15,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
