import 'package:flutter/material.dart';
import 'package:ownerapp/Models/SubscriptionPlan.dart';
import 'package:ownerapp/Models/User.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ownerapp/MyConstants.dart';
import 'package:ownerapp/HttpHandler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

enum CouponStatus {
  notChecked,
  checking,
  exists,
  notExists,
  applied,
}

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
  String coupon = '';
  double selectedPlanPrice;
  TextEditingController couponCode;

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

  void _openCheckOut(SubscriptionPlan s, double price) async {
    selected = s;
    selectedPlanPrice = price;
    HTTPHandler().generateRazorpayOrderId((price * 100).round()).then((value) {
      var options = {
        'key': RAZORPAY_ID,
        'amount': (price * 100).round(),
        'order_id': value,
        'name': widget.userOwner.oName,
        'description': 'TruckWale',
        'prefill': {
          'contact': widget.userOwner.oPhone,
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
        .storeData(
      '2',
      widget.userOwner,
      selected,
      selectedPlanPrice,
      response,
      coupon,
    )
        .then((value) {
      if (value.success) {
        Navigator.of(context).pop();
        reloadUser();
      } else
        print('error');
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Success => $response');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('Success => $response');
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
    couponCode = TextEditingController();
  }

  void getStats() {
    subscriptionStatus = owner.oSubscriptionStatus;
    if (owner.planType != '0')
      subscriptionEnd = DateTime.parse(owner.oSubscriptionUpto);
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
    Map couponData;
    CouponStatus status = CouponStatus.notChecked;

    double sellingPrice = p.planSellingPrice;
    double finalPrice = double.parse(p.finalPrice);

    _scaffoldKey.currentState.showBottomSheet((context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setSheetState) {
          return Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 310.0,
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
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
                item('Selling Price', 'Rs. ${sellingPrice.toStringAsFixed(2)}'),
                item('GST', '18 %'),
                item('Final Price', 'Rs. ${finalPrice.toStringAsFixed(2)}'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: couponCode,
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ),
                    SizedBox(width: 5.0),
                    GestureDetector(
                      onTap: () {
                        if (couponCode.text == '')
                          Toast.show('Coupon Code required', context);
                        else {
                          setSheetState(() {
                            status = CouponStatus.checking;
                          });
                          HTTPHandler()
                              .checkCoupon(
                            couponCode.text,
                            widget.userOwner.oId,
                            '2',
                          )
                              .then((value) {
                            print(value);
                            if (value['success'] == '1') {
                              coupon = couponCode.text;
                              status = CouponStatus.exists;
                              couponData = value;
                              sellingPrice = (sellingPrice *
                                  (1 -
                                      (int.parse(couponData['discount']
                                              .split('%')[0])) /
                                          100));
                              finalPrice = sellingPrice + (0.18 * sellingPrice);
                            } else
                              status = CouponStatus.notExists;

                            couponCode.text = '';

                            setSheetState(() {});
                          });
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 5.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            border: Border.all(
                              width: 0.5,
                              color: Colors.black87,
                            ),
                          ),
                          child: Text((status == CouponStatus.notChecked)
                              ? 'APPLY'
                              : (status == CouponStatus.exists)
                                  ? 'APPLIED'
                                  : 'APPLYING')),
                    ),
                  ],
                ),
                if (status == CouponStatus.exists)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Discount of : ${couponData['discount']}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                if (status == CouponStatus.notExists)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Coupon doesn\'t exist',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                SizedBox(height: 12.0),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    _openCheckOut(p, finalPrice);
                  },
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
          );
        },
      );
    });
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
