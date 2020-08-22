import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ownerapp/DialogScreens/DialogProcessing.dart';
import 'package:ownerapp/DialogScreens/DialogSuccess.dart';
import 'package:ownerapp/Models/Truck.dart';
import 'package:ownerapp/Models/TruckCategory.dart';
import 'package:ownerapp/Models/User.dart';
import 'package:ownerapp/MyConstants.dart';
import 'package:ownerapp/PostMethodResult.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HTTPHandler {
  String baseURLDriver =
      'https://developers.thegraphe.com/transport/api/drivers';
  String baseURLOwner = 'https://truckwale.co.in/api/truck_owner';
  String baseURLCustomer = 'https://truckwale.co.in/api/customer';

  void signOut(BuildContext context) async {
    DialogProcessing().showCustomDialog(context,
        title: "Sign Out", text: "Processing, Please Wait!");
    await SharedPreferences.getInstance()
        .then((value) => value.setBool("rememberMe", false));
    await Future.delayed(Duration(seconds: 1), () {});
    Navigator.pop(context);
    DialogSuccess().showCustomDialog(context, title: "Sign Out");
    await Future.delayed(Duration(seconds: 1), () {});
    Navigator.pop(context);
    Navigator.pushNamedAndRemoveUntil(
        context, introLoginOptionPage, (route) => false);
  }

  void saveLocalChangesOwner(UserOwner userOwner) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', json.encode(userOwner.toJson()));
  }

  /*-------------------------- Owner API's ---------------------------*/
  Future<PostResultOne> registerOwner(List data) async {
    try {
      var result = await http.post("$baseURLOwner/register", body: {
        'to_name': data[0],
        'to_phone_code': data[1],
        'to_phone': data[2],
        'to_email': data[3],
        'to_address': data[4],
        'to_city': data[5],
        'to_password': data[6],
        'to_cnf_password': data[7],
        'to_operating_routes': data[8],
        'to_state_permits': data[9],
        'to_pan': data[10],
        'to_bank': data[11],
        'to_ifsc': data[12]
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> registerVerifyOtpOwner(List data) async {
    try {
      var result = await http.post("$baseURLOwner/register",
          body: {'phone_number': data[0], 'otp': data[1]});
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> registerResendOtpOwner(List data) async {
    try {
      var result = await http.post("$baseURLOwner/register", body: {
        'resend_otp': data[0],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<List> loginOwner(List data) async {
    try {
      var result = await http.post("$baseURLOwner/login",
          body: {'phone_code': data[0], 'phone': data[1], 'password': data[2]});
      var jsonResult = json.decode(result.body);
      if (jsonResult['success'] == '1') {
        UserOwner userOwner = UserOwner.fromJson(jsonResult);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('rememberMe', data[3]);
        prefs.setString('userType', truckOwnerUser);
        prefs.setString('userData', result.body);
        return [true, userOwner];
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
      var result = await http.post("$baseURLCustomer/register-login-logout", body: {
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
      var result = await http.post("$baseURLCustomer/register-login-logout", body: {
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
      request.files.add(await http.MultipartFile.fromPath('${data[1]}', data[2]));
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
      request.files.add(await http.MultipartFile.fromPath('co_office_address', data[2]));
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
}
