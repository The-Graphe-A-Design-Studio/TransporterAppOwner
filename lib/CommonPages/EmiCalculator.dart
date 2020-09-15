import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/BottomSheets/AccountBottomSheetDummy.dart';

class EmiCalculator extends StatefulWidget {
  EmiCalculator({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EmiCalculatorState createState() => _EmiCalculatorState();
}

class _EmiCalculatorState extends State<EmiCalculator> {
  final GlobalKey<FormState> _formEmiCalculator = GlobalKey<FormState>();

  String brandSelected = "Select Brand";
  String modelSelected = "Select Model";

  @override
  void initState() {
    super.initState();
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
                        "EMI",
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
                        key: _formEmiCalculator,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            DropdownButton<String>(
                              value: brandSelected,
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
                                  brandSelected = newValue;
                                });
                              },
                              items: <String>[
                                'Select Brand',
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
                              height: 16.0,
                            ),
                            DropdownButton<String>(
                              value: modelSelected,
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
                                  modelSelected = newValue;
                                });
                              },
                              items: <String>[
                                'Select Model',
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
                                  if (_formEmiCalculator.currentState
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
                  // child: AccountBottomSheetDummy(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
