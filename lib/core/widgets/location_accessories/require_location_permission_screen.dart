import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:handover/core/constants.dart';
import 'package:handover/core/widgets/custom_button.dart';
import 'package:sizer/sizer.dart';

class RequireLocationPermissionScreen extends StatefulWidget {
  final Function onPermissionGranted;

  /// Wrap
  RequireLocationPermissionScreen({
    required this.onPermissionGranted,
  });

  @override
  State<RequireLocationPermissionScreen> createState() =>
      _RequireLocationPermissionScreenState();
}

class _RequireLocationPermissionScreenState
    extends State<RequireLocationPermissionScreen> {
  LocationPermission? _permission;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 20.h,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 3.w,
          ),
          decoration: BoxDecoration(
            color: kMainColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _permission != LocationPermission.deniedForever
                    ? 'The app needs to use location service to serve you, please allow location permission.'
                    : 'The app needs to use location service to serve you, but unfortunately it\'s denied permanently! please allow location permission from settings then click "Reload"',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              !_isLoading
                  ? CustomButton(
                      text: _permission != LocationPermission.deniedForever
                          ? '  Grant permission  '
                          : '  Reload  ',
                      color: Colors.white,
                      textColor: kMainColor,
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        await Geolocator.requestPermission().then((permission) {
                          setState(() {
                            _isLoading = false;
                            _permission = permission;
                          });
                        });

                        if ([
                          LocationPermission.always,
                          LocationPermission.whileInUse
                        ].contains(_permission)) {
                          widget.onPermissionGranted();
                        }
                      },
                    )
                  : CircularProgressIndicator(
                      color: Colors.white,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
