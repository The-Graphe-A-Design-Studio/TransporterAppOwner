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
              color: Color.fromRGBO(245, 245, 245, 1),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 70.0),
                    Container(
                      padding: EdgeInsets.only(left: 30.0),
                      child: Text(
                        "Dashboard",
                        style: TextStyle(
                          fontSize: 23.0,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    //SizedBox(height: 10.0),
                    Container(
                      margin: EdgeInsets.all(30.0),
                      height: 180.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('assets/images/logo_white.png'),
                            height: 100.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                owner.oName,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 5.0,),
                              Text(
                                "TRUCK OWNER",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0,),
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
                    SizedBox(height: 5.0),
                    Container(
                      margin: EdgeInsets.only(left: 30.0),
                      child: Text("Options",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30.0),
                      child: Text("Manage your account",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          )),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
//                          GestureDetector(
//                            onTap: () {
//                              if (truckList.length < owner.totalTruck)
//                                Navigator.pushNamed(
//                                    context, addTruckOwner,
//                                    arguments: owner);
//                              else
//                                Toast.show(
//                                  'Please buy truck add On',
//                                  context,
//                                  gravity: Toast.CENTER,
//                                );
//                            },
//                            child: Container(
//                              height: 220.0,
//                              width: 160.0,
//                              margin: EdgeInsets.only(left: 30.0),
//                              padding: EdgeInsets.all(20.0),
//                              decoration: BoxDecoration(
//                                borderRadius: BorderRadius.all(
//                                  Radius.circular(15.0),
//                                ),
//                                color: Colors.white,
//                              ),
//                              child: Column(
//                                children: <Widget>[
//                                  SizedBox(height: 30.0,),
//                                  Image(
//                                    image: AssetImage('assets/icon/plus-circle.png'),
//                                    height: 70.0,
//                                    alignment: Alignment.center,
//                                  ),
//                                  SizedBox(height: 40.0,),
//                                  Align(
//                                    alignment: Alignment.centerLeft,
//                                    child: Text(
//                                      "New Truck",
//                                      style: TextStyle(
//                                        color: Colors.black,
//                                        fontSize: 15.0,
//                                      ),
//                                    ),
//                                  ),
//                                  Align(
//                                    alignment: Alignment.centerLeft,
//                                    child: Text(
//                                      "Tap to add",
//                                      style: TextStyle(
//                                        color: Colors.black,
//                                        fontSize: 12.0,
//                                      ),
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ),
//                          ),
                          GestureDetector(
                            onTap: () {
                              if (owner.verified == '1')
                                Navigator.pushNamed(context, viewTrucksOwner,
                                    arguments: owner);
                              else
                                Toast.show(
                                    'Please wait, until verified by admin.', context);
                            },
                            child: Container(
                              height: 220.0,
                              width: 160.0,
                              margin: EdgeInsets.only(left: 30.0),
                              padding: EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 30.0,),
                                  Image(
                                    image: AssetImage('assets/icon/truck.png'),
                                    height: 70.0,
                                    alignment: Alignment.center,
                                  ),
                                  SizedBox(height: 40.0,),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Trucks",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "view my trucks",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, viewProfileOwner,
                                  arguments: owner);
                            },
                            child: Container(
                              height: 220.0,
                              width: 160.0,
                              margin: EdgeInsets.only(left: 30.0),
                              padding: EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 30.0,),
                                  Image(
                                    image: AssetImage('assets/icon/person.png'),
                                    height: 70.0,
                                    alignment: Alignment.center,
                                  ),
                                  SizedBox(height: 40.0,),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Profile",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "view my profile",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 30.0,)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 150,
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
