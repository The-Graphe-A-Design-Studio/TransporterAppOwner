import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ownerapp/DialogScreens/DialogImageTruckDocsOwner.dart';
import 'package:ownerapp/Models/Truck.dart';
import 'package:ownerapp/Models/User.dart';

import '../HttpHandler.dart';
import '../MyConstants.dart';

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
      _lastMapPosition = value;
      _onAddMarkerButtonPressed();
      _mapController.moveCamera(CameraUpdate.newLatLng(value));
    });
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      HTTPHandler().getLoc(truck.truckId).then((value) {
        _lastMapPosition = value;
        _onAddMarkerButtonPressed();
        _mapController.moveCamera(CameraUpdate.newLatLng(value));
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
                zoom: 18.0,
              ),
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: _onCameraMove,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xff252427)),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 4.0, right: 20.0, left: 20.0, bottom: 4.0),
                        child: Text("Category : " + truck.truckCat.toString()),
                      ),
                    ),
                    Spacer(),
                    Switch(
                      value: truck.truckActive,
                      onChanged: (value) {
                        print(value);
                        postChangeTruckStatusRequest(
                            context, value == true ? "1" : "0");
                      },
                      inactiveTrackColor: Colors.red.withOpacity(0.6),
                      activeTrackColor: Colors.green.withOpacity(0.6),
                      activeColor: Colors.white,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                SizedBox(height: 20.0),
                Row(
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
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        print("Edit");
                        Navigator.pushNamed(context, editTrucksOwner,
                            arguments: {"truck": truck, "state": this});
                      },
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Text("Edit"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void postChangeTruckStatusRequest(
      BuildContext _context, String status) async {
    HTTPHandler().changeTruckStatus([truck.truckId, status]).then((value) {
      setState(() {
        truck.truckActive = status == "1" ? true : false;
      });
    }).catchError((error) {
      print("Error?? " + error.toString());
      Scaffold.of(_context).showSnackBar(SnackBar(
        backgroundColor: Colors.black,
        content: Text("Network Error"),
        duration: Duration(seconds: 2),
      ));
    });
  }
}
