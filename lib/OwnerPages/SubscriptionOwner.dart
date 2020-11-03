import 'package:flutter/material.dart';
import 'package:ownerapp/Models/SubscriptionPlan.dart';
import 'package:ownerapp/Models/User.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ownerapp/MyConstants.dart';
import 'package:ownerapp/HttpHandler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class SubscriptionOwner extends StatefulWidget {
  final UserOwner userOwner;

  SubscriptionOwner({
    Key key,
    @required this.userOwner,
  }) : super(key: key);

  @override
  _SubscriptionOwnerState createState() => _SubscriptionOwnerState();
}

class _SubscriptionOwnerState extends State<SubscriptionOwner> {
  bool subscriptionController = false;
  List<SubscriptionPlan> _plans;
  Razorpay _razorpay;
  SubscriptionPlan selected;

  DateTime subscriptionEnd;
  String subscriptionStatus;

  var _scaffoldKey = GlobalKey<ScaffoldState>();
  UserOwner owner;

  getData() async {
    subscriptionController = true;
    await HTTPHandler()
        .getSubscriptionPlans()
        .then((value) => this._plans = value);
    setState(() {});
  }

  void _openCheckOut(SubscriptionPlan s) async {
    selected = s;
    HTTPHandler()
        .generateRazorpayOrderId((double.parse(s.finalPrice) * 100).round())
        .then((value) {
      var options = {
        'key': RAZORPAY_ID,
        'amount': (s.planSellingPrice * 100).round(),
        'order_id': value,
        'name': widget.userOwner.oName,
        'description': 'TruckWale',
        'prefill': {
          'contact': widget.userOwner.oPhone,
          'email': 'rishav@thegraphe.com',
        },
      };

      try {
        _razorpay.open(options);
      } catch (e) {
        debugPrint(e);
        throw e;
      }
    });
  }

  void reloadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    HTTPHandler().registerVerifyOtpOwner(
        [owner.oPhone, prefs.getString('otp'), true]).then((value) {
      setState(() {
        this.owner = value;
        getStats();
      });
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment Id => ${response.paymentId}');
    print('Order Id => ${response.orderId}');
    print('Signature => ${response.signature}');

    HTTPHandler()
        .storeData('2', widget.userOwner, selected, response)
        .then((value) {
      if (value.success) {
        Navigator.of(context).pop();
        // Toast.show(
        //   'You will be logged out to verify your identity. Please login again!',
        //   context,
        //   gravity: Toast.CENTER,
        //   duration: Toast.LENGTH_LONG,
        // );
        // Future.delayed(
        //   Duration(milliseconds: 900),
        //   () => HTTPHandler().signOut(context, widget.userOwner.oPhone),
        // );
        reloadUser();
      } else
        print('error');
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Success => $response');
    Navigator.of(context).popAndPushNamed(
      '/homePageOwner',
      arguments: widget.userOwner,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('Success => $response');
    Navigator.of(context).popAndPushNamed(
      '/homePageOwner',
      arguments: widget.userOwner,
    );
  }

  @override
  void initState() {
    super.initState();
    owner = widget.userOwner;
    getStats();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void getStats() {
    subscriptionStatus = owner.oSubscriptionStatus;
    if (owner.planType != '0')
      subscriptionEnd = DateTime.parse(owner.oSubscriptionUpto);
  }

  Future<void> _getData() async => getData();

  @override
  Widget build(BuildContext context) {
    if (!subscriptionController) getData();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Your Subscriptions',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: (_plans == null)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : RefreshIndicator(
              onRefresh: _getData,
              color: Colors.black,
              backgroundColor: Colors.white,
              child: ListView(
                children: [
                  if (subscriptionStatus != null)
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 10.0,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            alignment: Alignment.center,
                            child: (subscriptionStatus ==
                                        'Not on subscription' ||
                                    owner.planType == '0')
                                ? Text(
                                    subscriptionStatus,
                                    style: TextStyle(color: Colors.grey),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        // width: 100.0,
                                        height: 30.0,
                                        alignment: Alignment.center,
                                        child: Text(
                                          subscriptionStatus,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      Text(
                                        '${subscriptionEnd.difference(DateTime.now()).inDays} days left',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 20,
                            alignment: Alignment.center,
                            child: Text(
                              (subscriptionStatus == 'Not on subscription' ||
                                      owner.planType == '0')
                                  ? 'Ends on 0-0-0'
                                  : 'Ends on \n${subscriptionEnd.day} - ${subscriptionEnd.month} - ${subscriptionEnd.year}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  Column(
                    children: _plans
                        .map(
                          (e) => Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10.0,
                            ),
                            padding: const EdgeInsets.all(10.0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Plan ${_plans.indexOf(e) + 1} :',
                                    ),
                                    Text(
                                      e.planName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Duration',
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          '${e.duration}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Price',
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Row(
                                          children: [
                                            Text(
                                              '${e.planSellingPrice}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                            SizedBox(width: 3.0),
                                            Text(
                                              '${e.planOriginalPrice}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(),
                                Container(
                                  width: double.infinity,
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      print('buy now');
                                      _openModal(e);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.black87,
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Text(
                                        'Buy Now',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
    );
  }

  void _openModal(SubscriptionPlan p) {
    _scaffoldKey.currentState.showBottomSheet((context) => Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: 250.0,
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Plan Details'),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.close),
                  ),
                ],
              ),
              Divider(),
              item('Duration', p.duration),
              item('Original Price', 'Rs. ${p.planOriginalPrice}'),
              item('Selling Price', 'Rs. ${p.planSellingPrice}'),
              item('GST', '18 %'),
              item('Final Price', 'Rs. ${double.parse(p.finalPrice)}'),
              SizedBox(height: 12.0),
              GestureDetector(
                onTap: () => _openCheckOut(p),
                child: Container(
                  width: double.infinity,
                  height: 40.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget item(String title, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
}
