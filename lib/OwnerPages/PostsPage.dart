import 'package:flutter/material.dart';
import 'package:ownerapp/DialogScreens/DialogFailed.dart';
import 'package:ownerapp/DialogScreens/DialogProcessing.dart';
import 'package:ownerapp/DialogScreens/DialogSuccess.dart';
import 'package:ownerapp/HttpHandler.dart';
import 'package:ownerapp/Models/Bid.dart';
import 'package:ownerapp/Models/Posts.dart';
import 'package:ownerapp/Models/User.dart';
import 'package:toast/toast.dart';

enum BidStatus {
  newBid,
  updateBid,
}

class PostPage extends StatefulWidget {
  final UserOwner userOwner;

  PostPage({
    Key key,
    @required this.userOwner,
  }) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<Post> posts;
  var _bidController;
  List<Bid> bids;
  Bid b;
  bool gotValue1 = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _postBid(Post post) {
    print('posting bid');
    DialogProcessing().showCustomDialog(context,
        title: "Posting Bid", text: "Processing, Please Wait!");
    HTTPHandler()
        .postBid(widget.userOwner.oId, post.postId, _bidController.text)
        .then((value) async {
      Navigator.pop(context);
      if (value.success) {
        DialogSuccess().showCustomDialog(context, title: "Posting Bid");
        await Future.delayed(Duration(seconds: 1), () {});
        Navigator.pop(context);
        Navigator.pop(context);
        DialogProcessing().showCustomDialog(context,
            title: "Refreshing Bids", text: "Processing, Please Wait!");
        HTTPHandler().getBids(widget.userOwner.oId).then((value1) async {
          DialogSuccess().showCustomDialog(context, title: "Posting Bid");
          await Future.delayed(Duration(seconds: 1), () {});
          Navigator.pop(context);
          Navigator.pop(context);
          setState(() {
            bids = value1;
          });
        });
      } else {
        DialogFailed().showCustomDialog(context,
            title: "Posting Bid", text: value.message);
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      }
    }).catchError((error) async {
      print(error);
      Navigator.pop(context);
      DialogFailed().showCustomDialog(context,
          title: "Posting Bid", text: "Network Error");
      await Future.delayed(Duration(seconds: 3), () {});
      Navigator.pop(context);
    });
  }

  Bid checkBid(Post post) {
    for (Bid b in bids) if (b.loadId == post.postId) return b;

    return null;
  }

  void _updateBid(Bid b) {
    DialogProcessing().showCustomDialog(context,
        title: "Updating Bid", text: "Processing, Please Wait!");
    HTTPHandler().updateBid(b.bidId, _bidController.text).then((value) async {
      Navigator.pop(context);
      if (value.success) {
        DialogSuccess().showCustomDialog(context, title: "Posting Bid");
        await Future.delayed(Duration(seconds: 1), () {});
        Navigator.pop(context);
        Navigator.pop(context);
        DialogProcessing().showCustomDialog(context,
            title: "Refreshing Bids", text: "Processing, Please Wait!");
        HTTPHandler().getBids(widget.userOwner.oId).then((value1) async {
          DialogSuccess().showCustomDialog(context, title: "Refreshing Bid");
          await Future.delayed(Duration(seconds: 1), () {});
          Navigator.pop(context);
          Navigator.pop(context);
          setState(() {
            bids = value1;
          });
        });
      } else {
        DialogFailed().showCustomDialog(context,
            title: "Refreshing Bid", text: value.message);
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      }
    }).catchError((error) async {
      print(error);
      Navigator.pop(context);
      DialogFailed().showCustomDialog(context,
          title: "Refreshing Bid", text: "Network Error");
      await Future.delayed(Duration(seconds: 3), () {});
      Navigator.pop(context);
    });
  }

  void modal(Post e, BidStatus b, {Bid bid}) =>
      _scaffoldKey.currentState.showBottomSheet(
        (BuildContext context) => Container(
          padding: const EdgeInsets.only(bottom: 30.0),
          // height: 170.0,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                    top: 10.0,
                    left: 10.0,
                    right: 10.0,
                    // bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: TextField(
                    controller: _bidController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.dialpad),
                      labelText: "Expected Price",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () =>
                      (b == BidStatus.newBid) ? _postBid(e) : _updateBid(bid),
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                    ),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      'BID',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
      );

  @override
  void initState() {
    super.initState();
    _bidController = TextEditingController();
    HTTPHandler().getPosts().then((value) {
      setState(() {
        gotValue1 = true;
        this.posts = value;
      });
      HTTPHandler().getBids(widget.userOwner.oId).then((value1) {
        setState(() {
          bids = value1;
        });
      });
    });
  }

  @override
  void dispose() {
    _bidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: (!gotValue1)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : (posts == null)
              ? Center(
                  child: Text(
                    'No Posts Yet!',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Column(
                  children: posts
                      .map((e) => Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10.0,
                            ),
                            padding: const EdgeInsets.all(10.0),
                            width: MediaQuery.of(context).size.width,
                            height: 310.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('From'),
                                    Text(
                                      '${e.sources[0].source.substring(0, 20)}...',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('To'),
                                    Text(
                                      '${e.destinations[e.destinations.length - 1].destination.substring(0, 20)}...',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Material'),
                                    Text(
                                      '${e.material}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Tonnage'),
                                    Text(
                                      '${e.tonnage}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Truck Preferences'),
                                    Text(
                                      '${e.truckPreferences}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Expected Price'),
                                    Text(
                                      '${e.expectedPrice}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Payment Mode'),
                                    Text(
                                      '${e.paymentMode}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Created On'),
                                    Text(
                                      '${e.createdOn}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Expired On'),
                                    Text(
                                      '${e.expiredOn}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Contact Person'),
                                    Text(
                                      '${e.contactPerson}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Contact Person Phone No.'),
                                    Text(
                                      '${e.contactPersonPhone}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                Divider(),
                                Container(
                                  width: double.infinity,
                                  alignment: Alignment.centerRight,
                                  child: (bids == null)
                                      ? CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Theme.of(context).primaryColor),
                                        )
                                      : ((b = checkBid(e)) != null)
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text('Your Bid'),
                                                    SizedBox(width: 10.0),
                                                    GestureDetector(
                                                      onTap: () {
                                                        _bidController
                                                            .text = bids[
                                                                bids.indexWhere(
                                                                    (element) =>
                                                                        element
                                                                            .loadId ==
                                                                        e.postId)]
                                                            .price;
                                                        modal(
                                                          e,
                                                          BidStatus.updateBid,
                                                          bid: bids[bids.indexWhere(
                                                              (element) =>
                                                                  element
                                                                      .loadId ==
                                                                  e.postId)],
                                                        );
                                                      },
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.0),
                                                    GestureDetector(
                                                      onTap: () {
                                                        DialogProcessing()
                                                            .showCustomDialog(
                                                                context,
                                                                title:
                                                                    "Deleting Bid",
                                                                text:
                                                                    "Processing, Please Wait!");
                                                        HTTPHandler()
                                                            .deleteBid(bids[bids.indexWhere(
                                                                    (element) =>
                                                                        element
                                                                            .loadId ==
                                                                        e
                                                                            .postId)]
                                                                .bidId)
                                                            .then(
                                                                (value) async {
                                                          Navigator.pop(
                                                              context);
                                                          if (value.success) {
                                                            DialogSuccess()
                                                                .showCustomDialog(
                                                                    context,
                                                                    title:
                                                                        "Deleting Bid");
                                                            await Future
                                                                .delayed(
                                                                    Duration(
                                                                        seconds:
                                                                            1),
                                                                    () {});
                                                            Navigator.pop(
                                                                context);
                                                            DialogProcessing()
                                                                .showCustomDialog(
                                                                    context,
                                                                    title:
                                                                        "Refreshing Bids",
                                                                    text:
                                                                        "Processing, Please Wait!");
                                                            HTTPHandler()
                                                                .getBids(widget
                                                                    .userOwner
                                                                    .oId)
                                                                .then(
                                                                    (value1) async {
                                                              DialogSuccess()
                                                                  .showCustomDialog(
                                                                      context,
                                                                      title:
                                                                          "Refreshing Bid");
                                                              await Future.delayed(
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                                  () {});
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.pop(
                                                                  context);
                                                              setState(() {
                                                                bids = value1;
                                                              });
                                                            });
                                                          } else {
                                                            DialogFailed()
                                                                .showCustomDialog(
                                                                    context,
                                                                    title:
                                                                        "Deleting Bid",
                                                                    text: value
                                                                        .message);
                                                            await Future
                                                                .delayed(
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                                    () {});
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        }).catchError(
                                                                (error) async {
                                                          print(error);
                                                          Navigator.pop(
                                                              context);
                                                          DialogFailed()
                                                              .showCustomDialog(
                                                                  context,
                                                                  title:
                                                                      "Deleting Bid",
                                                                  text:
                                                                      "Network Error");
                                                          await Future.delayed(
                                                              Duration(
                                                                  seconds: 3),
                                                              () {});
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  '${b.price}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ],
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                print('bid now');
                                                if (widget.userOwner
                                                        .oSubscriptionStatus ==
                                                    'Not on subcsription')
                                                  Toast.show(
                                                    'You need an active Subscription Plan',
                                                    context,
                                                    duration: Toast.LENGTH_LONG,
                                                    gravity: Toast.CENTER,
                                                  );
                                                else {
                                                  print('start');
                                                  modal(e, BidStatus.newBid);
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 40.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black87,
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                child: Text(
                                                  'Bid',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                )
                              ],
                            ),
                          ))
                      .toList(),
                ),
    );
  }
}
