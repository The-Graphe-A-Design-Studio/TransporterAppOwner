import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transportationapp/BottomSheets/AccountBottomSheetLoggedIn.dart';

class UploadDocs extends StatefulWidget {
  UploadDocs({Key key}) : super(key: key);

  @override
  _UploadDocsState createState() => _UploadDocsState();
}

enum WidgetMarker { panCard, selfie, addProof, offAdd }

class _UploadDocsState extends State<UploadDocs> {
  WidgetMarker selectedWidgetMarker;

  PickedFile panCard;
  PickedFile selfie;
  PickedFile addFront;
  PickedFile addBack;
  PickedFile offAdd;
  bool panCardDone = false;
  bool selfieDone = false;
  bool addFrontDone = false;
  bool addBackDone = false;
  bool offAddDone = false;
  String selectedAddProofType;

  final companyNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedWidgetMarker = WidgetMarker.panCard;
  }

  @override
  void dispose() {
    companyNameController.dispose();
    super.dispose();
  }

  void callUploadAPI(BuildContext context) {
    return;
  }

  Future getImageFromCamera(int i) async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    switch (i) {
      case 1:
        setState(() {
          if (image != null) {
            panCard = image;
            panCardDone = true;
          }
        });
        break;
      case 2:
        setState(() {
          if (image != null) {
            selfie = image;
            selfieDone = true;
          }
        });
        break;
      case 3:
        setState(() {
          if (image != null) {
            addFront = image;
            addFrontDone = true;
          }
        });
        break;
      case 4:
        setState(() {
          if (image != null) {
            addBack = image;
            addBackDone = true;
          }
        });
        break;
      case 5:
        setState(() {
          if (image != null) {
            offAdd = image;
            offAddDone = true;
          }
        });
        break;
    }
  }

  Future getImageFromGallery(int i) async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    switch (i) {
      case 1:
        setState(() {
          if (image != null) {
            panCard = image;
            panCardDone = true;
          }
        });
        break;
      case 2:
        setState(() {
          if (image != null) {
            selfie = image;
            selfieDone = true;
          }
        });
        break;
      case 3:
        setState(() {
          if (image != null) {
            addFront = image;
            addFrontDone = true;
          }
        });
        break;
      case 4:
        setState(() {
          if (image != null) {
            addBack = image;
            addBackDone = true;
          }
        });
        break;
      case 5:
        setState(() {
          if (image != null) {
            offAdd = image;
            offAddDone = true;
          }
        });
        break;
    }
  }

  Widget getPanCardWidget(context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 100.0,
            ),
            Text(
              "Upload",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Pan Card",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 60.0,
            ),
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  panCardDone
                      ? Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.height * 0.40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image: FileImage(File(panCard.path)),
                                fit: BoxFit.cover),
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/logo_white.png"),
                                fit: BoxFit.contain),
                          ),
                        ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        getImageFromCamera(1);
                      },
                      child: CircleAvatar(
                        child: Icon(
                          Icons.camera_alt,
                          size: 20.0,
                          color: Colors.black,
                        ),
                        backgroundColor: Colors.white,
                        radius: 18.0,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 56,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        getImageFromGallery(1);
                      },
                      child: CircleAvatar(
                        child: Icon(
                          Icons.image,
                          size: 20.0,
                          color: Colors.black,
                        ),
                        backgroundColor: Colors.white,
                        radius: 18.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  if (panCardDone) {
                    setState(() {
                      selectedWidgetMarker = WidgetMarker.addProof;
                    });
                  }
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
                    border: Border.all(width: 2.0, color: Colors.white),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 100.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget getAddProofWidget(context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 100.0,
            ),
            Text(
              "Upload",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Address Proof",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 60.0,
            ),
            DropdownButton<String>(
              isExpanded: true,
              hint: Text("Select Truck Category", style: TextStyle(color: Colors.white),),
              dropdownColor: Color(0xff252427),
              style: TextStyle(color: Colors.white),
              underline: Container(
                height: 2,
                color: Colors.white,
              ),
              value: selectedAddProofType,
              items: <String>[
                'Aadhar Card',
                'Voter ID',
                'Passport',
                'Driving Licence'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String value) {
                setState(() {
                  selectedAddProofType = value;
                  addFrontDone = false;
                  addBackDone = false;
                });
              },
            ),
            SizedBox(height: 30.0,),
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  addFrontDone
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image: FileImage(File(addFront.path)),
                                fit: BoxFit.cover),
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/logo_white.png"),
                                fit: BoxFit.contain),
                          ),
                        ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        getImageFromCamera(3);
                      },
                      child: CircleAvatar(
                        child: Icon(
                          Icons.camera_alt,
                          size: 20.0,
                          color: Colors.black,
                        ),
                        backgroundColor: Colors.white,
                        radius: 18.0,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 56,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        getImageFromGallery(3);
                      },
                      child: CircleAvatar(
                        child: Icon(
                          Icons.image,
                          size: 20.0,
                          color: Colors.black,
                        ),
                        backgroundColor: Colors.white,
                        radius: 18.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  addBackDone
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image: FileImage(File(addBack.path)),
                                fit: BoxFit.cover),
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/logo_white.png"),
                                fit: BoxFit.contain),
                          ),
                        ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        getImageFromCamera(4);
                      },
                      child: CircleAvatar(
                        child: Icon(
                          Icons.camera_alt,
                          size: 20.0,
                          color: Colors.black,
                        ),
                        backgroundColor: Colors.white,
                        radius: 18.0,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 56,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        getImageFromGallery(4);
                      },
                      child: CircleAvatar(
                        child: Icon(
                          Icons.image,
                          size: 20.0,
                          color: Colors.black,
                        ),
                        backgroundColor: Colors.white,
                        radius: 18.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  if (selectedAddProofType.isNotEmpty && addFrontDone && addBackDone) {
                    setState(() {
                      selectedWidgetMarker = WidgetMarker.selfie;
                    });
                  }
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
                    border: Border.all(width: 2.0, color: Colors.white),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 100.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget getSelfieWidget(context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 100.0,
            ),
            Text(
              "Upload",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "A Selfie",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 60.0,
            ),
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  selfieDone
                      ? Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.height * 0.40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image: FileImage(File(selfie.path)),
                                fit: BoxFit.cover),
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/logo_white.png"),
                                fit: BoxFit.contain),
                          ),
                        ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        getImageFromCamera(2);
                      },
                      child: CircleAvatar(
                        child: Icon(
                          Icons.camera_alt,
                          size: 20.0,
                          color: Colors.black,
                        ),
                        backgroundColor: Colors.white,
                        radius: 18.0,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 56,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        getImageFromGallery(2);
                      },
                      child: CircleAvatar(
                        child: Icon(
                          Icons.image,
                          size: 20.0,
                          color: Colors.black,
                        ),
                        backgroundColor: Colors.white,
                        radius: 18.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  if (selfieDone) {
                    setState(() {
                      selectedWidgetMarker = WidgetMarker.offAdd;
                    });
                  }
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
                    border: Border.all(width: 2.0, color: Colors.white),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 100.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget getOffAddWidget(context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 100.0,
            ),
            Text(
              "Upload",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "A Selfie",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 60.0,
            ),
            TextFormField(
              controller: companyNameController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              style: TextStyle(color: Colors.black, fontSize: 16.0),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                errorStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.flight_land),
                hintText: "Company Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.amber,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  offAddDone
                      ? Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.height * 0.40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image: FileImage(File(offAdd.path)),
                                fit: BoxFit.cover),
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/logo_white.png"),
                                fit: BoxFit.contain),
                          ),
                        ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        getImageFromCamera(5);
                      },
                      child: CircleAvatar(
                        child: Icon(
                          Icons.camera_alt,
                          size: 20.0,
                          color: Colors.black,
                        ),
                        backgroundColor: Colors.white,
                        radius: 18.0,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 56,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        getImageFromGallery(5);
                      },
                      child: CircleAvatar(
                        child: Icon(
                          Icons.image,
                          size: 20.0,
                          color: Colors.black,
                        ),
                        backgroundColor: Colors.white,
                        radius: 18.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  if (offAddDone && companyNameController.text.isNotEmpty) {
                    #TODO;
                    callUploadAPI(context);
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  child: Center(
                    child: Text(
                      "Upload Documents",
                      style: TextStyle(
                          color: Color(0xff252427),
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2.0, color: Colors.white),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 100.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget getCustomWidget(context) {
    switch (selectedWidgetMarker) {
      case WidgetMarker.panCard:
        return getPanCardWidget(context);
      case WidgetMarker.addProof:
        return getAddProofWidget(context);
      case WidgetMarker.selfie:
        return getSelfieWidget(context);
      case WidgetMarker.offAdd:
        return getOffAddWidget(context);
    }
    return getPanCardWidget(context);
  }

  Future<bool> onBackPressed() {
    switch (selectedWidgetMarker) {
      case WidgetMarker.panCard:
        return Future.value(true);
      case WidgetMarker.addProof:
        setState(() {
          selectedWidgetMarker = WidgetMarker.panCard;
        });
        return Future.value(false);
      case WidgetMarker.selfie:
        setState(() {
          selectedWidgetMarker = WidgetMarker.addProof;
        });
        return Future.value(false);
      case WidgetMarker.offAdd:
        setState(() {
          selectedWidgetMarker = WidgetMarker.addProof;
        });
        return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252427),
      body: Stack(
        children: <Widget>[
          getCustomWidget(context),
          DraggableScrollableSheet(
            initialChildSize: 0.08,
            minChildSize: 0.08,
            maxChildSize: 0.9,
            builder: (BuildContext context, ScrollController scrollController) {
              return Hero(
                tag: 'AnimeBottom',
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 10.0,
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                  ),
                  child: AccountBottomSheetLoggedIn(
                      scrollController: scrollController),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
