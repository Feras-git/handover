import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:handover/core/constants.dart';
import 'package:handover/utils/app_dialogs.dart';
import 'package:sizer/sizer.dart';

class LocationEnabledWrapper extends StatefulWidget {
  final Widget child;

  ///- Wrap a widget (screen) with this widget to force enable Location service at that screen.
  ///
  ///- In case Location service is disabled, It shows an alert that requires enabling location service to view the screen.
  LocationEnabledWrapper({
    required this.child,
  });
  @override
  State<LocationEnabledWrapper> createState() => _LocationEnabledWrapperState();
}

class _LocationEnabledWrapperState extends State<LocationEnabledWrapper> {
  StreamSubscription<ServiceStatus>? _locationStatusStreamSub;
  bool _isAlertShown = false;

  /// Show | Hide custom alert upon location status..
  void _alertUponLocationStatus(bool isLocationEnabled) {
    if (!isLocationEnabled) {
      _isAlertShown = true;
      AppDialogs.showCustomContainerAsAlert(
        context: context,
        dismissible: false,
        container: Container(
          child: CustomContainerAlert(),
        ),
      );
    } else {
      if (_isAlertShown) {
        Navigator.of(context).pop();
        _isAlertShown = false;
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // Initial service status value..
    Geolocator.isLocationServiceEnabled().then((value) {
      _alertUponLocationStatus(value);
    });

    // Listen on service value changes..
    Future.delayed(Duration.zero).then((_) {
      _locationStatusStreamSub =
          Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
        _alertUponLocationStatus(status == ServiceStatus.enabled);
      });
    });
  }

  @override
  void dispose() {
    _locationStatusStreamSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class CustomContainerAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: kMainColor,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.location_on,
            size: 40.sp,
          ),
          Text(
            '\nPlease enable location service..',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
