import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ownerapp/CommonPages/LoadingBody.dart';
import 'package:ownerapp/DialogScreens/DialogFailed.dart';
import 'package:ownerapp/DialogScreens/DialogProcessing.dart';
import 'package:ownerapp/DialogScreens/DialogSuccess.dart';
import 'package:ownerapp/HttpHandler.dart';
import 'package:ownerapp/Models/Truck.dart';
import 'package:ownerapp/Models/TruckCategory.dart';

class EditTruckOwner extends StatefulWidget {
  final Truck truck;
  final viewTrucksOwnerState;

  EditTruckOwner({Key key, this.truck, this.viewTrucksOwnerState})
      : super(key: key);

  @override
  _EditTruckOwnerState createState() => _EditTruckOwnerState();
}

class _EditTruckOwnerState extends State<EditTruckOwner> {
  final GlobalKey<FormState> _formKeyCredentials = GlobalKey<FormState>();

  final truckNumberController = TextEditingController();
  final truckLoadController = TextEditingController();
  final truckDriverNameController = TextEditingController();
  final truckDriverMobileNumberController = TextEditingController();
  TruckCategory selectedTruckCategory;
  List<TruckCategory> listOfCat;
  bool loadCat = true;
  bool firstTime = true;

  final FocusNode _truckNumber = FocusNode();
  final FocusNode _truckLoad = FocusNode();
  final FocusNode _truckDriverName = FocusNode();
  final FocusNode _truckDriverNumber = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    truckNumberController.dispose();
    truckLoadController.dispose();
    truckDriverNameController.dispose();
    truckDriverMobileNumberController.dispose();

    super.dispose();
  }

  void postEditTruckRequest(BuildContext _context) {
    DialogProcessing().showCustomDialog(context,
        title: "Edit Truck Info", text: "Processing, Please Wait!");
    HTTPHandler().editTruckInfo([
      widget.truck.truckId,
      selectedTruckCategory.truckCatID.toString(),
      truckNumberController.text.toString(),
      truckLoadController.text.toString(),
      truckDriverNameController.text.toString(),
      '91',
      truckDriverMobileNumberController.text.toString(),
    ]).then((value) async {
      Navigator.pop(context);
      if (value.success) {
        DialogSuccess().showCustomDialog(context, title: "Edit Truck Info");
        await Future.delayed(Duration(seconds: 1), () {});
        widget.viewTrucksOwnerState.setState(() {
          widget.viewTrucksOwnerState.temp = false;
        });

        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        DialogFailed().showCustomDialog(context,
            title: "Edit Truck Info", text: value.message);
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      }
    }).catchError((error) async {
      print(error);
      Navigator.pop(context);
      DialogFailed().showCustomDialog(context,
          title: "Edit Truck Info", text: "Network Error");
      await Future.delayed(Duration(seconds: 3), () {});
      Navigator.pop(context);
    });
  }

  Widget getEditsBottomSheetWidget(context, ScrollController scrollController) {
    if (firstTime) {
      firstTime = false;
      selectedTruckCategory = listOfCat[int.parse(widget.truck.truckCat) - 1];
      truckNumberController.text = widget.truck.truckNumber;
      truckLoadController.text = widget.truck.truckLoad;
      truckDriverNameController.text = widget.truck.truckDriverName;
      truckDriverMobileNumberController.text = widget.truck.truckDriverPhone;
    }
    return ListView(controller: scrollController, children: <Widget>[
      SingleChildScrollView(
        child: Form(
          key: _formKeyCredentials,
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
                  Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
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
              DropdownButton(
                isExpanded: true,
                hint: Text(selectedTruckCategory.truckCatName),
                value: selectedTruckCategory,
                onChanged: (TruckCategory value) {
                  setState(() {
                    selectedTruckCategory = value;
                  });
                },
                dropdownColor: Colors.white,
                items: listOfCat.map((TruckCategory item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item.truckCatName),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: truckNumberController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                focusNode: _truckNumber,
                onFieldSubmitted: (term) {
                  _truckNumber.unfocus();
                  FocusScope.of(context).requestFocus(_truckLoad);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Truck Number",
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
                  controller: truckLoadController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  focusNode: _truckLoad,
                  onFieldSubmitted: (term) {
                    _truckLoad.unfocus();
                    FocusScope.of(context).requestFocus(_truckDriverName);
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.event_seat),
                    labelText: "Truck Capacity (In Tons)",
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
                  }),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: truckDriverNameController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                focusNode: _truckDriverName,
                onFieldSubmitted: (term) {
                  _truckDriverName.unfocus();
                  FocusScope.of(context).requestFocus(_truckDriverNumber);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Driver Name",
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
              Row(
                children: [
                  SizedBox(
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
                    width: 97.0,
                  ),
                  SizedBox(width: 16.0),
                  Flexible(
                    child: TextFormField(
                      controller: truckDriverMobileNumberController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      focusNode: _truckDriverNumber,
                      decoration: InputDecoration(
                        labelText: "Driver Mobile Number",
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
                  )
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (selectedTruckCategory != null) {
                      if (_formKeyCredentials.currentState.validate()) {
                        postEditTruckRequest(context);
                      }
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.black,
                        content: Text(
                          "Please Choose a Truck Category",
                          style: TextStyle(color: Colors.white),
                        ),
                      ));
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        "Update Truck Info",
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

  Widget getEditsWidget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3 - 20,
          ),
          Text(
            "Edit",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Truck Info",
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

  void getCategories() async {
    HTTPHandler().getTruckCategory().then((value) {
      setState(() {
        listOfCat = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loadCat) {
      loadCat = false;
      getCategories();
    }
    return Scaffold(
      backgroundColor: Color(0xff252427),
      body: listOfCat == null
          ? LoadingBody()
          : Stack(children: <Widget>[
              getEditsWidget(context),
              DraggableScrollableSheet(
                initialChildSize: 0.65,
                minChildSize: 0.4,
                maxChildSize: 0.9,
                builder:
                    (BuildContext context, ScrollController scrollController) {
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
                            child: getEditsBottomSheetWidget(
                                context, scrollController),
                          )));
                },
              ),
            ]),
    );
  }
}
