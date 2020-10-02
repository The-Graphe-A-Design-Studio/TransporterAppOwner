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

  void assignTruck(BuildContext context, Delivery d) {
    List<Truck> trucks = [];
    HTTPHandler().viewAllTrucks([widget.userOwner.oId]).then((value) {
      trucks = value;
      print('sheet');
      scaffoldKey.currentState.showBottomSheet(
        (BuildContext context) => Container(
          child: SingleChildScrollView(
            child: Column(
                children: value
                    .map((e) => RadioListTile(
                        value: e.truckId,
                        groupValue: selectedTruck,
                        title: Text(e.truckNumber),
                        onChanged: (String newVal) {
                          print(newVal);

                          DialogProcessing().showCustomDialog(context,
                              title: "Assigning Truck",
                              text: "Processing, Please Wait!");
                          HTTPHandler().assignTruckForDelivery([
                            d.deliveryId,
                            newVal,
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
                                  title: "Assigning Truck",
                                  text: value.message);
                              await Future.delayed(Duration(seconds: 3), () {});
                              Navigator.pop(context);
                              Navigator.of(context).pop();
                            }
                          }).catchError((error) async {
                            print(error);
                            Navigator.pop(context);
                            DialogFailed().showCustomDialog(context,
                                title: "Assigning Truck",
                                text: "Network Error");
                            await Future.delayed(Duration(seconds: 3), () {});
                            Navigator.pop(context);
                            Navigator.of(context).pop();
                          });
                        }))
                    .toList()),
          ),
        ),
        backgroundColor: Colors.white,
      );
    });
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
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        assignTruck(context, e);
                                      },
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text('Truck Assigned'),
                                              GestureDetector(
                                                onTap: () => deleteTruck(e),
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '${e.deliveryTrucks[0].driverName} (${e.deliveryTrucks[0].truckNumber})',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 5.0),
                                    ],
                                  ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
    );
  }
}
