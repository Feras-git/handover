import 'package:flutter/material.dart';
import 'package:handover/core/constants.dart';
import 'package:handover/core/widgets/custom_button.dart';

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
            onPressed: () {},
            icon: Icon(Icons.logout),
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
