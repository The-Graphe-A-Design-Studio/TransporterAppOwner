import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ownerapp/BottomSheets/AccountBottomSheetLoggedIn.dart';
import 'package:ownerapp/Models/User.dart';
import 'package:ownerapp/MyConstants.dart';
import 'package:toast/toast.dart';

class HomePageOwner extends StatefulWidget {
  final UserOwner userOwner;

  HomePageOwner({Key key, this.userOwner}) : super(key: key);

  @override
  _HomePageOwnerState createState() => _HomePageOwnerState();
}

class _HomePageOwnerState extends State<HomePageOwner> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 100.0),
                  Image(
                      image: AssetImage('assets/images/logo_white.png'),
                      height: 200.0),
                  SizedBox(
                    height: 30.0,
                  ),
                  if (widget.userOwner.planType != '2')
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30.0),
                      padding: const EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      child: Column(
                        children: [
                          Text(
                            (widget.userOwner.planType == '1')
                                ? 'You are on free trial!'
                                : (widget.userOwner.planType == '0')
                                    ? 'Please wait, until verified by admin'
                                    : 'Your free trial has expired!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                subscriptionOwner,
                                arguments: widget.userOwner,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30.0,
                                vertical: 10.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                'Upgrade Now',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 30.0),
                  Text(
                    "Truck Owner - " + widget.userOwner.oName,
                    style: TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text("Tap to Add a New Truck",
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 18.0,
                      )),
                  Text("for Transporting",
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 18.0,
                      )),
                  SizedBox(
                    height: 40.0,
                  ),
                  FlatButton(
                    onPressed: () {
                      if (widget.userOwner.verified == '1')
                        Navigator.pushNamed(context, viewTrucksOwner,
                            arguments: widget.userOwner);
                      else
                        Toast.show(
                            'Please wait, until verified by admin.', context);
                    },
                    child: Text(
                      "View My Trucks",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, viewProfileOwner,
                          arguments: widget.userOwner);
                    },
                    child: Text(
                      "View My Profile",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.08,
            minChildSize: 0.08,
            maxChildSize: 0.9,
            builder: (BuildContext context, ScrollController scrollController) {
              return Hero(
                tag: 'AnimeBottom',
                child: Container(
                  margin: EdgeInsets.only(bottom: 0),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                  ),
                  child: AccountBottomSheetLoggedIn(
                    scrollController: scrollController,
                    userOwner: widget.userOwner,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
