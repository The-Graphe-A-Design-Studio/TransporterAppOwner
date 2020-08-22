import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ownerapp/BottomSheets/AccountBottomSheetLoggedOut.dart';
import 'package:ownerapp/MyConstants.dart';

class IntroPageLoginOptions extends StatefulWidget {
  IntroPageLoginOptions({Key key}) : super(key: key);

  @override
  _IntroPageLoginOptionsState createState() => _IntroPageLoginOptionsState();
}

class _IntroPageLoginOptionsState extends State<IntroPageLoginOptions> {
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
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 75.0,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: "WhiteLogo",
                        child: Image(
                          image: AssetImage('assets/images/logo_white.png'),
                          height: 145.0,
                          width: 145.0,
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        "Choose Your Account Type",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.width * 0.35,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, ownerOptionPage);
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: MediaQuery.of(context).size.width * 0.38,
                                height:
                                    MediaQuery.of(context).size.width * 0.35,
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 18.0, bottom: 10.0),
                                    child: Text(
                                      "Truck Owner",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0),
                                    ),
                                  ),
                                )),
                          ),
                        ],
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
                    child: AccountBottomSheetLoggedOut(
                        scrollController: scrollController)),
              );
            },
          ),
        ],
      ),
    );
  }
}
