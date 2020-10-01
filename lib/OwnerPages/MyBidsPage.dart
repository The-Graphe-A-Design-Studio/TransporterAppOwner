import 'package:flutter/material.dart';
import 'package:ownerapp/DialogScreens/DialogFailed.dart';
import 'package:ownerapp/DialogScreens/DialogProcessing.dart';
import 'package:ownerapp/DialogScreens/DialogSuccess.dart';
import 'package:ownerapp/HttpHandler.dart';
import 'package:ownerapp/Models/Bid.dart';
import 'package:ownerapp/Models/User.dart';

class MyBidspage extends StatefulWidget {
  final UserOwner userOwner;

  MyBidspage({Key key, @required this.userOwner}) : super(key: key);

  @override
  _MyBidspageState createState() => _MyBidspageState();
}

class _MyBidspageState extends State<MyBidspage> {
  List<Bid1> bids;

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

  void getBids() {
    HTTPHandler().getMyBids(widget.userOwner.oId).then((value) {
      setState(() {
        bids = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getBids();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bids'),
      ),
      body: (bids == null)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : (bids.length == 0)
              ? Center(
                  child: Text(
                  'No Bids Yet!',
                  style: TextStyle(color: Colors.white),
                ))
              : Column(
                  children: bids
                      .map((e) => Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10.0,
                            ),
                            padding: const EdgeInsets.all(10.0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              children: [
                                item('From',
                                    '${e.load.sources[0].source.substring(0, 20)}...'),
                                item('To',
                                    '${e.load.destinations[e.load.destinations.length - 1].destination.substring(0, 20)}...'),
                                item('Material', '${e.load.material}'),
                                item('Tonnage', '${e.load.tonnage}'),
                                item('Truck Preferences',
                                    '${e.load.truckPreferences}'),
                                item('Expected Price',
                                    '${e.load.expectedPrice}'),
                                item('Payment Mode', '${e.load.paymentMode}'),
                                item('Created On', '${e.load.createdOn}'),
                                item('Expired On', '${e.load.expiredOn}'),
                                item('Contact Person',
                                    '${e.load.contactPerson}'),
                                item('Contact Person Phone No.',
                                    '${e.load.contactPersonPhone}'),
                                Divider(),
                                item('Bid Status', '${e.bidStatusMessage}'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (e.bidStatus == '2')
                                      FlatButton.icon(
                                        color: Colors.black87,
                                        icon: Icon(
                                          Icons.done,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          'Accept',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          DialogProcessing().showCustomDialog(
                                              context,
                                              title: "Accepting Bid",
                                              text: "Processing, Please Wait!");
                                          HTTPHandler()
                                              .acceptBid(e.bidId)
                                              .then((value) async {
                                            Navigator.pop(context);
                                            if (value.success) {
                                              DialogSuccess().showCustomDialog(
                                                  context,
                                                  title: "Accepting Bid");
                                              await Future.delayed(
                                                  Duration(seconds: 1), () {});
                                              Navigator.pop(context);
                                              // getBids();
                                              Navigator.pop(context);
                                            } else {
                                              DialogFailed().showCustomDialog(
                                                  context,
                                                  title: "Accepting Bid",
                                                  text: value.message);
                                              await Future.delayed(
                                                  Duration(seconds: 3), () {});
                                              Navigator.pop(context);
                                            }
                                          }).catchError((error) async {
                                            print(error);
                                            Navigator.pop(context);
                                            DialogFailed().showCustomDialog(
                                                context,
                                                title: "Accepting Truck",
                                                text: "Network Error");
                                            await Future.delayed(
                                                Duration(seconds: 3), () {});
                                            Navigator.pop(context);
                                          });
                                        },
                                      ),
                                    SizedBox(width: 30.0),
                                    FlatButton.icon(
                                      color: Colors.black87,
                                      icon: Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        'Remove',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        DialogProcessing().showCustomDialog(
                                            context,
                                            title: "Removing Bid",
                                            text: "Processing, Please Wait!");
                                        HTTPHandler()
                                            .removeBid(e.bidId)
                                            .then((value) async {
                                          Navigator.pop(context);
                                          if (value.success) {
                                            DialogSuccess().showCustomDialog(
                                                context,
                                                title: "Removing Bid");
                                            await Future.delayed(
                                                Duration(seconds: 1), () {});
                                            Navigator.pop(context);
                                            getBids();
                                            // Navigator.pop(context);
                                          } else {
                                            DialogFailed().showCustomDialog(
                                                context,
                                                title: "Removing Bid",
                                                text: value.message);
                                            await Future.delayed(
                                                Duration(seconds: 3), () {});
                                            Navigator.pop(context);
                                          }
                                        }).catchError((error) async {
                                          print(error);
                                          Navigator.pop(context);
                                          DialogFailed().showCustomDialog(
                                              context,
                                              title: "Removing Truck",
                                              text: "Network Error");
                                          await Future.delayed(
                                              Duration(seconds: 3), () {});
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
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
