import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ownerapp/DialogScreens/DialogProcessing.dart';
import 'package:ownerapp/DialogScreens/DialogSuccess.dart';
import 'package:ownerapp/Models/Bid.dart';
import 'package:ownerapp/Models/Posts.dart';
import 'package:ownerapp/Models/Truck.dart';
import 'package:ownerapp/Models/TruckCategory.dart';
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
          context, introLoginOptionPage, (route) => false);
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
      var result = await http.post('$baseURLOwner/owner_enter_exit', body: {
        'to_phone_code': data[0],
        'to_phone': data[1],
        'to_token': '',
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
      var result = await http.get("$baseURLOwner/truck_categories");
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

  Future<PostResultOne> addTrucksOwner(List data) async {
    try {
      var url = "$baseURLOwner/trucks";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['trk_owner'] = data[0];
      request.fields['trk_cat'] = data[1];
      request.fields['trk_num'] = data[2];
      request.fields['trk_load'] = data[3];
      request.fields['trk_dr_name'] = data[4];
      request.fields['trk_dr_phone_code'] = data[5];
      request.fields['trk_dr_phone'] = data[6];
      request.files.add(await http.MultipartFile.fromPath('trk_rc', data[7]));
      request.files
          .add(await http.MultipartFile.fromPath('trk_dr_license', data[8]));
      request.files
          .add(await http.MultipartFile.fromPath('trk_insurance', data[9]));
      request.files
          .add(await http.MultipartFile.fromPath('trk_road_tax', data[10]));
      request.files.add(await http.MultipartFile.fromPath('trk_rto', data[11]));

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
        'trk_load_edit': data[3],
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

  /*-------------------------- Customer API's ---------------------------*/
  Future<PostResultOne> registerLoginCustomer(List data) async {
    try {
      var result =
          await http.post("$baseURLCustomer/register-login-logout", body: {
        'cu_phone_code': data[0],
        'cu_phone': data[1],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> logoutCustomer(List data) async {
    try {
      var result =
          await http.post("$baseURLCustomer/register-login-logout", body: {
        'logout_number': data[0],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> uploadDocsPic(List data) async {
    try {
      var url = "$baseURLOwner/profile";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['cu_phone'] = data[0];
      request.files
          .add(await http.MultipartFile.fromPath('${data[1]}', data[2]));
      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      return PostResultOne.fromJson(json.decode(finalResult.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> uploadOfficeAddPic(List data) async {
    try {
      var url = "$baseURLOwner/profile";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['cu_phone'] = data[0];
      request.fields['cu_co_name'] = data[1];
      request.files
          .add(await http.MultipartFile.fromPath('co_office_address', data[2]));
      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      return PostResultOne.fromJson(json.decode(finalResult.body));
    } catch (error) {
      throw error;
    }
  }

  Future<List<dynamic>> registerVerifyOtpCustomer(List data) async {
    try {
      var result = await http.post("$baseURLCustomer/verification",
          body: {'phone_number': data[0], 'otp': data[1]});
      return [PostResultOne.fromJson(json.decode(result.body)), result.body];
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> registerResendOtpCustomer(List data) async {
    try {
      var result = await http.post("$baseURLCustomer/verification", body: {
        'resend_otp_on': data[0],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  /*-------------------------- Driver API's ---------------------------*/
  Future<PostResultOne> registerDriver(List data) async {
    try {
      var url = "$baseURLDriver/register";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['d_name'] = data[0];
      request.fields['d_email'] = data[1];
      request.fields['d_phone_code'] = data[2];
      request.fields['d_phone'] = data[3];
      request.fields['d_password'] = data[4];
      request.fields['d_cnf_password'] = data[5];
      request.fields['d_address'] = data[6];
      request.files.add(await http.MultipartFile.fromPath('d_rc', data[7]));
      request.files
          .add(await http.MultipartFile.fromPath('d_license', data[8]));
      request.files
          .add(await http.MultipartFile.fromPath('d_insurance', data[9]));
      request.files
          .add(await http.MultipartFile.fromPath('d_road_tax', data[10]));
      request.files.add(await http.MultipartFile.fromPath('d_rto', data[11]));
      request.fields['d_pan'] = data[12];
      request.fields['d_bank'] = data[13];
      request.fields['d_ifsc'] = data[14];

      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      return PostResultOne.fromJson(json.decode(finalResult.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> registerVerifyOtpDriver(List data) async {
    try {
      var result = await http.post("$baseURLDriver/register",
          body: {'phone_number': data[0], 'otp': data[1]});
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> registerResendOtpDriver(List data) async {
    try {
      var result = await http.post("$baseURLDriver/register", body: {
        'resend_otp': data[0],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<List> loginDriver(List data) async {
    try {
      var result = await http.post("$baseURLDriver/login",
          body: {'phone_code': '91', 'phone': data[0], 'password': data[1]});
      var jsonResult = json.decode(result.body);
      if (jsonResult['success'] == '1') {
        UserDriver userDriver = UserDriver.fromJson(jsonResult);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('rememberMe', data[2]);
        prefs.setString('userType', driverUser);
        prefs.setString('userData', result.body);
        return [true, userDriver];
      } else {
        PostResultOne postResultOne = PostResultOne.fromJson(jsonResult);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('rememberMe', false);
        return [false, postResultOne];
      }
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
    UserOwner user,
    SubscriptionPlan plan,
    PaymentSuccessResponse paymentResponse,
  ) async {
    try {
      var response = await http.post(
        'https://truckwale.co.in/api/subscription_payment',
        body: {
          'user_type': '2',
          'user_id': user.oId,
          'amount': plan.planSellingPrice.toString(),
          'duration': plan.duration.split(' ')[0],
          'razorpay_order_id': paymentResponse.orderId,
          'razorpay_payment_id': paymentResponse.paymentId,
          'razorpay_signature': paymentResponse.signature,
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

  // update band nad name details owner
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

      loginOwner([
        '91',
        data[0],
      ]);

      return PostResultOne.fromJson(json.decode(response.body));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<Post>> getPosts() async {
    try {
      var response = await http.get('$baseURLOwner/get_all_posts');

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

  Future<List<Bid>> getBids(String userId) async {
    try {
      var response =
          await http.post('https://truckwale.co.in/api/bidding', body: {
        'get_user_type': '1',
        'get_user_id': userId,
      });

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
}
