import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handover/core/constants.dart';
import 'package:handover/core/enums.dart';
import 'package:handover/core/models/product.dart';
import 'package:handover/core/widgets/custom_button.dart';
import 'package:handover/core/widgets/location_accessories/location_granted_enabled_wrapper.dart';
import 'package:handover/features/auth/login/presentation/login_screen.dart';
import 'package:handover/features/auth/logout/cubit/logout_cubit.dart';
import 'package:handover/features/auth/user_data/user_data_cubit.dart';
import 'package:handover/features/customer/cubit/customer_cubit.dart';
import 'package:handover/features/customer/customer_home/presentation/widgets/select_product_widget.dart';
import 'package:handover/repositories/orders_repository/orders_repository.dart';
import 'package:handover/utils/app_dialogs.dart';
import 'package:sizer/sizer.dart';

class CustomerHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Product? _selectedProduct;
    return LocationGrantedEnabledWrapper(
      child: Scaffold(
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
        body: BlocProvider<CustomerCubit>(
          create: (BuildContext context) => CustomerCubit(
            userDataCubit: context.read<UserDataCubit>(),
            ordersRepository: context.read<OrdersRepository>(),
          ),
          child: BlocConsumer<CustomerCubit, CustomerState>(
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: state.currentOrder == null,
                      child: Column(
                        children: [
                          Text(
                            'Select your package',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                          SelectProductWidget(
                            productsList: [
                              Product(name: 'Samsung Galaxy A31', price: 215),
                              Product(name: 'Apple MacBook Pro', price: 1300),
                              Product(name: 'Sony PlayStation 5', price: 735),
                            ],
                            onChanged: (value) {
                              _selectedProduct = value;
                            },
                          ),
                        ],
                      ),
                    ),
                    CustomButton(
                      text: state.currentOrder == null
                          ? '  Get my package to my location  '
                          : ' You already have an order, track it! ',
                      onPressed: () async {
                        if (state.currentOrder == null) {
                          if (_selectedProduct == null) {
                            AppDialogs.showCustomAlert(
                                context: context,
                                title: 'Missed selecting package',
                                content: 'Please select your package first!');
                          } else {
                            await context
                                .read<CustomerCubit>()
                                .addNewOrder(
                                  product: _selectedProduct!,
                                )
                                .then((_) {
                              if (state.stateStatus == StateStatus.successful) {
                                //TODO
                              }
                            });
                          }
                        } else {
                          //TODO
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
