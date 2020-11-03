import 'package:flutter/material.dart';
import 'package:ownerapp/Models/SubscriptionPlan.dart';
import 'package:ownerapp/Models/User.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../HttpHandler.dart';
import '../MyConstants.dart';

class AddOnTruckPlansPage extends StatefulWidget {
  final UserOwner userOwner;

  AddOnTruckPlansPage({Key key, @required this.userOwner}) : super(key: key);

  @override
  _AddOnTruckPlansPageState createState() => _AddOnTruckPlansPageState();
}

class _AddOnTruckPlansPageState extends State<AddOnTruckPlansPage> {
  bool subscriptionController = false;
  List<SubscriptionPlan> _plans;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  Razorpay _razorpay;
  SubscriptionPlan selected;
  UserOwner owner;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _openCheckOut(SubscriptionPlan s) async {
    selected = s;
    HTTPHandler()
        .generateRazorpayOrderId((double.parse(s.finalPrice) * 100).round())
        .then((value) {
      print(value);
      var options = {
        'key': RAZORPAY_ID,
        'amount': (double.parse(s.finalPrice) * 100).round(),
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
      });
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment Id => ${response.paymentId}');
    print('Order Id => ${response.orderId}');
    print('Signature => ${response.signature}');

    HTTPHandler().storeData('3', owner, selected, response).then((value) {
      if (value.success) {
        Navigator.of(context).pop();
        reloadUser();
        Toast.show(
          'Payment Successful',
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG,
        );
        // Future.delayed(
        //   Duration(milliseconds: 900),
        //   () => HTTPHandler().signOut(context, owner.oPhone),
        // );
      } else
        print('error');
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Success => $response');
    Navigator.of(context).popAndPushNamed(
      '/homePageOwner',
      arguments: owner,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('Success => $response');
    Navigator.of(context).popAndPushNamed(
      '/homePageOwner',
      arguments: owner,
    );
  }

  @override
  void initState() {
    super.initState();
    owner = widget.userOwner;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  getData() async {
    subscriptionController = true;
    await HTTPHandler().getAddOnPlans().then((value) => this._plans = value);
    setState(() {});
  }

  Future<void> _getData() async {
    reloadUser();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    if (!subscriptionController) getData();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add On Trucks'),
      ),
      body: (_plans == null)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : SmartRefresher(
              controller: _refreshController,
              onRefresh: () => _getData(),
              child: Column(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'No. of Trucks',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      '${e.quantity}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    borderRadius: BorderRadius.circular(5.0),
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
              item('No. of Trucks', p.quantity),
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
