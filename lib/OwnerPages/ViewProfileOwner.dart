import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ownerapp/DialogScreens/DialogFailed.dart';
import 'package:ownerapp/DialogScreens/DialogProcessing.dart';
import 'package:ownerapp/DialogScreens/DialogSuccess.dart';
import 'package:ownerapp/HttpHandler.dart';
import 'package:ownerapp/Models/User.dart';
import 'dart:io';

import 'package:ownerapp/MyConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewProfileOwner extends StatefulWidget {
  final UserOwner userOwner;

  ViewProfileOwner({Key key, this.userOwner}) : super(key: key);

  @override
  _ViewProfileOwnerState createState() => _ViewProfileOwnerState();
}

enum WidgetMarker {
  viewProfile,
}

class _ViewProfileOwnerState extends State<ViewProfileOwner> {
  WidgetMarker selectedWidgetMarker = WidgetMarker.viewProfile;

  final nameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final operatingRoutesController = TextEditingController();
  final permitStatesController = TextEditingController();
  final panCardNumberController = TextEditingController();
  final bankAccountNumberController = TextEditingController();
  final ifscCodeController = TextEditingController();

  final currPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final otpController = TextEditingController();

  final FocusNode _name = FocusNode();
  final FocusNode _mobileNumber = FocusNode();
  final FocusNode _email = FocusNode();
  final FocusNode _bankAccountNumber = FocusNode();
  final FocusNode _ifscCode = FocusNode();

  Future<File> imageFile;

  String _otpCode = "";

  pickImageFromSystem(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(
        source: source,
        imageQuality: 15,
      );
    });
  }

  Widget _imagePreview() => (imageFile != null)
      ? FutureBuilder<File>(
          future: imageFile,
          builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
            if (snapshot.data != null)
              panCardNumberController.text = snapshot.data.path;

            return Container(
              height: 250.0,
              width: double.infinity,
              decoration: (imageFile != null && snapshot.data != null)
                  ? BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(snapshot.data),
                        fit: BoxFit.contain,
                      ),
                    )
                  : BoxDecoration(),
            );
          },
        )
      : Container();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.userOwner.oName;
    mobileNumberController.text = widget.userOwner.oPhone;
    bankAccountNumberController.text =
        (widget.userOwner.oBank == '0') ? '' : widget.userOwner.oBank;
    ifscCodeController.text =
        (widget.userOwner.oIfsc == '0') ? '' : widget.userOwner.oIfsc;
    panCardNumberController.text =
        (widget.userOwner.oPanCard == null) ? '' : widget.userOwner.oPanCard;
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
    panCardNumberController.dispose();
    bankAccountNumberController.dispose();
    ifscCodeController.dispose();

    currPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    otpController.dispose();

    super.dispose();
  }

  void postUpdateRequest(BuildContext _context) async {
    DialogProcessing().showCustomDialog(context,
        title: "Update Profile", text: "Processing, Please Wait!");

    if (imageFile != null) {
      HTTPHandler().updatePanCardImage([
        widget.userOwner.oPhone,
        panCardNumberController.text,
      ]).then((value) async {
        HTTPHandler().saveLocalChangesOwner(widget.userOwner);
        if (bankAccountNumberController.text == '' &&
            ifscCodeController.text == '') {
          Navigator.pop(context);
          if (value.success) {
            DialogSuccess().showCustomDialog(context, title: "Update Profile");
            await Future.delayed(Duration(seconds: 1), () {});

            imageCache.clear();
            imageCache.clearLiveImages();
            reloadUser();
            // setState(() {
            //   selectedWidgetMarker = WidgetMarker.verifyOTP;
            // });
            Navigator.pop(context);
          } else {
            DialogFailed().showCustomDialog(context,
                title: "Update Profile", text: value.message);
            await Future.delayed(Duration(seconds: 3), () {});
            Navigator.pop(context);
          }
        } else {
          print('update sustem as well');
          HTTPHandler().updateBankAndNameDetails([
            widget.userOwner.oPhone,
            nameController.text,
            (bankAccountNumberController.text == '')
                ? '0'
                : bankAccountNumberController.text,
            (ifscCodeController.text == '') ? '0' : ifscCodeController.text,
          ]).then((v) async {
            Navigator.pop(context);
            if (v.success) {
              DialogSuccess()
                  .showCustomDialog(context, title: "Update Profile");
              await Future.delayed(Duration(seconds: 1), () {});

              imageCache.clear();
              imageCache.clearLiveImages();
              reloadUser();
              // setState(() {
              //   selectedWidgetMarker = WidgetMarker.verifyOTP;
              // });
              Navigator.pop(context);
            } else {
              DialogFailed().showCustomDialog(context,
                  title: "Update Profile", text: v.message);
              await Future.delayed(Duration(seconds: 3), () {});
              Navigator.pop(context);
            }
          });
        }
      });
    } else if (bankAccountNumberController.text != '' ||
        ifscCodeController.text != '') {
      HTTPHandler().updateBankAndNameDetails([
        widget.userOwner.oPhone,
        nameController.text,
        (bankAccountNumberController.text == '')
            ? '0'
            : bankAccountNumberController.text,
        (ifscCodeController.text == '') ? '0' : ifscCodeController.text,
      ]).then((v) async {
        Navigator.pop(context);
        if (v.success) {
          DialogSuccess().showCustomDialog(context, title: "Update Profile");
          await Future.delayed(Duration(seconds: 1), () {});

          imageCache.clear();
          imageCache.clearLiveImages();
          reloadUser();
          // setState(() {
          //   selectedWidgetMarker = WidgetMarker.verifyOTP;
          // });
          Navigator.pop(context);
        } else {
          DialogFailed().showCustomDialog(context,
              title: "Update Profile", text: v.message);
          await Future.delayed(Duration(seconds: 3), () {});
          Navigator.pop(context);
        }
      });
    }
  }

  void reloadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    HTTPHandler().registerVerifyOtpOwner(
        [widget.userOwner.oPhone, prefs.getString('otp'), true]).then((value) {
      // setState(() {
      //   this.owner = value;
      // });
      Navigator.of(context).pop();
    });
  }

  void clearControllers() {
    nameController.clear();
    mobileNumberController.clear();
    emailController.clear();
    addressController.clear();
    cityController.clear();
    panCardNumberController.clear();
    bankAccountNumberController.clear();
    ifscCodeController.clear();

    otpController.clear();

    currPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  Widget getCredentialsBottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(controller: scrollController, children: <Widget>[
      SingleChildScrollView(
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        homePageOwner,
                        arguments: widget.userOwner,
                      );
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
              SizedBox(
                height: 16.0,
              ),
              Material(
                child: TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  focusNode: _name,
                  onFieldSubmitted: (term) {
                    _name.unfocus();
                    FocusScope.of(context).requestFocus(_mobileNumber);
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: "Full Name",
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
              ),
              SizedBox(
                height: 16.0,
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
                        focusNode: _mobileNumber,
                        onFieldSubmitted: (term) {
                          _mobileNumber.unfocus();
                          FocusScope.of(context).requestFocus(_email);
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
                          } else if (value.length < 10) {
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
                height: 16.0,
              ),
              Material(
                child: TextFormField(
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
              ),
              SizedBox(
                height: 16.0,
              ),
              Material(
                child: TextFormField(
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
              ),
              SizedBox(
                height: 16.0,
              ),
              GestureDetector(
                onTap: () => _showModalSheet(context),
                // pickImageFromSystem(ImageSource.gallery),
                child: Material(
                  child: TextFormField(
                    controller: panCardNumberController,
                    enabled: false,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.dialpad),
                      labelText: "PAN Card",
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              (imageFile != null)
                  ? _imagePreview()
                  : (panCardNumberController.text != null)
                      ? Container(
                          height: 250.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://truckwale.co.in/${panCardNumberController.text}'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                      : Container(),
              SizedBox(
                height: 16.0,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    postUpdateRequest(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        "Update Profile",
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

  Widget getProfileWidget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3 - 20,
          ),
          Text(
            "View",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Profile",
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
      case WidgetMarker.viewProfile:
        return getProfileWidget(context);
    }
    return getProfileWidget(context);
  }

  Widget getCustomBottomSheetWidget(
      context, ScrollController scrollController) {
    switch (selectedWidgetMarker) {
      case WidgetMarker.viewProfile:
        return getCredentialsBottomSheetWidget(context, scrollController);
    }
    return getCredentialsBottomSheetWidget(context, scrollController);
  }

  Future<bool> onBackPressed() {
    switch (selectedWidgetMarker) {
      case WidgetMarker.viewProfile:
        return Future.value(true);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // onWillPop: onBackPressed,
      onWillPop: () => Navigator.pushReplacementNamed(
        context,
        homePageOwner,
        arguments: widget.userOwner,
      ),
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

  void _showModalSheet(BuildContext context) => showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 150,
          color: Colors.black87,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.camera,
                      color: Colors.white,
                    ),
                    Text(
                      'Camera',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () {
                  pickImageFromSystem(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.folder_open,
                      color: Colors.white,
                    ),
                    Text(
                      'Gallery',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () {
                  pickImageFromSystem(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      });
}
