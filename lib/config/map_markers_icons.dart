import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handover/core/constants.dart';

class MapMarkersIcons {
  static late BitmapDescriptor locationCircleMarkerIcon;
  static late BitmapDescriptor deliveryMarkerIcon;
  static late BitmapDescriptor customerMarkerIcon;
  static late BitmapDescriptor pickUpMarkerIcon;

  static Future configure() async {
    await Future.wait([
      // location circle icon
      _getBitmapDescriptor(imageAssetPath: kLocationCircleImagePath)
          .then((value) => locationCircleMarkerIcon = value),
      // delivery icon
      _getBitmapDescriptor(imageAssetPath: kDeliveryMarkerPath)
          .then((value) => deliveryMarkerIcon = value),
      // customer icon
      _getBitmapDescriptor(imageAssetPath: kCustomerMarkerPath)
          .then((value) => customerMarkerIcon = value),
      // delivery icon
      _getBitmapDescriptor(imageAssetPath: kPickUpMarkerPath)
          .then((value) => pickUpMarkerIcon = value),
    ]);
  }

  static Future<BitmapDescriptor> _getBitmapDescriptor({
    required imageAssetPath,
    int width = 120,
    int height = 120,
  }) async {
    ByteData data = await rootBundle.load(imageAssetPath);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    ui.FrameInfo fi = await codec.getNextFrame();

    Uint8List bytesFromAsset =
        (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List();
    return BitmapDescriptor.fromBytes(bytesFromAsset);
  }
}
