import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    HTTPHandler().getMyBids(widget.userOwner.oId).then((value) {
      setState(() {
        bids = value;
      });
    });
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
                            height: 310.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('From'),
                                    Text(
                                      '${e.load.sources[0].source.substring(0, 20)}...',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('To'),
                                    Text(
                                      '${e.load.destinations[e.load.destinations.length - 1].destination.substring(0, 20)}...',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Material'),
                                    Text(
                                      '${e.load.material}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Tonnage'),
                                    Text(
                                      '${e.load.tonnage}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Truck Preferences'),
                                    Text(
                                      '${e.load.truckPreferences}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Expected Price'),
                                    Text(
                                      '${e.load.expectedPrice}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Payment Mode'),
                                    Text(
                                      '${e.load.paymentMode}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Created On'),
                                    Text(
                                      '${e.load.createdOn}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Expired On'),
                                    Text(
                                      '${e.load.expiredOn}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Contact Person'),
                                    Text(
                                      '${e.load.contactPerson}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Contact Person Phone No.'),
                                    Text(
                                      '${e.load.contactPersonPhone}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Bid Status'),
                                    Text(
                                      '${e.bidStatusMessage}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: (e.bidStatus == '1')
                                            ? Colors.green
                                            : Colors.black87,
                                      ),
                                    )
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
