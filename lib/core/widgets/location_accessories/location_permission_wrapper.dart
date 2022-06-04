import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:handover/core/constants.dart';
import 'package:handover/core/widgets/location_accessories/require_location_permission_screen.dart';

class LocationPermissionWrapper extends StatefulWidget {
  final Widget child;

  ///- Wrap a widget (screen) with this widget to force granting Location permission to acccess that screen.
  ///
  ///- In case Location permission isn't granted, It shows (require location permission) screen.
  LocationPermissionWrapper({
    required this.child,
  });

  @override
  State<LocationPermissionWrapper> createState() =>
      _LocationPermissionWrapperState();
}

class _LocationPermissionWrapperState extends State<LocationPermissionWrapper> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Geolocator.checkPermission(),
      builder: (context, permissionSnap) {
        if (permissionSnap.hasData) {
          if ([LocationPermission.always, LocationPermission.whileInUse]
              .contains(permissionSnap.data)) {
            return widget.child;
          } else {
            return RequireLocationPermissionScreen(onPermissionGranted: () {
              setState(() {
                // refresh
              });
            });
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: kMainColor,
              ),
            ),
          );
        }
      },
    );
  }
}
