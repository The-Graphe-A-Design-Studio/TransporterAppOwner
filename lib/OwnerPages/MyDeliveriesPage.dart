import 'package:flutter/material.dart';
import 'package:ownerapp/DialogScreens/DialogFailed.dart';
import 'package:ownerapp/DialogScreens/DialogProcessing.dart';
import 'package:ownerapp/DialogScreens/DialogSuccess.dart';
import 'package:ownerapp/HttpHandler.dart';
import 'package:ownerapp/Models/Deliveries.dart';
import 'package:ownerapp/Models/Truck.dart';
import 'package:ownerapp/Models/User.dart';

class MyDeliveriesPage extends StatefulWidget {
  final UserOwner userOwner;

  MyDeliveriesPage({Key key, @required this.userOwner}) : super(key: key);

  @override
  _MyDeliveriesPageState createState() => _MyDeliveriesPageState();
}

class _MyDeliveriesPageState extends State<MyDeliveriesPage> {
  List<Delivery> myDeliveries;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var selectedTruck = '';
  List<Truck> trucks = [];

  Widget item(String title, String value) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(
                value,
                style: TextStyle(fontWeight: FontWeight.w500),
              )
            ],
          ),
          SizedBox(height: 5.0),
        ],
      );

  void getTrucks() {
    HTTPHandler().viewAllTrucks([widget.userOwner.oId]).then((value) {
      setState(() {
        trucks = value;
      });
    });
  }

  bool canAssign(Delivery d) {
    print('running');
    if (d.priceUnit != 'number of trucks')
      return true;
    else {
      int trucksRequired = int.parse(d.quantity);
      int availableTrucks = 0;

      for (Truck t in trucks) {
        if (t.truckActive && !t.truckOnTrip) availableTrucks++;
      }

      print('reqd => $trucksRequired');
      print('ava => $availableTrucks');

      return (trucksRequired <= availableTrucks) ? true : false;
    }
  }

  void assignTruck(BuildContext context, Delivery d) {
    List<int> trucksSelected;

    trucksSelected = List.generate(trucks.length, (index) => -1);

    print('sheet');
    scaffoldKey.currentState.showBottomSheet(
      (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter state) => Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                    children: trucks
                        .map((e) => (e.truckOnTrip)
                            ? Container()
                            : CheckboxListTile(
                                title: Text(
                                  e.truckNumber,
                                  style: TextStyle(color: Colors.black),
                                ),
                                value: trucksSelected[trucks.indexOf(e)] == -1
                                    ? false
                                    : true,
                                onChanged: (bool val) {
                                  print('value => $val');
                                  state(() {
                                    trucksSelected[trucks.indexOf(e)] =
                                        val ? int.parse(e.truckId) : -1;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                checkColor: Colors.black,
                              ))
                        .toList()),
                GestureDetector(
                  onTap: () {
                    print('assign now');
                    String ids = '';
                    for (int b in trucksSelected) {
                      if (b != -1) ids += '$b* ';
                    }
                    print(ids);
                    String filterdIds = ids.substring(0, ids.length - 2);
                    print(filterdIds);
                    DialogProcessing().showCustomDialog(context,
                        title: "Assigning Truck",
                        text: "Processing, Please Wait!");
                    HTTPHandler().assignTruckForDelivery([
                      d.deliveryId,
                      filterdIds,
                    ]).then((value) async {
                      Navigator.pop(context);
                      if (value.success) {
                        DialogSuccess().showCustomDialog(context,
                            title: "Assigning Truck");
                        await Future.delayed(Duration(seconds: 1), () {});
                        Navigator.pop(context);
                        Navigator.of(context).pop();
                        getDeliveries();
                      } else {
                        DialogFailed().showCustomDialog(context,
                            title: "Assigning Truck", text: value.message);
                        await Future.delayed(Duration(seconds: 3), () {});
                        Navigator.pop(context);
                        Navigator.of(context).pop();
                      }
                    }).catchError((error) async {
                      print(error);
                      Navigator.pop(context);
                      DialogFailed().showCustomDialog(context,
                          title: "Assigning Truck", text: "Network Error");
                      await Future.delayed(Duration(seconds: 3), () {});
                      Navigator.pop(context);
                      Navigator.of(context).pop();
                    });
                  },
                  child: Container(
                    height: 50.0,
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'ASSIGN',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void deleteTruck(Delivery d) {
    DialogProcessing().showCustomDialog(context,
        title: "Deleting Truck", text: "Processing, Please Wait!");
    HTTPHandler().removeTruck([d.deliveryId]).then((value) async {
      Navigator.pop(context);
      if (value.success) {
        DialogSuccess().showCustomDialog(context, title: "Deleting Truck");
        await Future.delayed(Duration(seconds: 1), () {});
        Navigator.pop(context);
        getDeliveries();
      } else {
        DialogFailed().showCustomDialog(context,
            title: "Deleting Truck", text: value.message);
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      }
    }).catchError((error) async {
      print(error);
      Navigator.pop(context);
      DialogFailed().showCustomDialog(context,
          title: "Deleting Truck", text: "Network Error");
      await Future.delayed(Duration(seconds: 3), () {});
      Navigator.pop(context);
    });
  }

  void getDeliveries() {
    HTTPHandler().getMyDeliveries([widget.userOwner.oId]).then((value) {
      setState(() {
        myDeliveries = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getDeliveries();
    getTrucks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('My Deliveries'),
      ),
      body: (myDeliveries == null)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Column(
              children: myDeliveries
                  .map((e) => Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: [
                            item('Delivery ID', e.deliveryId),
                            item('Price Unit', e.priceUnit),
                            item('Quantity', e.quantity),
                            item('Deal Price', e.dealPrice),
                            item('Total Price', e.totalPrice),
                            item('Load material', e.load.material),
                            item('Contact Person', e.load.contactPerson),
                            item('Contact Person Phone No.',
                                e.load.contactPersonPhone),
                            Divider(),
                            (e.deliveryTrucksStatus == '0')
                                ? (canAssign(e))
                                    ? Align(
                                        alignment: Alignment.centerRight,
                                        child: RaisedButton.icon(
                                          color: Colors.black,
                                          icon: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          label: Text(
                                            'Add Truck',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () {
                                            assignTruck(context, e);
                                          },
                                        ),
                                      )
                                    : item(
                                        "Sufficient Trucks not available!", '')
                                : Column(
                                    children: e.deliveryTrucks
                                        .map(
                                          (d) => Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text('Truck Assigned'),
                                                      GestureDetector(
                                                        onTap: () =>
                                                            deleteTruck(e),
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    '${d.driverName} (${d.truckNumber})',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 5.0),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
    );
  }
}
