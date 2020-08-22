import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ownerapp/BottomSheets/AccountBottomSheetDummy.dart';
import 'package:ownerapp/Models/GooglePlaces.dart';
import 'package:ownerapp/MyConstants.dart';

class TollCalculator extends StatefulWidget {
  TollCalculator({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TollCalculatorState createState() => _TollCalculatorState();
}

class _TollCalculatorState extends State<TollCalculator> {
  GlobalKey<AutoCompleteTextFieldState<GooglePlaces>> keyFrom = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<GooglePlaces>> keyTo = new GlobalKey();
  final GlobalKey<FormState> _formTollCalculator = GlobalKey<FormState>();

  AutoCompleteTextField fromTextField;
  AutoCompleteTextField toTextField;
  String vehicleTypeSelected = "Select Vehicle Type";
  List<GooglePlaces> suggestedCityFrom = [];
  List<GooglePlaces> suggestedCityTo = [];

  final FocusNode _from = FocusNode();
  final FocusNode _to = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252427),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
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
                        "Toll",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 40.0),
                      ),
                      Text(
                        "Calculator",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 40.0),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Form(
                        key: _formTollCalculator,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            fromTextField = AutoCompleteTextField<GooglePlaces>(
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
                            SizedBox(height: 16.0,),
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
                            DropdownButton<String>(
                              value: vehicleTypeSelected,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 40,
                              elevation: 30,
                              isExpanded: true,
                              dropdownColor: Color(0xff252427),
                              style: TextStyle(color: Colors.white),
                              underline: Container(
                                height: 2,
                                color: Colors.white,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  vehicleTypeSelected = newValue;
                                });
                              },
                              items: <String>[
                                'Select Vehicle Type',
                                'One',
                                'Two',
                                'Free',
                                'Four'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  if (_formTollCalculator.currentState
                                      .validate()) {
                                    final snackBar = SnackBar(
                                      content: Text('Request Sent'),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
