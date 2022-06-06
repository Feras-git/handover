import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handover/core/constants.dart';
import 'package:handover/core/enums.dart';
import 'package:handover/core/widgets/custom_map_view.dart';
import 'package:handover/features/auth/user_data/user_data_cubit.dart';
import 'package:handover/features/customer/customer_home/cubit/customer_cubit.dart';
import 'package:handover/features/customer/tracking/cubit/tracking_cubit.dart';
import 'package:handover/features/customer/tracking/presentation/widgets/side_buttons_widget.dart';
import 'package:handover/features/customer/tracking/presentation/widgets/tracking_summary.dart';
import 'package:handover/features/customer/tracking/presentation/widgets/tracking_timeline.dart';
import 'package:handover/features/customer/tracking/presentation/widgets/waiting_driver_widget.dart';
import 'package:handover/repositories/orders_repository/src/orders_repository.dart';
import 'package:handover/utils/app_dialogs.dart';
import 'package:sizer/sizer.dart';

import 'widgets/tracking_bottom_sheet.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GoogleMapController? _mapController;
    return BlocProvider<TrackingCubit>(
      create: (context) => TrackingCubit(
        currentOrder: context.read<CustomerCubit>().state.currentOrder!,
        ordersRepository: context.read<OrdersRepository>(),
        customerCubit: context.read<CustomerCubit>(),
      ),
      child: Scaffold(
        body: BlocConsumer<TrackingCubit, TrackingState>(
          listener: (context, state) {
            if (state.submittionStatus == StateStatus.loading) {
              AppDialogs.showLoading();
            } else {
              AppDialogs.dismissLoading();
              if (state.submittionStatus == StateStatus.failure) {
                AppDialogs.showCustomAlert(
                  context: context,
                  title: 'Failed to submit!',
                  content: state.errorMessage,
                );
              } else if (state.submittionStatus == StateStatus.successful) {
                Navigator.of(context).pop();
              }
            }
          },
          builder: (context, state) {
            // customer latlng
            LatLng _customerLatLng = LatLng(
              state.currentOrder.customerLocation.latitude,
              state.currentOrder.customerLocation.longitude,
            );
            // pick up latlng
            LatLng _pickUpLatLng = LatLng(
              state.currentOrder.pickUpLocation.latitude,
              state.currentOrder.pickUpLocation.longitude,
            );
            //driver latlng
            LatLng? _driverLatLng = state.currentOrder.driverLocation == null
                ? null
                : LatLng(
                    state.currentOrder.driverLocation!.latitude,
                    state.currentOrder.driverLocation!.longitude,
                  );

            return Stack(
              children: [
                // Map
                CustomMapView(
                  doWithMapController: (controller) {
                    _mapController = controller;
                  },
                  initialCameraLocation: _customerLatLng,
                  pickupPosition: _pickUpLatLng,
                  customerPosition: _customerLatLng,
                  driverPosition: _driverLatLng,
                ),
                // Side Buttons
                SafeArea(
                  child: SideButtonsWidget(
                    onDriverBtnTap: () {
                      // animate to driver position
                      if (_driverLatLng != null) {
                        _mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: _driverLatLng,
                              zoom: 15,
                            ),
                          ),
                        );
                      }
                    },
                    onPickUpBtnTap: () {
                      // animate to pickUp location
                      _mapController?.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: _pickUpLatLng,
                            zoom: 15,
                          ),
                        ),
                      );
                    },
                    onCustomerBtnTap: () {
                      // animate to customer location
                      _mapController?.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: _customerLatLng,
                            zoom: 15,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Bottom Sheet
                TrackingBottomSheet(
                  avatar: AssetImage(kDefaultAvatarPath),
                  column: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          context
                              .read<UserDataCubit>()
                              .state
                              .userData!
                              .fullName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      // Waiting driver..
                      state.currentOrder.orderStatus == null
                          ? WaitingDriverWidget()
                          // Tracking order..
                          : !state.currentOrder.isDelivered
                              ? TrackingTimeline(
                                  currentOrderStatus:
                                      state.currentOrder.orderStatus!,
                                )
                              // Summery
                              : TrackingSummary(
                                  initialRating: state.serviceRating.toInt(),
                                  onRatingUpdate: (rating) {
                                    context
                                        .read<TrackingCubit>()
                                        .serviceRatingChanged(
                                            rating.toDouble());
                                  },
                                  pickupTime:
                                      state.currentOrder.pickUpTime == null
                                          ? null
                                          : TimeOfDay.fromDateTime(
                                              state.currentOrder.pickUpTime!),
                                  deliveryTime:
                                      state.currentOrder.deliveryTime == null
                                          ? null
                                          : TimeOfDay.fromDateTime(
                                              state.currentOrder.deliveryTime!),
                                  totalPrice: state.currentOrder.totalPrice,
                                  onSubmit: () async {
                                    await context
                                        .read<TrackingCubit>()
                                        .submit();
                                    //! Navigation and dealing with error are done in the listener.
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
