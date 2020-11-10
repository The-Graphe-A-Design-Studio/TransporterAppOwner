import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ownerapp/HttpHandler.dart';
import 'package:ownerapp/Models/Deliveries.dart';

class DriverLocation extends StatefulWidget {
  final DeliveryTruck deliveryTruck;

  DriverLocation({this.deliveryTruck});

  @override
  _DriverLocationState createState() => _DriverLocationState();
}

class _DriverLocationState extends State<DriverLocation> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _mapController;
  static const LatLng _center = const LatLng(22.62739470, 88.40363220);
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;
  final Set<Marker> _markers = {};

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        icon: BitmapDescriptor.fromAsset(
          'assets/icon/map.png',
        ),
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    _mapController = controller;
  }

  @override
  void initState() {
    super.initState();

    HTTPHandler().getDelLoc(widget.deliveryTruck.deleteTruckId).then((value) {
      _lastMapPosition = value;
      _onAddMarkerButtonPressed();
      _mapController.animateCamera(CameraUpdate.newLatLng(value));
    });
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      HTTPHandler().getDelLoc(widget.deliveryTruck.deleteTruckId).then((value) {
        _lastMapPosition = value;
        _onAddMarkerButtonPressed();
        _mapController.animateCamera(CameraUpdate.newLatLng(value));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 18.0,
              ),
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: _onCameraMove,
            ),
          ),
        ],
      ),
    );
  }
}
