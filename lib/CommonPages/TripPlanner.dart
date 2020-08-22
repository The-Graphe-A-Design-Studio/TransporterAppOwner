import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ownerapp/BottomSheets/AccountBottomSheetDummy.dart';
import 'package:ownerapp/CommonPages/LoadingBody.dart';
import 'package:ownerapp/HttpHandler.dart';
import 'package:ownerapp/Models/GooglePlaces.dart';
import 'package:ownerapp/Models/TruckCategory.dart';
import 'package:ownerapp/MyConstants.dart';

class TripPlanner extends StatefulWidget {
  TripPlanner({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TripPlannerState createState() => _TripPlannerState();
}

class _TripPlannerState extends State<TripPlanner> {
  GlobalKey<AutoCompleteTextFieldState<GooglePlaces>> keyFrom = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<GooglePlaces>> keyTo = new GlobalKey();
  final GlobalKey<FormState> _formTripPlanner = GlobalKey<FormState>();

  AutoCompleteTextField fromTextField;
  AutoCompleteTextField toTextField;
  final materialController = TextEditingController();
  final truckLoadController = TextEditingController();
  final truckQuoteController = TextEditingController();
  List<GooglePlaces> suggestedCityFrom = [];
  List<GooglePlaces> suggestedCityTo = [];

  TruckCategory selectedTruckCategory;
  List<TruckCategory> listOfCat = [];
  bool loadCat = true;
  DateTime selectedDate = DateTime.now();

  final FocusNode _from = FocusNode();
  final FocusNode _to = FocusNode();
  final FocusNode _truckMaterial = FocusNode();
  final FocusNode _truckLoad = FocusNode();
  final FocusNode _truckQuote = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    materialController.dispose();
    truckLoadController.dispose();
    truckQuoteController.dispose();
    super.dispose();
  }

  void getNewCityFrom(String input) async {
    try {
      var result = await http.get(autoCompleteLink + input);
      suggestedCityFrom.clear();
      for (var i in json.decode(result.body)["predictions"]) {
        suggestedCityFrom.add(GooglePlaces.fromJson(i));
      }
      setState(() {});
    } catch (error) {
      print(error);
    }
  }

  void getNewCityTo(String input) async {
    try {
      var result = await http.get(autoCompleteLink + input);
      suggestedCityTo.clear();
      for (var i in json.decode(result.body)["predictions"]) {
        suggestedCityTo.add(GooglePlaces.fromJson(i));
      }
      setState(() {});
    } catch (error) {
      print(error);
    }
  }

  void getCategories() async {
    HTTPHandler().getTruckCategory().then((value) {
      setState(() {
        listOfCat = value;
      });
    });
  }

  Widget row(GooglePlaces gp) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            gp.description,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        Divider(),
      ],
    );
  }

  dataPicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 1000)),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
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
      body: (listOfCat.isEmpty)
          ? LoadingBody()
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 60.0,
                        ),
                        Text(
                          "Trip",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 40.0),
                        ),
                        Text(
                          "Planner",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 40.0),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                            width: 120,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 4, bottom: 4, left: 1.0),
                                  child: CircleAvatar(
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xff252427),
                                      size: 20.0,
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 11.5,
                                ),
                                Text(
                                  "One Way",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                              ],
                            )),
                        SizedBox(
                          height: 30.0,
                        ),
                        Form(
                          key: _formTripPlanner,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              fromTextField =
                                  AutoCompleteTextField<GooglePlaces>(
                                key: keyFrom,
                                textInputAction: TextInputAction.next,
                                focusNode: _from,
                                clearOnSubmit: false,
                                textChanged: (value) {
                                  getNewCityFrom(value);
                                },
                                suggestions: suggestedCityFrom,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(Icons.flight_takeoff),
                                  hintText: "From",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Colors.amber,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                                itemFilter: (item, query) {
                                  return true;
                                },
                                itemSorter: (a, b) {
                                  return a.description.compareTo(b.description);
                                },
                                itemSubmitted: (item) {
                                  setState(() {
                                    fromTextField.textField.controller.text =
                                        item.description;
                                  });
                                  _from.unfocus();
                                  FocusScope.of(context).requestFocus(_to);
                                },
                                itemBuilder: (context, item) {
                                  return row(item);
                                },
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              toTextField = AutoCompleteTextField<GooglePlaces>(
                                key: keyTo,
                                textInputAction: TextInputAction.done,
                                focusNode: _to,
                                clearOnSubmit: false,
                                textChanged: (value) {
                                  getNewCityTo(value);
                                },
                                suggestions: suggestedCityTo,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(Icons.flight_land),
                                  hintText: "To",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Colors.amber,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                                itemFilter: (item, query) {
                                  return true;
                                },
                                itemSorter: (a, b) {
                                  return a.description.compareTo(b.description);
                                },
                                itemSubmitted: (item) {
                                  setState(() {
                                    toTextField.textField.controller.text =
                                        item.description;
                                  });
                                },
                                itemBuilder: (context, item) {
                                  return row(item);
                                },
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              TextFormField(
                                readOnly: true,
                                onTap: () => dataPicker(context),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(Icons.flight_takeoff),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Colors.amber,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  suffixIcon: Icon(Icons.date_range),
                                  hintText: selectedDate.day.toString() + " / " + selectedDate.month.toString() + " / " + selectedDate.year.toString(),
                                ),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              DropdownButton(
                                isExpanded: true,
                                hint: Text("Select Truck Category", style: TextStyle(color: Colors.white),),
                                value: selectedTruckCategory,
                                dropdownColor: Color(0xff252427),
                                style: TextStyle(color: Colors.white),
                                underline: Container(
                                  height: 2,
                                  color: Colors.white,
                                ),
                                onChanged: (TruckCategory value) {
                                  setState(() {
                                    selectedTruckCategory = value;
                                  });
                                },
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
                                  controller: materialController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _truckMaterial,
                                  onFieldSubmitted: (term) {
                                    _truckMaterial.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(_truckLoad);
                                  },
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    errorStyle: TextStyle(color: Colors.white),
                                    prefixIcon: Icon(Icons.flight_land),
                                    hintText: "Material Type",
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
                                controller: truckLoadController,
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.next,
                                focusNode: _truckLoad,
                                onFieldSubmitted: (term) {
                                  _truckLoad.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(_truckQuote);
                                },
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(Icons.flight_land),
                                  hintText: "Truck Load (In Tons)",
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
                                controller: truckQuoteController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                focusNode: _truckQuote,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(Icons.flight_land),
                                  hintText: "Quote (Per Ton)",
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
                                height: 50.0,
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    if (_formTripPlanner.currentState
                                        .validate()) {
                                      final snackBar = SnackBar(
                                        content: Text('Request Sent'),
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50.0,
                                    child: Center(
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(
                                            color: Color(0xff252427),
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 2.0, color: Color(0xff252427)),
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
                      ],
                    ),
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.08,
                  minChildSize: 0.08,
                  maxChildSize: 0.9,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Hero(
                      tag: 'AnimeBottom',
                      child: Container(
                        margin: EdgeInsets.only(bottom: 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0)),
                        ),
                        child: AccountBottomSheetDummy(),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
