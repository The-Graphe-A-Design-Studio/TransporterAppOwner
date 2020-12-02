import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
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
      appBar: AppBar(
        title: Text('Driver Location'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 2 / 3,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 20.0,
              ),
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: _onCameraMove,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.deliveryTruck.truckNumber,
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  '${widget.deliveryTruck.driverName} ( ${widget.deliveryTruck.driverPhone} )',
                  style: TextStyle(fontSize: 15.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Last updated at ${DateFormat.yMEd().add_jms().format(DateTime.now())} ',
                  style: TextStyle(fontSize: 15.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
