import 'package:flutter/material.dart';
import 'package:handover/core/widgets/location_accessories/location_enabled_wrapper.dart';
import 'package:handover/core/widgets/location_accessories/location_permission_wrapper.dart';

class LocationGrantedEnabledWrapper extends StatelessWidget {
  final Widget child;

  ///- Wrap a widget (screen) with this widget to force the following conditions in order to access the screen:
  ///
  ///   * Location permission allowance.
  ///
  ///   * Location service enabled.
  ///
  ///- It will show a (require location permission screen) in case permession is denied.
  ///
  ///- It will show a dialog requiring enable location service in case the service was disabled.
  LocationGrantedEnabledWrapper({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LocationPermissionWrapper(
      child: LocationEnabledWrapper(
        child: child,
      ),
    );
  }
}
