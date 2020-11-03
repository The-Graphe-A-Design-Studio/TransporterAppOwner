import 'package:flutter/material.dart';
import 'package:ownerapp/DialogScreens/DialogFailed.dart';
import 'package:ownerapp/DialogScreens/DialogProcessing.dart';
import 'package:ownerapp/DialogScreens/DialogSuccess.dart';
import 'package:ownerapp/HttpHandler.dart';
import 'package:ownerapp/Models/Bid.dart';
import 'package:ownerapp/Models/User.dart';
import 'package:ownerapp/MyConstants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class MyBidspage extends StatefulWidget {
  final UserOwner userOwner;

  MyBidspage({Key key, @required this.userOwner}) : super(key: key);

  @override
  _MyBidspageState createState() => _MyBidspageState();
}

class _MyBidspageState extends State<MyBidspage> {
  List<Bid1> bids;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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

  void _onRefresh(BuildContext context) async {
    print('working properly');
    getBids();
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
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
              ? SmartRefresher(
                  controller: _refreshController,
                  onRefresh: () => _onRefresh(context),
                  child: Center(
                      child: Text(
                    'No Bids Yet!',
                    style: TextStyle(color: Colors.white),
                  )),
                )
              : SmartRefresher(
                  controller: _refreshController,
                  onRefresh: () => _onRefresh(context),
                  child: Column(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 15.0,
                                        height: 15.0,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.green[600],
                                            width: 3.0,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      Flexible(
                                        child: Text(
                                          '${e.load.sources[0].source}',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                      vertical: 3.0,
                                    ),
                                    height: 16.0,
                                    width: 1.5,
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 15.0,
                                        height: 15.0,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.red[600],
                                            width: 3.0,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      Flexible(
                                        child: Text(
                                          '${e.load.destinations[e.load.destinations.length - 1].destination}',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30.0),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Truck Type',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          SizedBox(height: 8.0),
                                          Text(
                                            '${e.load.truckPreferences}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 20.0),
                                      Text(
                                        '${e.load.truckTypes[0]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Products',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          SizedBox(height: 8.0),
                                          Text(
                                            '${e.load.material}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Bid Status',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          SizedBox(height: 8.0),
                                          Text(
                                            '${e.bidStatusMessage}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 30.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Bid Price',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          SizedBox(height: 8.0),
                                          Text(
                                            '${e.bidPrice}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Created On',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          SizedBox(height: 8.0),
                                          Text(
                                            '${e.load.createdOn}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 30.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Expires On',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          SizedBox(height: 8.0),
                                          Text(
                                            '${e.load.expiredOn}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (widget.userOwner
                                                  .oSubscriptionStatus ==
                                              'In subscription period') {
                                            print('call');
                                            UrlLauncher.launch(
                                                "tel:${e.load.contactPersonPhone}");
                                          } else {
                                            Toast.show(
                                              'Active Subscription Plan Required',
                                              context,
                                              gravity: Toast.CENTER,
                                              duration: Toast.LENGTH_SHORT,
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.call),
                                            SizedBox(width: 5.0),
                                            Text('${e.load.contactPerson}'),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {
                                                DialogProcessing().showCustomDialog(
                                                    context,
                                                    title: "Accepting Bid",
                                                    text:
                                                        "Processing, Please Wait!");
                                                HTTPHandler()
                                                    .acceptBid(e.bidId)
                                                    .then((value) async {
                                                  Navigator.pop(context);
                                                  if (value.success) {
                                                    DialogSuccess()
                                                        .showCustomDialog(
                                                            context,
                                                            title:
                                                                "Accepting Bid");
                                                    await Future.delayed(
                                                        Duration(seconds: 1),
                                                        () {});
                                                    Navigator.pop(context);
                                                    // Navigator.pop(context);
                                                    Navigator.popAndPushNamed(
                                                        context,
                                                        myDeliveriesOwner,
                                                        arguments:
                                                            widget.userOwner);
                                                  } else {
                                                    DialogFailed()
                                                        .showCustomDialog(
                                                            context,
                                                            title:
                                                                "Accepting Bid",
                                                            text:
                                                                value.message);
                                                    await Future.delayed(
                                                        Duration(seconds: 3),
                                                        () {});
                                                    Navigator.pop(context);
                                                  }
                                                }).catchError((error) async {
                                                  print(error);
                                                  Navigator.pop(context);
                                                  DialogFailed()
                                                      .showCustomDialog(context,
                                                          title:
                                                              "Accepting Truck",
                                                          text:
                                                              "Network Error");
                                                  await Future.delayed(
                                                      Duration(seconds: 3),
                                                      () {});
                                                  Navigator.pop(context);
                                                });
                                              },
                                            ),
                                          SizedBox(width: 10.0),
                                          FlatButton.icon(
                                            color: Colors.black87,
                                            icon: Icon(
                                              Icons.cancel_outlined,
                                              color: Colors.white,
                                            ),
                                            label: Text(
                                              'Remove',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              DialogProcessing().showCustomDialog(
                                                  context,
                                                  title: "Removing Bid",
                                                  text:
                                                      "Processing, Please Wait!");
                                              HTTPHandler()
                                                  .removeBid(e.bidId)
                                                  .then((value) async {
                                                Navigator.pop(context);
                                                if (value.success) {
                                                  DialogSuccess()
                                                      .showCustomDialog(context,
                                                          title:
                                                              "Removing Bid");
                                                  await Future.delayed(
                                                      Duration(seconds: 1),
                                                      () {});
                                                  Navigator.pop(context);
                                                  getBids();
                                                  // Navigator.pop(context);
                                                } else {
                                                  DialogFailed()
                                                      .showCustomDialog(context,
                                                          title: "Removing Bid",
                                                          text: value.message);
                                                  await Future.delayed(
                                                      Duration(seconds: 3),
                                                      () {});
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
                                                    Duration(seconds: 3),
                                                    () {});
                                                Navigator.pop(context);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
    );
  }
}
