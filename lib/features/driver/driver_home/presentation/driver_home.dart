import 'package:flutter/material.dart';
import 'package:handover/features/driver/driver_home/presentation/widgets/order_widger.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/constants.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kMainColor,
          title: Text('Handover (Driver)'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.logout),
            )
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 4.h),
            Text(
              'Pick an order and go!',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                vertical: 5.h,
                horizontal: 5.w,
              ),
              children: [
                OrderWidget(
                  customerName: 'Feras Senjab',
                  distanceByKilometers: 14.3,
                ),
                SizedBox(height: 2.h),
                OrderWidget(
                  customerName: 'Feras Senjab',
                  distanceByKilometers: 14.3,
                ),
                SizedBox(height: 2.h),
                OrderWidget(
                  customerName: 'Feras Senjab',
                  distanceByKilometers: 14.3,
                ),
              ],
            ),
          ],
        ));
  }
}
