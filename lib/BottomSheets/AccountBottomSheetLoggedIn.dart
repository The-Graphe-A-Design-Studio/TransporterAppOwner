import 'package:flutter/material.dart';
import 'package:ownerapp/HttpHandler.dart';
import 'package:ownerapp/Models/User.dart';
import 'package:ownerapp/MyConstants.dart';

class AccountBottomSheetLoggedIn extends StatefulWidget {
  final ScrollController scrollController;
  final UserOwner userOwner;

  AccountBottomSheetLoggedIn({
    Key key,
    @required this.scrollController,
    @required this.userOwner,
  }) : super(key: key);

  @override
  _AccountBottomSheetLoggedInState createState() =>
      _AccountBottomSheetLoggedInState();
}

class _AccountBottomSheetLoggedInState
    extends State<AccountBottomSheetLoggedIn> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 10.0,
      ),
      child: ListView(
        controller: widget.scrollController,
        children: <Widget>[
          Material(
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  subscriptionOwner,
                  arguments: widget.userOwner,
                );
              },
              leading: Icon(
                Icons.toc,
                color: Colors.white,
              ),
              title: Text(
                'Your Subscription',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Material(
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  addOnTruckOwner,
                  arguments: widget.userOwner,
                );
              },
              leading: Icon(
                Icons.drive_eta_sharp,
                color: Colors.white,
              ),
              title: Text(
                'Add On Trucks',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Material(
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  viewPosts,
                  arguments: widget.userOwner,
                );
              },
              leading: Icon(
                Icons.ac_unit,
                color: Colors.white,
              ),
              title: Text(
                'View Posts',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Material(
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  myBidsOwner,
                  arguments: widget.userOwner,
                );
              },
              leading: Icon(
                Icons.access_alarm,
                color: Colors.white,
              ),
              title: Text(
                'View Bids',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Material(
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  myDeliveriesOwner,
                  arguments: widget.userOwner,
                );
              },
              leading: Icon(
                Icons.motorcycle,
                color: Colors.white,
              ),
              title: Text(
                'View Deliveries',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Material(
            child: ListTile(
              onTap: () {
                HTTPHandler().signOut(
                  context,
                  widget.userOwner.oPhone,
                );
              },
              leading: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
