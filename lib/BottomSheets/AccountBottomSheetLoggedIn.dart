import 'package:carousel_slider/carousel_slider.dart';
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

final List<String> imgList = [
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class _AccountBottomSheetLoggedInState
    extends State<AccountBottomSheetLoggedIn> {
  @override
  void initState() {
    super.initState();
  }

  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Material(
                            child: Text(
                              'No. ${imgList.indexOf(item)} image',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();

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
          ListTile(
            onTap: () {
              Navigator.pushNamed(
                context,
                subscriptionOwner,
                arguments: widget.userOwner,
              );
            },
            leading: Icon(Icons.toc),
            title: Text(
              'Your Subscription',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'View Plan',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          ListTile(
            onTap: () {
              HTTPHandler().signOut(
                context,
                widget.userOwner.oPhone,
              );
            },
            leading: Icon(Icons.logout),
            title: Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // return Padding(
          //   padding: EdgeInsets.only(left: 16.0, right: 16.0),
          //   child: ListView(
          //     controller: widget.scrollController,
          //     children: <Widget>[
          //       Align(
          //         alignment: Alignment.topCenter,
          //         child: Container(
          //           width: 60.0,
          //           height: 4.0,
          //           decoration: BoxDecoration(
          //             color: Colors.grey,
          //             borderRadius: BorderRadius.circular(30.0),
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         height: 40.0,
          //       ),
          //       Padding(
          //         padding: EdgeInsets.only(left: 16.0),
          //         child: Material(
          //           child: Text(
          //             "Plan Your Trip",
          //             style: TextStyle(
          //               fontSize: 23.0,
          //               fontWeight: FontWeight.bold,
          //               color: Colors.black,
          //             ),
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         height: 15.0,
          //       ),
          //       Container(
          //         height: 150.0,
          //         child: ListView(
          //           padding: EdgeInsets.only(right: 16.0, left: 16.0),
          //           scrollDirection: Axis.horizontal,
          //           children: <Widget>[
          //             Material(
          //               child: InkWell(
          //                 onTap: () {
          //                   Navigator.pushNamed(context, tripPlannerPage);
          //                 },
          //                 child: Container(
          //                   width: 160,
          //                   decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.circular(10.0),
          //                       border:
          //                           Border.all(color: Color(0xff252427), width: 3.0),
          //                       color: Colors.transparent),
          //                   child: Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Spacer(),
          //                       Align(
          //                         alignment: Alignment.center,
          //                         child: CircleAvatar(
          //                           radius: 30.0,
          //                           backgroundColor: Color(0xff252427),
          //                           child: Icon(
          //                             Icons.link,
          //                             color: Colors.white,
          //                             size: 30.0,
          //                           ),
          //                         ),
          //                       ),
          //                       Spacer(),
          //                       Align(
          //                         alignment: Alignment.center,
          //                         child: Material(
          //                           child: Text(
          //                             "Trip Planner",
          //                             style: TextStyle(
          //                               fontSize: 16.0,
          //                               fontWeight: FontWeight.bold,
          //                               color: Color(0xff252427),
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                       SizedBox(
          //                         height: 10.0,
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             SizedBox(
          //               width: 16.0,
          //             ),
          //             Material(
          //               child: InkWell(
          //                 onTap: () {
          //                   Navigator.pushNamed(context, freightCalculatorPage);
          //                 },
          //                 child: Container(
          //                   width: 160,
          //                   decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.circular(10.0),
          //                       border:
          //                           Border.all(color: Color(0xff252427), width: 3.0),
          //                       color: Colors.transparent),
          //                   child: Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Spacer(),
          //                       Align(
          //                         alignment: Alignment.center,
          //                         child: CircleAvatar(
          //                           radius: 30.0,
          //                           backgroundColor: Color(0xff252427),
          //                           child: Icon(
          //                             Icons.link,
          //                             color: Colors.white,
          //                             size: 30.0,
          //                           ),
          //                         ),
          //                       ),
          //                       Spacer(),
          //                       Align(
          //                         alignment: Alignment.center,
          //                         child: Material(
          //                           child: Text(
          //                             "Freight Calculator",
          //                             style: TextStyle(
          //                               fontSize: 16.0,
          //                               fontWeight: FontWeight.bold,
          //                               color: Color(0xff252427),
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                       SizedBox(
          //                         height: 10.0,
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             SizedBox(
          //               width: 16.0,
          //             ),
          //             Material(
          //               child: InkWell(
          //                 onTap: () {
          //                   Navigator.pushNamed(context, tollCalculatorPage);
          //                 },
          //                 child: Container(
          //                   width: 160,
          //                   decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.circular(10.0),
          //                       border:
          //                           Border.all(color: Color(0xff252427), width: 3.0),
          //                       color: Colors.transparent),
          //                   child: Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Spacer(),
          //                       Align(
          //                         alignment: Alignment.center,
          //                         child: CircleAvatar(
          //                           radius: 30.0,
          //                           backgroundColor: Color(0xff252427),
          //                           child: Icon(
          //                             Icons.link,
          //                             color: Colors.white,
          //                             size: 30.0,
          //                           ),
          //                         ),
          //                       ),
          //                       Spacer(),
          //                       Align(
          //                         alignment: Alignment.center,
          //                         child: Material(
          //                           child: Text(
          //                             "Toll Calculator",
          //                             style: TextStyle(
          //                               fontSize: 16.0,
          //                               fontWeight: FontWeight.bold,
          //                               color: Color(0xff252427),
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                       SizedBox(
          //                         height: 10.0,
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             SizedBox(
          //               width: 16.0,
          //             ),
          //             Material(
          //               child: InkWell(
          //                 onTap: () {
          //                   Navigator.pushNamed(context, emiCalculatorPage);
          //                 },
          //                 child: Container(
          //                   width: 160,
          //                   decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.circular(10.0),
          //                       border:
          //                           Border.all(color: Color(0xff252427), width: 3.0),
          //                       color: Colors.transparent),
          //                   child: Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Spacer(),
          //                       Align(
          //                         alignment: Alignment.center,
          //                         child: CircleAvatar(
          //                           radius: 30.0,
          //                           backgroundColor: Color(0xff252427),
          //                           child: Icon(
          //                             Icons.link,
          //                             color: Colors.white,
          //                             size: 30.0,
          //                           ),
          //                         ),
          //                       ),
          //                       Spacer(),
          //                       Align(
          //                         alignment: Alignment.center,
          //                         child: Material(
          //                           child: Text(
          //                             "EMI Calculator",
          //                             style: TextStyle(
          //                               fontSize: 16.0,
          //                               fontWeight: FontWeight.bold,
          //                               color: Color(0xff252427),
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                       SizedBox(
          //                         height: 10.0,
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       SizedBox(
          //         height: 20.0,
          //       ),
          //       Padding(
          //         padding: EdgeInsets.only(left: 16.0),
          //         child: Material(
          //           child: Text(
          //             "Upcoming Orders",
          //             style: TextStyle(
          //               fontSize: 23.0,
          //               fontWeight: FontWeight.bold,
          //               color: Colors.black,
          //             ),
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         height: 5.0,
          //       ),
          //       Padding(
          //         padding: EdgeInsets.only(left: 16.0),
          //         child: Material(
          //           child: Text(
          //             "Select an Order to view",
          //             style: TextStyle(
          //               color: Colors.black12,
          //               fontSize: 18.0,
          //             ),
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         height: 15.0,
          //       ),
          //       Container(
          //         child: Column(
          //           children: <Widget>[
          //             CarouselSlider(
          //               options: CarouselOptions(
          //                 autoPlay: false,
          //                 enableInfiniteScroll: false,
          //                 aspectRatio: 2.0,
          //                 enlargeCenterPage: true,
          //               ),
          //               items: imageSliders,
          //             ),
          //           ],
          //         ),
          //       ),

          //       SizedBox(
          //         height: 20.0,
          //       ),
          //       Padding(
          //         padding: EdgeInsets.only(left: 16.0),
          //         child: Material(
          //           child: Text(
          //             "Temporary Links",
          //             style: TextStyle(
          //               fontSize: 23.0,
          //               fontWeight: FontWeight.bold,
          //               color: Colors.black,
          //             ),
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         height: 15.0,
          //       ),
          //       Row(
          //         children: [
          //           Text(
          //               "Sign Out"
          //           ),
          //           Spacer(),
          //           FlatButton(
          //             onPressed: () {
          //               HTTPHandler().signOut(context);
          //             },
          //             child: Text("Link"),
          //           )
          //         ],
          //       ),
          //       SizedBox(
          //         height: 8.0,
          //       ),
          //       Row(
          //         children: [
          //           Text(
          //             "Driver Upcoming Order"
          //           ),
          //           Spacer(),
          //           FlatButton(
          //             onPressed: () {
          //               Navigator.pushNamed(context, driverUpcomingOrderPage);
          //             },
          //             child: Text("Link"),
          //           )
          //         ],
          //       ),
          //       SizedBox(
          //         height: 8.0,
          //       ),
          //       Row(
          //         children: [
          //           Text(
          //               "New Transporting Order"
          //           ),
          //           Spacer(),
          //           FlatButton(
          //             onPressed: () {
          //               Navigator.pushNamed(context, newTransportingOrderPage);
          //             },
          //             child: Text("Link"),
          //           )
          //         ],
          //       ),
          //       SizedBox(
          //         height: 8.0,
          //       ),
          //       Row(
          //         children: [
          //           Text(
          //               "Order Summary Page"
          //           ),
          //           Spacer(),
          //           FlatButton(
          //             onPressed: () {
          //               Navigator.pushNamed(context, orderSummaryPage);
          //             },
          //             child: Text("Link"),
          //           )
          //         ],
          //       ),
          //       SizedBox(
          //         height: 8.0,
          //       ),
          //       Row(
          //         children: [
          //           Text(
          //               "Request Transport"
          //           ),
          //           Spacer(),
          //           FlatButton(
          //             onPressed: () {
          //               Navigator.pushNamed(context, requestTransportPage);
          //             },
          //             child: Text("Link"),
          //           )
          //         ],
          //       ),
          //       SizedBox(
          //         height: 40.0,
          //       ),
        ],
      ),
    );
  }
}
