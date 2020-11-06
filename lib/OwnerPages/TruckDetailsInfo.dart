import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ownerapp/CommonPages/LoadingBody.dart';
import 'package:ownerapp/DialogScreens/DialogFailed.dart';
import 'package:ownerapp/DialogScreens/DialogProcessing.dart';
import 'package:ownerapp/DialogScreens/DialogSuccess.dart';
import 'package:ownerapp/Models/Truck.dart';
import 'package:ownerapp/Models/User.dart';
import 'package:ownerapp/MyConstants.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../HttpHandler.dart';

class TruckDetailsInfo extends StatefulWidget {
  final List args;

  TruckDetailsInfo(this.args);

  @override
  _TruckDetailsInfoState createState() => _TruckDetailsInfoState();
}

class _TruckDetailsInfoState extends State<TruckDetailsInfo> {
  Map docs;
  File roadTax;
  File rtoPass;
  File insurance;
  File rc;
  bool imageDone;
  UserOwner owner;
  Truck truck;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> getNewRoadTax() async {
    roadTax = await FilePicker.getFile();
    if (roadTax.existsSync()) {
      imageDone = true;
      setState(() {});
    }
  }

  Future<void> getNewRTOPass() async {
    rtoPass = await FilePicker.getFile();
    if (rtoPass.existsSync()) {
      imageDone = true;
      setState(() {});
    }
  }

  Future<void> getNewInsurance() async {
    insurance = await FilePicker.getFile();
    if (insurance.existsSync()) {
      imageDone = true;
      setState(() {});
    }
  }

  Future<void> getNewRc() async {
    rc = await FilePicker.getFile();
    if (rc.existsSync()) {
      imageDone = true;
      setState(() {});
    }
  }

  void reloadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    HTTPHandler().registerVerifyOtpOwner(
        [owner.oPhone, prefs.getString('otp'), true]).then((value) {
      HTTPHandler().truckDoc(truck.truckId).then((value1) {
        print(value1);
        setState(() {
          this.owner = value;
          docs = value1;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    truck = widget.args[0];
    owner = widget.args[1];
    HTTPHandler().truckDoc(truck.truckId).then((value) {
      print('doc => $value');
      setState(() {
        docs = value;
      });
    });
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

  void updateImage(int val) {
    String key, filePath;

    switch (val) {
      case 1:
        key = 'trk_road_tax_edit';
        filePath = roadTax.path.toString();
        break;

      case 2:
        key = 'trk_rto_edit';
        filePath = rtoPass.path.toString();
        break;

      case 3:
        key = 'trk_insurance_edit';
        filePath = insurance.path.toString();
        break;

      case 4:
        key = 'trk_rc_edit';
        filePath = rc.path.toString();
        break;
    }

    DialogProcessing().showCustomDialog(context,
        title: "Updating Docs", text: "Processing, Please Wait!");
    HTTPHandler()
        .editTruckImage([truck.truckId, key, filePath]).then((value) async {
      Navigator.pop(context);
      if (value.success) {
        imageCache.clear();
        imageCache.clearLiveImages();
        DialogSuccess().showCustomDialog(context, title: "Updating Docs");
        await Future.delayed(Duration(seconds: 1), () {});
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        DialogFailed().showCustomDialog(context,
            title: "Updating Docs", text: value.message);
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      }
    }).catchError((error) async {
      print(error);
      Navigator.pop(context);
      DialogFailed().showCustomDialog(context,
          title: "Updating Docs", text: "Network Error");
      await Future.delayed(Duration(seconds: 3), () {});
      Navigator.pop(context);
    });
  }

  Future<void> _getData() async {
    reloadUser();

    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('My Trucks'),
      ),
      body: (docs == null)
          ? LoadingBody()
          : SmartRefresher(
              onRefresh: _getData,
              controller: _refreshController,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 15.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                truck.truckNumber,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0,
                                ),
                              ),
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
                          ),
                          GestureDetector(
                            onTap: () {
                              print("Edit");
                              Navigator.pushNamed(context, editTrucksOwner,
                                  arguments: {"truck": truck, "state": this});
                            },
                            child: Container(
                              width: 100.0,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.black,
                              ),
                              child: Text(
                                'Edit',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.0),
                      Row(
                        children: [
                          Text(
                            "Driver Name",
                            style: TextStyle(
                                color: Colors.blueGrey.withOpacity(0.9)),
                          ),
                          Spacer(),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 10.0,
                              ),
                              child: Text(docs['driver name']),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Driver Phone",
                            style: TextStyle(
                                color: Colors.blueGrey.withOpacity(0.9)),
                          ),
                          Spacer(),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 10.0,
                              ),
                              child: Text(docs['driver phone']),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Category",
                            style: TextStyle(
                                color: Colors.blueGrey.withOpacity(0.9)),
                          ),
                          Spacer(),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 10.0,
                              ),
                              child: Text(
                                  '${docs['truck category']} ( ${docs['truck type']} )'),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Driver Selfie",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.blueGrey.withOpacity(0.9)),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Stack(
                        children: [
                          Container(
                            height: 250.0,
                            width: double.infinity,
                            child: PhotoView(
                              maxScale: PhotoViewComputedScale.contained,
                              imageProvider: NetworkImage(
                                  'https://truckwale.co.in/${docs['selfie']}'),
                              backgroundDecoration:
                                  BoxDecoration(color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 100.0,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.black,
                              ),
                              child: Text(
                                (docs['selfie verified'] == '1')
                                    ? 'Verified'
                                    : 'Not Verified',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Driver License",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.blueGrey.withOpacity(0.9)),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Stack(
                        children: [
                          Container(
                            height: 250.0,
                            width: double.infinity,
                            child: PhotoView(
                              maxScale: PhotoViewComputedScale.contained,
                              imageProvider: NetworkImage(
                                  'https://truckwale.co.in/${docs['license']}'),
                              backgroundDecoration:
                                  BoxDecoration(color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 100.0,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.black,
                              ),
                              child: Text(
                                (docs['license verified'] == '1')
                                    ? 'Verified'
                                    : 'Not Verified',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "RC",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.blueGrey.withOpacity(0.9)),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Stack(
                        children: [
                          Container(
                            height: 250.0,
                            width: double.infinity,
                            child: PhotoView(
                              maxScale: PhotoViewComputedScale.contained,
                              imageProvider: (rc == null)
                                  ? NetworkImage(
                                      'https://truckwale.co.in/${docs['rc']}')
                                  : FileImage(rc),
                              backgroundDecoration:
                                  BoxDecoration(color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 100.0,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.black,
                              ),
                              child: Text(
                                (docs['rc verified'] == '1')
                                    ? 'Verified'
                                    : 'Not Verified',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            height: 250.0,
                            width: double.infinity,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () =>
                                    (rc == null) ? getNewRc() : updateImage(4),
                                child: Container(
                                  width: 100.0,
                                  height: 30.0,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(5.0),
                                  margin: const EdgeInsets.only(bottom: 3.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 0.3,
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Text(
                                    (rc == null) ? 'Edit' : 'Update',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Insaurance",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.blueGrey.withOpacity(0.9)),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Stack(
                        children: [
                          Container(
                            height: 250.0,
                            width: double.infinity,
                            child: PhotoView(
                              maxScale: PhotoViewComputedScale.contained,
                              imageProvider: (insurance == null)
                                  ? NetworkImage(
                                      'https://truckwale.co.in/${docs['insurance']}')
                                  : FileImage(insurance),
                              backgroundDecoration:
                                  BoxDecoration(color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 100.0,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.black,
                              ),
                              child: Text(
                                (docs['insurance verified'] == '1')
                                    ? 'Verified'
                                    : 'Not Verified',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            height: 250.0,
                            width: double.infinity,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () => (insurance == null)
                                    ? getNewInsurance()
                                    : updateImage(3),
                                child: Container(
                                  width: 100.0,
                                  height: 30.0,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(5.0),
                                  margin: const EdgeInsets.only(bottom: 3.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 0.3,
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Text(
                                    (insurance == null) ? 'Edit' : 'Update',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "RTO Pass",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.blueGrey.withOpacity(0.9)),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Stack(
                        children: [
                          Container(
                            height: 250.0,
                            width: double.infinity,
                            child: PhotoView(
                              maxScale: PhotoViewComputedScale.contained,
                              imageProvider: (rtoPass == null)
                                  ? NetworkImage(
                                      'https://truckwale.co.in/${docs['rto pass']}')
                                  : FileImage(rtoPass),
                              backgroundDecoration:
                                  BoxDecoration(color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 100.0,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.black,
                              ),
                              child: Text(
                                (docs['rto pass verified'] == '1')
                                    ? 'Verified'
                                    : 'Not Verified',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            height: 250.0,
                            width: double.infinity,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () => (rtoPass == null)
                                    ? getNewRTOPass()
                                    : updateImage(2),
                                child: Container(
                                  width: 100.0,
                                  height: 30.0,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(5.0),
                                  margin: const EdgeInsets.only(bottom: 3.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 0.3,
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Text(
                                    (rtoPass == null) ? 'Edit' : 'Update',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Road Tax",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.blueGrey.withOpacity(0.9)),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Stack(
                        children: [
                          Container(
                            height: 250.0,
                            width: double.infinity,
                            child: PhotoView(
                              maxScale: PhotoViewComputedScale.contained,
                              imageProvider: (roadTax == null)
                                  ? NetworkImage(
                                      'https://truckwale.co.in/${docs['road tax']}',
                                    )
                                  : FileImage(roadTax),
                              backgroundDecoration:
                                  BoxDecoration(color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 100.0,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.black,
                              ),
                              child: Text(
                                (docs['road tax verified'] == '1')
                                    ? 'Verified'
                                    : 'Not Verified',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            height: 250.0,
                            width: double.infinity,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () => (roadTax == null)
                                    ? getNewRoadTax()
                                    : updateImage(1),
                                child: Container(
                                  width: 100.0,
                                  height: 30.0,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(5.0),
                                  margin: const EdgeInsets.only(bottom: 3.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 0.3,
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Text(
                                    (roadTax == null) ? 'Edit' : 'Update',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
