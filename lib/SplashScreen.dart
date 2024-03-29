import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ownerapp/Models/User.dart';
import 'package:ownerapp/MyConstants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserDriver userDriver;
  UserOwner userOwner;
  UserCustomerCompany userCustomerCompany;
  UserCustomerIndividual userCustomerIndividual;
  String userType;

  Future<bool> doSomeAction() async {
    await Future.delayed(Duration(seconds: 2), () {});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool("rememberMe");
    userType = prefs.getString("userType");
    if (rememberMe == true) {
      if (userType == truckOwnerUser) {
        userOwner =
            UserOwner.fromJson(json.decode(prefs.getString("userData")));
      } else if (userType == driverUser) {
        userDriver =
            UserDriver.fromJson(json.decode(prefs.getString("userData")));
      } else if (userType == transporterUser) {
        userCustomerCompany = UserCustomerCompany.fromJson(
            json.decode(prefs.getString("userData")));
      }
    }
    return Future.value(rememberMe);
  }

  Future<void> requestPermission() async {
    await Permission.location.request();
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    doSomeAction().then((value) {
      if (value == true) {
        if (userType == truckOwnerUser) {
          if (userOwner.oName == '' ||
              userOwner.oBank == '0' ||
              userOwner.oIfsc == '0' ||
              userOwner.oPanCard == '')
            Navigator.pushReplacementNamed(
              context,
              viewProfileOwner,
              arguments: userOwner,
            );
          else
            Navigator.pushReplacementNamed(
              context,
              homePageOwner,
              arguments: userOwner,
            );
        } else if (userType == driverUser) {
          Navigator.pushReplacementNamed(context, homePageDriver,
              arguments: userDriver);
        } else if (userType == transporterUser) {
          Navigator.pushReplacementNamed(context, homePageTransporter,
              arguments: userCustomerCompany);
        } else {
          Navigator.pushReplacementNamed(context, ownerOptionPage);
        }
      } else {
        Navigator.pushReplacementNamed(context, ownerOptionPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: "WhiteLogo",
              child: Image(
                image: AssetImage('assets/images/logo_white.png'),
                height: 200.0,
                width: 200.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'TRUCK OWNER',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 22.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
