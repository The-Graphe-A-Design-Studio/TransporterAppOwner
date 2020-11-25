import 'dart:convert';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ownerapp/DialogScreens/DialogProcessing.dart';
import 'package:ownerapp/DialogScreens/DialogSuccess.dart';
import 'package:ownerapp/Models/Bid.dart';
import 'package:ownerapp/Models/Deliveries.dart';
import 'package:ownerapp/Models/Posts.dart';
import 'package:ownerapp/Models/Truck.dart';
import 'package:ownerapp/Models/TruckCategory.dart';
import 'package:ownerapp/Models/TruckCategoryType.dart';
import 'package:ownerapp/Models/User.dart';
import 'package:ownerapp/MyConstants.dart';
import 'package:ownerapp/PostMethodResult.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/SubscriptionPlan.dart';

class HTTPHandler {
  final _random = new Random();

  String baseURLDriver =
      'https://developers.thegraphe.com/transport/api/drivers';
  String baseURLOwner = 'https://truckwale.co.in/api/truck_owner';
  String baseURLCustomer = 'https://truckwale.co.in/api/customer';

  void signOut(BuildContext context, var mobileNo) async {
    DialogProcessing().showCustomDialog(context,
        title: "Sign Out", text: "Processing, Please Wait!");
    http.post('$baseURLOwner/owner_enter_exit',
        body: {'logout_number': mobileNo}).then((_) async {
      await SharedPreferences.getInstance()
          .then((value) => value.setBool("rememberMe", false));
      await Future.delayed(Duration(seconds: 1), () {});
      Navigator.pop(context);
      DialogSuccess().showCustomDialog(context, title: "Sign Out");
      await Future.delayed(Duration(seconds: 1), () {});
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(
          context, ownerOptionPage, (route) => false);
    }).catchError((e) => throw e);
  }

  void saveLocalChangesOwner(UserOwner userOwner) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', json.encode(userOwner.toJson()));
  }

  /*-------------------------- Owner API's ---------------------------*/
  Future<PostResultOne> registerOwner(List data) async {
    try {
      var result = await http.post('$baseURLOwner/owner_enter_exit', body: {
        'to_phone_code': data[0],
        'to_phone': data[1],
        'to_token': data[2],
      });

      print(result);

      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<UserOwner> registerVerifyOtpOwner(List data) async {
    try {
      var result = await http.post("$baseURLOwner/owner_verification",
          body: {'phone_number': data[0], 'otp': data[1]});
      print(result.body);
      UserOwner owner = UserOwner.fromJson(json.decode(result.body));
      print(data[2]);
      if (owner.success) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('rememberMe', data[2]);
        prefs.setString('userType', truckOwnerUser);
        prefs.setString('userData', result.body);
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('rememberMe', false);
      }
      return owner;
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> registerResendOtpOwner(List data) async {
    try {
      var result = await http.post("$baseURLOwner/owner_verification", body: {
        'resend_otp': data[0],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> loginOwner(List data) async {
    try {
      final fcm = FirebaseMessaging();
      fcm.requestNotificationPermissions();
      fcm.configure();
      var token = await fcm.getToken();
      print('token => $token');
      var result = await http.post('$baseURLOwner/owner_enter_exit', body: {
        'to_phone_code': data[0],
        'to_phone': data[1],
        'to_token': token,
      });

      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> editOwnerInfo(List data) async {
    try {
      var result = await http.post("$baseURLOwner/profile", body: {
        'to_id': data[0],
        'to_name': data[1],
        'to_phone_code': data[2],
        'to_phone': data[3],
        'to_email': data[4],
        'to_address': data[5],
        'to_city': data[6],
        'to_operating_routes': data[7],
        'to_state_permits': data[8],
        'to_pan': data[9],
        'to_bank': data[10],
        'to_ifsc': data[11]
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> editOwnerInfoVerifyOTP(List data) async {
    try {
      var result = await http.post("$baseURLOwner/profile", body: {
        'to_id': data[0],
        'phone_number': data[1],
        'otp': data[2],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> editOwnerInfoResendOTP(List data) async {
    try {
      var result = await http.post("$baseURLOwner/profile", body: {
        'resend_otp': data[0],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> editOwnerInfoChangePassword(List data) async {
    try {
      var result = await http.post("$baseURLOwner/profile", body: {
        'to_id': data[0],
        'curr_password': data[1],
        'new_password': data[2],
        'cnf_new_password': data[3],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  /*-------------------------- Truck API's ---------------------------*/
  Future<List<TruckCategory>> getTruckCategory() async {
    try {
      var result =
          await http.get("https://truckwale.co.in/api/truck_categories");
      var ret = json.decode(result.body);
      List<TruckCategory> list = [];
      for (var i in ret) {
        list.add(TruckCategory.fromJson(i));
      }
      return list;
    } catch (error) {
      throw error;
    }
  }

  Future<List<TruckCategoryType>> getTruckCategoryType(
      String truckCategory) async {
    try {
      var result = await http.post(
        "https://truckwale.co.in/api/truck_category_type",
        body: {'truck_cat_id': truckCategory},
      );

      var ret = json.decode(result.body);
      List<TruckCategoryType> list = [];
      for (var i in ret) {
        list.add(TruckCategoryType.fromJson(i));
      }
      return list;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<PostResultOne> addTrucksOwner(List data) async {
    try {
      var url = "$baseURLOwner/trucks";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['trk_owner'] = data[0];
      request.fields['trk_cat'] = data[1];
      request.fields['trk_cat_type'] = data[2];
      request.fields['trk_num'] = data[3];
      request.fields['trk_dr_name'] = data[4];
      request.fields['trk_dr_phone_code'] = data[5];
      request.fields['trk_dr_phone'] = data[6];
      request.files.add(await http.MultipartFile.fromPath('trk_rc', data[7]));
      request.files
          .add(await http.MultipartFile.fromPath('trk_insurance', data[8]));
      request.files
          .add(await http.MultipartFile.fromPath('trk_road_tax', data[9]));
      request.files.add(await http.MultipartFile.fromPath('trk_rto', data[10]));

      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      return PostResultOne.fromJson(json.decode(finalResult.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> editTruckInfo(List data) async {
    try {
      var result = await http.post("$baseURLOwner/trucks", body: {
        'trk_id': data[0],
        'trk_cat_edit': data[1],
        'trk_num_edit': data[2],
        'trk_cat_type_edit': data[3],
        'trk_dr_name_edit': data[4],
        'trk_dr_phone_code_edit': data[5],
        'trk_dr_phone_edit': data[6]
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<List<Truck>> viewAllTrucks(List data) async {
    try {
      var result = await http
          .post("$baseURLOwner/trucks", body: {'truck_owner_id': data[0]});
      var ret = json.decode(result.body);
      List<Truck> list = [];
      print(ret.length);
      for (var i in ret) {
        list.add(Truck.fromJson(i));
      }
      return list;
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> deleteTrucks(List data) async {
    try {
      var result = await http
          .post("$baseURLOwner/trucks", body: {'del_truck_id': data[0]});
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> changeTruckStatus(List data) async {
    try {
      print(data);
      var result = await http.post("$baseURLOwner/trucks",
          body: {'trk_id': data[0], 'trk_status': data[1]});
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> editTruckImage(List data) async {
    try {
      var url = "$baseURLOwner/trucks";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['trk_id'] = data[0];
      request.files
          .add(await http.MultipartFile.fromPath('${data[1]}', data[2]));
      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      return PostResultOne.fromJson(json.decode(finalResult.body));
    } catch (error) {
      throw error;
    }
  }

  // RISHAV

  /// get available subscription plans
  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    try {
      var result = await http
          .get('https://truckwale.co.in/api/truck_owner_subscription_plan');

      var ret = json.decode(result.body);
      List<SubscriptionPlan> list = [];
      for (var i in ret) {
        list.add(SubscriptionPlan.fromJson(i));
      }
      return list;
    } catch (error) {
      throw error;
    }
  }

  /// generating razorpay payment receipt
  Future<String> generateRazorpayOrderId(int amount) async {
    try {
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$RAZORPAY_ID:$RAZORPAY_SECRET'));

      Map<String, dynamic> orderData = {
        'amount': amount,
        'currency': 'INR',
        'receipt': 'TRANSPORT_${1000 + _random.nextInt(9999 - 1000)}',
        'payment_capture': 1,
        'notes': {
          'notes_key_1': 'Transporter is developed by TheGraphe',
        },
      };

      print(1000 + _random.nextInt(9999 - 1000));

      http.Response response = await http.post(
        'https://api.razorpay.com/v1/orders',
        headers: <String, String>{
          'Authorization': basicAuth,
          'Content-Type': 'application/json'
        },
        body: json.encode(orderData),
      );

      print(json.decode(response.body));

      if ((json.decode(response.body)).containsKey('error')) {
        return null;
      } else {
        return (json.decode(response.body))['id'];
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  /// UPDATING SUBSCRIPTION DATA
  Future<PostResultOne> storeData(
    String type,
    UserOwner user,
    SubscriptionPlan plan,
    double price,
    PaymentSuccessResponse paymentResponse,
    String coupon,
  ) async {
    try {
      var response = await http.post(
        'https://truckwale.co.in/api/subscription_payment',
        body: {
          'user_type': type,
          'user_id': user.oId,
          'amount': price.toString(),
          'duration':
              (type == '2') ? plan.duration.split(' ')[0] : plan.quantity,
          'razorpay_order_id': paymentResponse.orderId,
          'razorpay_payment_id': paymentResponse.paymentId,
          'razorpay_signature': paymentResponse.signature,
          'coupon': coupon,
        },
      );

      return PostResultOne.fromJson(json.decode(response.body));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  /// update pan card image
  Future<PostResultOne> updatePanCardImage(List data) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseURLOwner/owner_docs'));

      request.fields['to_phone'] = data[0];
      request.files.add(await http.MultipartFile.fromPath(
        'to_pan_card',
        data[1],
        filename: 'temp.jpeg',
      ));
      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      print(finalResult.body);
      return PostResultOne.fromJson(json.decode(finalResult.body));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  /// update band nad name details owner
  Future<PostResultOne> updateBankAndNameDetails(List data) async {
    try {
      var response = await http.post(
        '$baseURLOwner/owner_docs',
        body: {
          'to_phone': data[0],
          'to_name': data[1],
          'to_bank': data[2],
          'to_ifsc': data[3],
        },
      );

      return PostResultOne.fromJson(json.decode(response.body));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  /// getting all posts for truck owner
  Future<List<Post>> getPosts() async {
    try {
      var response = await http.get('$baseURLOwner/get_all_posts');

      if (json.decode(response.body)[0]['success'] == '0') return null;

      List<Post> posts = [];

      for (var i = 0; i < json.decode(response.body).length; i++) {
        posts.add(Post.fromJson(json.decode(response.body)[i]));
      }

      print(posts.toString());
      return posts;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  /// post bid
  Future<PostResultOne> postBid(
    String userId,
    String loadId,
    String expectedPrice,
  ) async {
    try {
      var response = await http.post(
        'https://truckwale.co.in/api/bidding',
        body: {
          'user_type': '1',
          'user_id': userId,
          'load_id': loadId,
          'expected_price': expectedPrice,
        },
      );

      return PostResultOne.fromJson(json.decode(response.body));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  /// getting current users bid for posts
  Future<List<Bid>> getBids(String userId) async {
    try {
      var response =
          await http.post('https://truckwale.co.in/api/bidding', body: {
        'get_user_type': '1',
        'get_user_id': userId,
      });

      if (response.body == 'null') return [];

      List<Bid> bids = [];
      for (var i = 0; i < json.decode(response.body).length; i++)
        bids.add(Bid.fromJson(json.decode(response.body)[i]));

      print(bids.toString());
      return bids;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  /// updating bid
  Future<PostResultOne> updateBid(String bidId, String updatedPrice) async {
    try {
      var response =
          await http.post('https://truckwale.co.in/api/bidding', body: {
        'bid_id': bidId,
        'edit_expected_price': updatedPrice,
      });

      return PostResultOne.fromJson(json.decode(response.body));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  /// delete bid
  Future<PostResultOne> deleteBid(String bidId) async {
    try {
      var response =
          await http.post('https://truckwale.co.in/api/bidding', body: {
        'delete_bid_id': bidId,
      });

      return PostResultOne.fromJson(json.decode(response.body));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  /// Getting all current userd bid
  Future<List<Bid1>> getMyBids(String ownerId) async {
    try {
      var response = await http
          .post('$baseURLOwner/my_biddings', body: {'owner_id': ownerId});

      if (response.body == 'null') return [];

      List<Bid1> bids = [];
      for (var i = 0; i < json.decode(response.body).length; i++)
        bids.add(Bid1.fromJson(json.decode(response.body)[i]));

      print(bids.toString());
      return bids;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  /// Accepting bid
  Future<PostResultOne> acceptBid(String bidId) async {
    try {
      var response = await http.post('$baseURLOwner/my_biddings', body: {
        'bid_id_for_accepting': bidId,
      });

      return PostResultOne.fromJson(json.decode(response.body));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  /// Removing bid
  Future<PostResultOne> removeBid(String bidId) async {
    try {
      var response = await http.post('$baseURLOwner/my_biddings', body: {
        'bid_id_for_removing': bidId,
      });

      return PostResultOne.fromJson(json.decode(response.body));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  /// Getting all deliveries
  Future<List<Delivery>> getMyDeliveries(List data) async {
    try {
      var response = await http.post(
        '$baseURLOwner/my_deliveries',
        body: {'owner_id': data[0]},
      );

      // if (json.decode(response.body)['success'] == '0') return [];

      print(response.body);
      if (response.body == null ||
          response.body == 'null' ||
          response.body == '[]') return [];

      List<Delivery> delivery = [];
      for (var i = 0; i < json.decode(response.body).length; i++)
        delivery.add(Delivery.fromJson(json.decode(response.body)[i]));

      print(delivery.toString());
      return delivery;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  /// Assign truck for delivery
  Future<PostResultOne> assignTruckForDelivery(List data) async {
    try {
      var response = await http.post('$baseURLOwner/my_deliveries', body: {
        'delivery_id': data[0],
        'truck_id': data[1],
      });

      return PostResultOne.fromJson(json.decode(response.body));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  /// Remove truck from delivery
  Future<PostResultOne> removeTruck(List data) async {
    try {
      var response = await http.post('$baseURLOwner/my_deliveries', body: {
        'del_id_remove_truck': data[0],
      });

      return PostResultOne.fromJson(json.decode(response.body));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  // Getting add on truck plans
  Future<List<SubscriptionPlan>> getAddOnPlans() async {
    try {
      var result =
          await http.get('https://truckwale.co.in/api/add_on_truck_plan');

      var ret = json.decode(result.body);
      List<SubscriptionPlan> list = [];
      for (var i in ret) {
        list.add(SubscriptionPlan.fromJson(i));
      }
      return list;
    } catch (error) {
      throw error;
    }
  }

  Future<String> getAddressOfDriver(String lat, String lng) async {
    try {
      var response = await http.get('$reverseGeocodingLink$lat,$lng');

      return json.decode(response.body)['results'][0]['formatted_address'];
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<LatLng> getLoc(String id) async {
    try {
      var response = await http.post(
          'https://truckwale.co.in/api/truck_location',
          body: {'truck_id': id});

      return LatLng(double.parse(json.decode(response.body)['lat']),
          double.parse(json.decode(response.body)['lng']));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<LatLng> getDelLoc(String id) async {
    try {
      var response = await http.post(
          'https://truckwale.co.in/api/truck_location',
          body: {'delivery_truck_id': id});

      return LatLng(double.parse(json.decode(response.body)['lat']),
          double.parse(json.decode(response.body)['lng']));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Map> truckDoc(String truckId) async {
    try {
      var response = await http.post(
          'https://truckwale.co.in/api/driver/driver_docs',
          body: {'truck_id': truckId});

      return json.decode(response.body);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Map> checkCoupon(
    String couponCode,
    String userId,
    String userType,
  ) async {
    try {
      var response = await http.get(
          'https://truckwale.co.in/api/coupons?user_type=$userType&user_id=$userId&coupon=$couponCode');

      return json.decode(response.body);
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
