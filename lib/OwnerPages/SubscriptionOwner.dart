import 'package:flutter/material.dart';
import 'package:ownerapp/Models/SubscriptionPlan.dart';
import 'package:ownerapp/Models/User.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ownerapp/MyConstants.dart';
import 'package:ownerapp/HttpHandler.dart';
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
        .generateRazorpayOrderId((s.planSellingPrice * 100).round())
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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment Id => ${response.paymentId}');
    print('Order Id => ${response.orderId}');
    print('Signature => ${response.signature}');

    HTTPHandler().storeData(widget.userOwner, selected, response).then((value) {
      if (value.success) {
        Toast.show(
          'You will be logged once your subscription is verified. Please login again!',
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG,
        );
        Future.delayed(
          Duration(milliseconds: 900),
          () => HTTPHandler().signOut(context, widget.userOwner.oPhone),
        );
      } else
        print('error');
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Success => $response');
    Navigator.of(context).popAndPushNamed('/Home');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('Success => $response');
    Navigator.of(context).popAndPushNamed('/Home');
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    if (!subscriptionController) getData();

    return Scaffold(
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
          : Column(
              children: _plans
                  .map(
                    (e) => Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 10.0,
                      ),
                      padding: const EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width,
                      height: 155.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Original Price'),
                              Text(
                                '${e.planOriginalPrice}',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Selling Price'),
                              Text(
                                '${e.planSellingPrice}',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Discount'),
                              Text(
                                '${e.planDiscount}',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Duration'),
                              Text(
                                '${e.duration}',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          Divider(),
                          Container(
                            width: double.infinity,
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                print('buy now');
                                _openCheckOut(e);
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
    );
  }
}
