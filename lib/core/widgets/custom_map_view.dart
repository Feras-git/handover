import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handover/config/map_markers_icons.dart';

class CustomMapView extends StatefulWidget {
  /// A callback to get map controller (after map creation) so that the controller can be accessed
  final Function doWithMapController;

  final LatLng initialCameraLocation;
  final double initialCameraZoom;

  final LatLng pickupPosition;

  final LatLng customerPosition;

  /// Pass driver position to live tracking driver on map (on customer side).
  ///
  /// Pass null on driver side.
  final LatLng? driverPosition;

  /// Pass user location if you want to show user location circle.
  ///
  /// Pass null if you don't want to show user location circle.
  final LatLng? userLivePosition;

  CustomMapView({
    required this.doWithMapController(GoogleMapController controller),
    required this.initialCameraLocation,
    this.initialCameraZoom = 10,
    required this.pickupPosition,
    required this.customerPosition,
    this.driverPosition,
    this.userLivePosition,
  });

  @override
  State<CustomMapView> createState() => _CustomMapViewState();
}

class _CustomMapViewState extends State<CustomMapView> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> _markers() {
      List markersList = [];

      markersList.addAll([
        // Pickup position marker
        Marker(
          markerId: MarkerId('pickUpMarker'),
          position: widget.pickupPosition,
          draggable: false,
          flat: true,
        ),
        // Customer position marker
        Marker(
          markerId: MarkerId('customerMarker'),
          position: widget.customerPosition,
          draggable: false,
          flat: true,
        ),
        // delivery (driver) marker
        if (widget.driverPosition != null)
          Marker(
            markerId: MarkerId('driverMarker'),
            position: widget.driverPosition!,
            draggable: false,
            flat: true,
            anchor: Offset(0.5, 0.5),
            icon: MapMarkersIcons.deliveryMarkerIcon,
          ),
        // live location circle marker
        if (widget.userLivePosition != null)
          Marker(
            markerId: MarkerId('userMarker'),
            position: widget.userLivePosition!,
            draggable: false,
            flat: true,
            anchor: Offset(0.5, 0.5),
            icon: MapMarkersIcons.locationCircleMarkerIcon,
          ),
      ]);

      return Set.from(markersList);
    }

    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: widget.initialCameraLocation,
        zoom: widget.initialCameraZoom,
      ),
      zoomControlsEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        widget.doWithMapController(controller);
      },
      markers: _markers(),
    );
  }
}
