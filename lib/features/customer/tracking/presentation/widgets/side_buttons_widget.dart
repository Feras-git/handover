import 'package:flutter/material.dart';
import 'package:handover/core/widgets/rounded_icon_button.dart';

class SideButtonsWidget extends StatelessWidget {
  final Function onDriverBtnTap;
  final Function onPickUpBtnTap;
  final Function onCustomerBtnTap;

  SideButtonsWidget({
    required this.onDriverBtnTap,
    required this.onPickUpBtnTap,
    required this.onCustomerBtnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 3),
      child: Column(
        children: [
          // Back arrow
          RoundedIconButton(
            icon: Icons.arrow_back,
            backgroundColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          SizedBox(height: 8),
          // Driver
          RoundedIconButton(
            icon: Icons.directions_bike,
            onTap: () => onDriverBtnTap(),
          ),
          SizedBox(height: 8),
          // Pickup
          RoundedIconButton(
            icon: Icons.shopping_basket,
            onTap: () => onPickUpBtnTap(),
          ),
          SizedBox(height: 8),
          // Customer
          RoundedIconButton(
            icon: Icons.location_history,
            onTap: () => onCustomerBtnTap(),
          ),
        ],
      ),
    );
  }
}
