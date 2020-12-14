import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ownerapp/DialogScreens/DialogFailed.dart';
import 'package:ownerapp/DialogScreens/DialogProcessing.dart';
import 'package:ownerapp/DialogScreens/DialogSuccess.dart';
import 'package:ownerapp/HttpHandler.dart';
import 'package:ownerapp/Models/User.dart';
import 'package:ownerapp/MyConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';
import 'package:toast/toast.dart';

class OwnerOptionsPage extends StatefulWidget {
  OwnerOptionsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _OwnerOptionsPageState createState() => _OwnerOptionsPageState();
}

enum WidgetMarker {
  credentials,
  ownerDetails,
  otpVerification,
  signIn,
}

class _OwnerOptionsPageState extends State<OwnerOptionsPage> {
  WidgetMarker selectedWidgetMarker = WidgetMarker.signIn;
  WidgetMarker selectedBottomSheetWidgetMarker = WidgetMarker.signIn;
  UserOwner userOwner;

  final GlobalKey<FormState> _formKeyOwnerDetails = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyOtp = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final operatingRoutesController = TextEditingController();
  final permitStatesController = TextEditingController();

  final panCardNumberController = TextEditingController();
  final bankAccountNumberController = TextEditingController();
  final ifscCodeController = TextEditingController();

  final otpController = TextEditingController();

  final passwordControllerSignIn = TextEditingController();
  final mobileNumberControllerSignIn = TextEditingController();

  bool rememberMe = true;

  final FocusNode _mobileNumberSignIn = FocusNode();
  final FocusNode _passwordSignIn = FocusNode();

  final FocusNode _panCardNumber = FocusNode();
  final FocusNode _bankAccountNumber = FocusNode();
  final FocusNode _ifscCode = FocusNode();

  bool isLogin = false;

  String _otpCode = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    addressController.dispose();
    cityController.dispose();
    operatingRoutesController.dispose();
    permitStatesController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    panCardNumberController.dispose();
    bankAccountNumberController.dispose();
    ifscCodeController.dispose();

    otpController.dispose();

    mobileNumberControllerSignIn.dispose();
    passwordControllerSignIn.dispose();

    super.dispose();
  }

  void postSignUpRequest(BuildContext _context) {
    DialogProcessing().showCustomDialog(context,
        title: "Sign Up Request", text: "Processing, Please Wait!");
    HTTPHandler().registerOwner([
      '91',
      mobileNumberController.text.toString(),
      'graphe@devs'
    ]).then((value) async {
      Navigator.pop(context);
      if (value.success) {
        DialogSuccess().showCustomDialog(context, title: "Sign Up");
        await Future.delayed(Duration(seconds: 1), () {});
        setState(() {
          isLogin = false;
          selectedWidgetMarker = WidgetMarker.otpVerification;
        });
        Navigator.pop(context);
        Scaffold.of(_context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            value.message,
            style: TextStyle(color: Colors.white),
          ),
        ));
      } else {
        DialogFailed()
            .showCustomDialog(context, title: "Sign Up", text: value.message);
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      }
    }).catchError((error) async {
      print(error);
      Navigator.pop(context);
      DialogFailed()
          .showCustomDialog(context, title: "Sign Up", text: "Network Error");
      await Future.delayed(Duration(seconds: 3), () {});
      Navigator.pop(context);
    });
  }

  void saveOTP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('otp', _otpCode);
  }

  void postOtpVerificationRequest(BuildContext _context) {
    if (_otpCode.length == 6) {
      print('login => $isLogin');
      print('remember => $rememberMe');
      DialogProcessing().showCustomDialog(context,
          title: "OTP Verification", text: "Processing, Please Wait!");
      HTTPHandler().registerVerifyOtpOwner([
        mobileNumberController.text,
        _otpCode,
        rememberMe,
      ]).then((value) async {
        saveOTP();
        userOwner = value;
        Navigator.pop(context);
        if (value.success) {
          DialogSuccess().showCustomDialog(context, title: "OTP Verification");
          await Future.delayed(Duration(seconds: 1), () {});
          Navigator.pop(context);
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
            Navigator.pushNamedAndRemoveUntil(
                _context, homePageOwner, (route) => false,
                arguments: userOwner);
        } else {
          DialogFailed().showCustomDialog(context,
              title: "OTP Verification", text: 'OTP Verification Failed');
          await Future.delayed(Duration(seconds: 3), () {});
          Navigator.pop(context);
        }
      }).catchError((error) async {
        Navigator.pop(context);
        DialogFailed().showCustomDialog(context,
            title: "OTP Verification", text: "Network Error");
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      });
    } else {
      Toast.show('Enter Complete OTP', context);
    }
  }

  void postSignInRequest(BuildContext _context) {
    DialogProcessing().showCustomDialog(context,
        title: "Requesting OTP", text: "Processing, Please Wait!");
    HTTPHandler().loginOwner([
      '91',
      mobileNumberController.text,
    ]).then((value) async {
      Navigator.pop(context);
      if (value.success) {
        DialogSuccess().showCustomDialog(context, title: "Requesting OTP");
        await Future.delayed(Duration(seconds: 1), () {});
        setState(() {
          isLogin = false;
          selectedWidgetMarker = WidgetMarker.otpVerification;
        });
        Navigator.pop(context);
        Scaffold.of(_context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            value.message,
            style: TextStyle(color: Colors.white),
          ),
        ));
      } else {
        DialogFailed()
            .showCustomDialog(context, title: "Requesting OTP", text: value.message);
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      }
    }).catchError((error) async {
      Navigator.pop(context);
      DialogFailed()
          .showCustomDialog(context, title: "Requesting OTP", text: "Network Error");
      await Future.delayed(Duration(seconds: 3), () {});
      Navigator.pop(context);
    });
  }

  void postResendOtpRequest(BuildContext _context) {
    DialogProcessing().showCustomDialog(context,
        title: "Resend OTP", text: "Processing, Please Wait!");
    HTTPHandler().registerResendOtpOwner([mobileNumberController.text]).then(
        (value) async {
      Navigator.pop(context);
      if (value.success) {
        DialogSuccess().showCustomDialog(context, title: "Resend OTP");
        await Future.delayed(Duration(seconds: 1), () {});
        Navigator.pop(context);
        Scaffold.of(_context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            value.message,
            style: TextStyle(color: Colors.white),
          ),
        ));
      } else {
        DialogFailed().showCustomDialog(context,
            title: "Resend OTP", text: value.message);
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      }
    }).catchError((error) async {
      Navigator.pop(context);
      DialogFailed().showCustomDialog(context,
          title: "Resend OTP", text: "Network Error");
      await Future.delayed(Duration(seconds: 3), () {});
      Navigator.pop(context);
    });
  }

  void clearControllers() {
    nameController.clear();
    mobileNumberController.clear();
    emailController.clear();
    addressController.clear();
    cityController.clear();
    passwordController.clear();
    confirmPasswordController.clear();

    panCardNumberController.clear();
    bankAccountNumberController.clear();
    ifscCodeController.clear();

    otpController.clear();

    mobileNumberControllerSignIn.clear();
    passwordControllerSignIn.clear();
  }

  Widget getOptionsBottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(
      controller: scrollController,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xff252427),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Image(
            image: AssetImage('assets/images/logo_white.png'),
            height: 125.0,
            width: 125.0,
          ),
        ),
        SizedBox(
          height: 40.0,
        ),
        Align(
          alignment: Alignment.center,
          child: Material(
            child: Text("Welcome to Truckwale App."),
          ),
        ),
        SizedBox(height: 40.0),
        Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                isLogin = false;
                selectedWidgetMarker = WidgetMarker.credentials;
              });
              print('is login $isLogin');
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 50.0,
              child: Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xff252427),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2.0, color: Color(0xff252427)),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                isLogin = true;
                selectedWidgetMarker = WidgetMarker.signIn;
              });
              print('is login $isLogin');
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 50.0,
              child: Center(
                child: Text(
                  "Sign In",
                  style: TextStyle(
                      color: Color(0xff252427),
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2.0, color: Color(0xff252427)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getCredentialsBottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(controller: scrollController, children: <Widget>[
      SingleChildScrollView(
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // setState(() {
                          //   clearControllers();
                          //   selectedWidgetMarker = WidgetMarker.options;
                          // });
                          SystemNavigator.pop();
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xff252427),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // setState(() {
                          //   clearControllers();
                          //   selectedWidgetMarker = WidgetMarker.options;
                          // });
                          SystemNavigator.pop();
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                              color: Colors.black12,
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage('assets/images/logo_white.png'),
                  height: 125.0,
                  width: 125.0,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Row(
                children: [
                  SizedBox(
                    child: Material(
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.dialpad),
                          hintText: "+91",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.amber,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                    ),
                    width: 97.0,
                  ),
                  SizedBox(width: 16.0),
                  Flexible(
                    child: Material(
                      child: TextFormField(
                        controller: mobileNumberController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        focusNode: _mobileNumberSignIn,
                        onFieldSubmitted: (term) {
                          _mobileNumberSignIn.unfocus();
                          FocusScope.of(context).requestFocus(_passwordSignIn);
                        },
                        decoration: InputDecoration(
                          labelText: "Mobile Number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.amber,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "This Field is Required";
                          } else if (value.length != 10) {
                            return "Enter Valid Mobile Number";
                          }
                          return null;
                        },
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    // if (_formKeySignIn.currentState.validate()) {
                      postSignUpRequest(context);
                    // }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(
                            color: Color(0xff252427),
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2.0, color: Color(0xff252427)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget getOwnerDetailsBottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(controller: scrollController, children: <Widget>[
      SingleChildScrollView(
        child: Form(
          key: _formKeyOwnerDetails,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedWidgetMarker = WidgetMarker.credentials;
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xff252427),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // setState(() {
                          //   clearControllers();
                          //   selectedWidgetMarker = WidgetMarker.options;
                          // });
                          SystemNavigator.pop();
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                              color: Colors.black12,
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: panCardNumberController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                focusNode: _panCardNumber,
                onFieldSubmitted: (term) {
                  _panCardNumber.unfocus();
                  FocusScope.of(context).requestFocus(_bankAccountNumber);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.dialpad),
                  labelText: "PAN Card Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.amber,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "This Field is Required";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: bankAccountNumberController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _bankAccountNumber,
                onFieldSubmitted: (term) {
                  _bankAccountNumber.unfocus();
                  FocusScope.of(context).requestFocus(_ifscCode);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.credit_card),
                  labelText: "Bank Account Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.amber,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "This Field is Required";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: ifscCodeController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.done,
                focusNode: _ifscCode,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.code),
                  labelText: "IFSC Code",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.amber,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "This Field is Required";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (_formKeyOwnerDetails.currentState.validate()) {
                      postSignUpRequest(context);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff252427),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2.0, color: Color(0xff252427)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  _getSignatureCode() async {
    String signature = await SmsRetrieved.getAppSignature();
    print("signature $signature");
  }

  Widget getOtpVerificationBottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(controller: scrollController, children: <Widget>[
      SingleChildScrollView(
        child: Form(
          key: _formKeyOtp,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // setState(() {
                          //   clearControllers();
                          //   selectedWidgetMarker = WidgetMarker.options;
                          // });
                          SystemNavigator.pop();
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xff252427),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // setState(() {
                          //   clearControllers();
                          //   selectedWidgetMarker = WidgetMarker.options;
                          // });
                          SystemNavigator.pop();
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                              color: Colors.black12,
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage('assets/images/logo_white.png'),
                  height: 125.0,
                  width: 125.0,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              TextFieldPin(
                borderStyeAfterTextChange: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.black87),
                ),
                borderStyle: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.black87),
                ),
                codeLength: 6,
                boxSize: 40,
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
                filledAfterTextChange: true,
                filledColor: Colors.white,
                onOtpCallback: (code, isAutofill) {
                  print(code);
                  this._otpCode = code;
                },
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      otpController.clear();
                    });
                    postResendOtpRequest(context);
                  },
                  child: Text(
                    "Resend OTP",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (_formKeyOtp.currentState.validate()) {
                      postOtpVerificationRequest(context);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        "Verify OTP",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff252427),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2.0, color: Color(0xff252427)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget getSignInBottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(controller: scrollController, children: <Widget>[
      SingleChildScrollView(
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // setState(() {
                          //   clearControllers();
                          //   selectedWidgetMarker = WidgetMarker.options;
                          // });
                          SystemNavigator.pop();
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xff252427),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // setState(() {
                          //   clearControllers();
                          //   selectedWidgetMarker = WidgetMarker.options;
                          // });
                          SystemNavigator.pop();
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                              color: Colors.black12,
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage('assets/images/logo_white.png'),
                  height: 125.0,
                  width: 125.0,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Row(
                children: [
//                  SizedBox(
//                    child: Material(
//                      child: TextFormField(
//                        readOnly: true,
//                        decoration: InputDecoration(
//                          prefixIcon: Icon(Icons.dialpad),
//                          hintText: "+91",
//                          border: OutlineInputBorder(
//                            borderRadius: BorderRadius.circular(5.0),
//                            borderSide: BorderSide(
//                              color: Colors.amber,
//                              style: BorderStyle.solid,
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                    width: 97.0,
//                  ),
//                  SizedBox(width: 16.0),
                  Flexible(
                    child: Material(
                      child: TextFormField(
                        controller: mobileNumberController,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        textInputAction: TextInputAction.next,
                        focusNode: _mobileNumberSignIn,
                        onFieldSubmitted: (term) {
                          _mobileNumberSignIn.unfocus();
                          FocusScope.of(context).requestFocus(_passwordSignIn);
                        },
                        decoration: InputDecoration(
                          labelText: "Mobile Number",
                          prefixText: "+91     ",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.amber,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "This Field is Required";
                          } else if (value.length != 10) {
                            return "Enter Valid Mobile Number";
                          }
                          return null;
                        },
                      ),
                    ),
                  )
                ],
              ),
//              Row(
//                children: [
//                  Material(
//                    child: Checkbox(
//                      value: rememberMe,
//                      checkColor: Colors.white,
//                      activeColor: Color(0xff252427),
//                      onChanged: (bool value) {
//                        setState(() {
//                          rememberMe = value;
//                        });
//                      },
//                    ),
//                  ),
//                  SizedBox(
//                    width: 0.0,
//                  ),
//                  Text("Remember Me"),
//                  Spacer(),
//                  GestureDetector(
//                    onTap: () {
//                      print("Forgot Password");
//                    },
//                    child: Container(
//                      child: Text("Forgot Password?"),
//                    ),
//                  )
//                ],
//              ),
              SizedBox(
                height: 30.0,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                      postSignInRequest(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        "Next",
                        style: TextStyle(
                            color: Color(0xff252427),
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2.0, color: Color(0xff252427)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget getOptionsWidget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3,
          ),
          Text(
            "Hi, User",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget getCredentialsWidget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3 - 20,
          ),
          Text(
            "Enter",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Credentials",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget getDocumentsWidget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3 - 20,
          ),
          Text(
            "Upload",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Documents",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget getOwnerDetailsWidget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3 - 20,
          ),
          Text(
            "Owner",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Details",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget getOtpVerificationWidget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3 - 20,
          ),
          Text(
            "OTP",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Verification",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget getSignInWidget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3,
          ),
          Text(
            "Welcome Back!",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget getCustomWidget(context) {
    switch (selectedWidgetMarker) {
      // case WidgetMarker.options:
      //   return getOptionsWidget(context);
      case WidgetMarker.credentials:
        return getCredentialsWidget(context);
      case WidgetMarker.ownerDetails:
        return getOwnerDetailsWidget(context);
      case WidgetMarker.otpVerification:
        return getOtpVerificationWidget(context);
      case WidgetMarker.signIn:
        return getSignInWidget(context);
    }
    return getOptionsWidget(context);
  }

  Widget getCustomBottomSheetWidget(
      context, ScrollController scrollController) {
    switch (selectedWidgetMarker) {
      // case WidgetMarker.options:
      //   return getOptionsBottomSheetWidget(context, scrollController);
      case WidgetMarker.credentials:
        return getCredentialsBottomSheetWidget(context, scrollController);
      case WidgetMarker.ownerDetails:
        return getOwnerDetailsBottomSheetWidget(context, scrollController);
      case WidgetMarker.otpVerification:
        return getOtpVerificationBottomSheetWidget(context, scrollController);
      case WidgetMarker.signIn:
        return getSignInBottomSheetWidget(context, scrollController);
    }
    return getOptionsBottomSheetWidget(context, scrollController);
  }

  Future<bool> onBackPressed() {
    switch (selectedWidgetMarker) {
      // case WidgetMarker.options:
      //   return Future.value(true);
      case WidgetMarker.credentials:
        // setState(() {
        //   clearControllers();
        //   selectedWidgetMarker = WidgetMarker.options;
        // });
        return Future.value(false);
      case WidgetMarker.ownerDetails:
        setState(() {
          selectedWidgetMarker = WidgetMarker.credentials;
        });
        return Future.value(false);
      case WidgetMarker.otpVerification:
        setState(() {
          selectedWidgetMarker = WidgetMarker.ownerDetails;
        });
        return Future.value(false);
      case WidgetMarker.signIn:
        // setState(() {
        //   clearControllers();
        //   selectedWidgetMarker = WidgetMarker.options;
        // });
        return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    _getSignatureCode();

    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        backgroundColor: Color(0xff252427),
        body: Stack(children: <Widget>[
          getCustomWidget(context),
          DraggableScrollableSheet(
            initialChildSize: 0.64,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (BuildContext context, ScrollController scrollController) {
              return Hero(
                tag: 'AnimeBottom',
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child:
                        getCustomBottomSheetWidget(context, scrollController),
                  ),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}
