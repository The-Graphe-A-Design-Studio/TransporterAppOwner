import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ownerapp/BottomSheets/AccountBottomSheetLoggedIn.dart';
import 'package:ownerapp/HttpHandler.dart';
import 'package:ownerapp/Models/User.dart';
import 'package:ownerapp/MyConstants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class HomePageOwner extends StatefulWidget {
  final UserOwner userOwner;

  HomePageOwner({Key key, this.userOwner}) : super(key: key);

  @override
  _HomePageOwnerState createState() => _HomePageOwnerState();
}

class _HomePageOwnerState extends State<HomePageOwner> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  UserOwner owner;

  void _onRefresh(BuildContext context) async {
    print('working properly');
    reloadUser();
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void reloadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    HTTPHandler().registerVerifyOtpOwner(
        [owner.oPhone, prefs.getString('otp'), true]).then((value) {
      setState(() {
        this.owner = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    owner = widget.userOwner;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SmartRefresher(
            controller: _refreshController,
            onRefresh: () => _onRefresh(context),
            child: Container(
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
                    if (owner.planType != '2')
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30.0),
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black,
                        child: Column(
                          children: [
                            Text(
                              (owner.planType == '1')
                                  ? 'You are on free trial!'
                                  : 'You don\'t have active subscription!',
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
                                  arguments: owner,
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
                      "Truck Owner - " + owner.oName,
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
                        if (owner.verified == '1')
                          Navigator.pushNamed(context, viewTrucksOwner,
                              arguments: owner);
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
                            arguments: owner);
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
                    userOwner: owner,
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
