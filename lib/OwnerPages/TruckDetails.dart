import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ownerapp/Models/Truck.dart';
import 'package:ownerapp/Models/User.dart';

import '../HttpHandler.dart';

class TruckDetails extends StatefulWidget {
  final List args;

  TruckDetails({
    Key key,
    @required this.args,
  }) : super(key: key);

  @override
  _TruckDetailsState createState() => _TruckDetailsState();
}

class _TruckDetailsState extends State<TruckDetails> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _mapController;
  UserOwner userOwner;
  Truck truck;

  String time = '';

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
    userOwner = widget.args[0];
    truck = widget.args[1];
    // _onAddMarkerButtonPressed();
    HTTPHandler().getLoc(truck.truckId).then((value) {
      _lastMapPosition = value[0];
      _onAddMarkerButtonPressed();
      // _mapController.moveCamera(CameraUpdate.newLatLng(value));
      _mapController.animateCamera(CameraUpdate.newLatLng(value[0]));
      setState(() {
        time = value[1];
      });
    });
    Timer.periodic(Duration(seconds: 1), (timer) {
      HTTPHandler().getLoc(truck.truckId).then((value) {
        _lastMapPosition = value[0];
        _onAddMarkerButtonPressed();
        // _mapController.moveCamera(CameraUpdate.newLatLng(value));
        _mapController.animateCamera(CameraUpdate.newLatLng(value[0]));
        setState(() {
          time = value[1];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Truck Details'),
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
                Hero(
                  tag: truck,
                  child: Text(
                    truck.truckNumber,
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  '${truck.truckCat} ( ${truck.truckCatType} )',
                  style: TextStyle(fontSize: 15.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Last updated at $time ',
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
