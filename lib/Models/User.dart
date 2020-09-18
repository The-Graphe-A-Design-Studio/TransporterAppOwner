class UserOwner {
  bool success;
  String oId;
  String oPhoneCode;
  String oPhone;
  String oName;
  String oBank;
  String oIfsc;
  String oPanCard;
  String oRegistered;
  String oSubscriptionUpto;
  String oSubscriptionStatus;
  String oToken;

  UserOwner({
    this.success,
    this.oId,
    this.oPhoneCode,
    this.oPhone,
    this.oName,
    this.oBank,
    this.oIfsc,
    this.oPanCard,
    this.oRegistered,
    this.oSubscriptionStatus,
    this.oSubscriptionUpto,
    this.oToken,
  });

  factory UserOwner.fromJson(Map<String, dynamic> parsedJson) {
    return UserOwner(
      success: parsedJson['success'] == '1' ? true : false,
      oId: parsedJson['id'],
      oPhoneCode: parsedJson['phone country code'],
      oPhone: parsedJson['phone'],
      oName: parsedJson['name'],
      oBank: parsedJson['bank account number'],
      oIfsc: parsedJson['ifsc code'],
      oPanCard: (parsedJson['pan card'] == null) ? '' : parsedJson['pan card'],
      oRegistered: parsedJson['registered on'],
      oSubscriptionUpto: parsedJson['subscription period upto'],
      oSubscriptionStatus: parsedJson['subscription period status'],
      oToken: parsedJson['firebase token'],
    );
  }

  Map<String, dynamic> toJson() => {
        'success': "1",
        'id': this.oId,
        'name': this.oName,
        'phone country code': this.oPhoneCode,
        'phone': this.oPhone,
        'pan card': this.oPanCard,
        'bank account number': this.oBank,
        'ifsc code': this.oIfsc,
        'registered on': this.oRegistered,
        'subscription period upto': this.oSubscriptionUpto,
        'subscription period status': this.oSubscriptionStatus,
        'firebase token': this.oToken,
      };

  // bool success;
  // String oId;
  // String oName;
  // String oEmail;
  // String oPhoneCode;
  // String oPhone;
  // String oAddress;
  // String oCity;
  // String oOperatingRoute;
  // String oPermitStates;
  // String oPan;
  // String oBank;
  // String oIfsc;
  // String oRegistered;

  // UserOwner({this.success,
  //   this.oId,
  //   this.oName,
  //   this.oEmail,
  //   this.oPhoneCode,
  //   this.oPhone,
  //   this.oAddress,
  //   this.oCity,
  //   this.oOperatingRoute,
  //   this.oPermitStates,
  //   this.oPan,
  //   this.oBank,
  //   this.oIfsc,
  //   this.oRegistered});

  // factory UserOwner.fromJson(Map<String, dynamic> parsedJson) {
  //   return UserOwner(
  //       success: parsedJson['success'] == '1' ? true : false,
  //       oId: parsedJson['id'],
  //       oName: parsedJson['name'],
  //       oEmail: parsedJson['email'],
  //       oPhoneCode: parsedJson['phone_con_code'],
  //       oPhone: parsedJson['phone'],
  //       oAddress: parsedJson['address'],
  //       oCity: parsedJson['city'],
  //       oOperatingRoute: parsedJson['operating routes'],
  //       oPermitStates: parsedJson['permit states'],
  //       oPan: parsedJson['pan'],
  //       oBank: parsedJson['bank'],
  //       oIfsc: parsedJson['ifsc'],
  //       oRegistered: parsedJson['registered on']);
  // }

  // Map<String, dynamic> toJson() =>
  //     {
  //       'success': "1",
  //       'id': this.oId,
  //       'name': this.oName,
  //       'email': this.oEmail,
  //       'phone_con_code': this.oPhoneCode,
  //       'phone': this.oPhone,
  //       'address': this.oAddress,
  //       'city': this.oCity,
  //       'operating routes': this.oOperatingRoute,
  //       'permit states': this.oPermitStates,
  //       'pan': this.oPan,
  //       'bank': this.oBank,
  //       'ifsc': this.oIfsc,
  //       'registered on': this.oRegistered,
  //     };
}

class UserDriver {
  bool success;
  String dId;
  String dName;
  String dEmail;
  String dPhoneCode;
  String dPhone;
  String dPassword;
  String dAddress;
  String dRc;
  String dLicense;
  String dInsurance;
  String dRoadTax;
  String dRto;
  String dPan;
  String dBank;
  String dIfsc;
  bool dVerified;
  String dRegistered;

  UserDriver(
      {this.success,
      this.dId,
      this.dName,
      this.dEmail,
      this.dPhoneCode,
      this.dPhone,
      this.dPassword,
      this.dAddress,
      this.dRc,
      this.dLicense,
      this.dInsurance,
      this.dRoadTax,
      this.dRto,
      this.dPan,
      this.dBank,
      this.dIfsc,
      this.dVerified,
      this.dRegistered});

  factory UserDriver.fromJson(Map<String, dynamic> parsedJson) {
    return UserDriver(
        success: parsedJson['success'] == '1' ? true : false,
        dId: parsedJson['d_id'],
        dName: parsedJson['d_name'],
        dEmail: parsedJson['d_email'],
        dPhoneCode: parsedJson['d_phone_code'],
        dPhone: parsedJson['d_phone'],
        dPassword: parsedJson['d_password'],
        dAddress: parsedJson['d_address'],
        dRc: parsedJson['d_rc'],
        dLicense: parsedJson['d_license'],
        dInsurance: parsedJson['d_insurance'],
        dRoadTax: parsedJson['d_road_tax'],
        dRto: parsedJson['d_rto'],
        dPan: parsedJson['d_pan'],
        dBank: parsedJson['d_bank'],
        dIfsc: parsedJson['d_ifsc'],
        dVerified: parsedJson['d_verified'] == '1' ? true : false,
        dRegistered: parsedJson['d_registered']);
  }
}

class UserTransporter {
  bool success;
  String message;
  String verified;
  String registered;

  UserTransporter({this.success, this.message, this.verified, this.registered});

  factory UserTransporter.fromJson(Map<String, dynamic> parsedJson) {
    return UserTransporter(
        success: parsedJson['success'] == '1' ? true : false,
        message: parsedJson['message'],
        verified: parsedJson['verified'],
        registered: parsedJson['registered on']);
  }

  Map<String, dynamic> toJson() => {
        'success': "1",
        'message': this.message,
        'verified': this.verified,
        'registered on': this.registered,
      };
}

class UserCustomerIndividual {
  bool success;
  String inId;
  String inName;
  String inEmail;
  String inPhoneCode;
  String inPhone;
  String inCity;
  String inAddress;
  String inPin;
  String inPan;
  String inRegistered;

  UserCustomerIndividual(
      {this.success,
      this.inId,
      this.inName,
      this.inEmail,
      this.inPhoneCode,
      this.inPhone,
      this.inCity,
      this.inAddress,
      this.inPin,
      this.inPan,
      this.inRegistered});

  factory UserCustomerIndividual.fromJson(Map<String, dynamic> parsedJson) {
    return UserCustomerIndividual(
        success: parsedJson['success'] == '1' ? true : false,
        inId: parsedJson['id'],
        inName: parsedJson['name'],
        inEmail: parsedJson['email'],
        inPhoneCode: parsedJson['phone_con_code'],
        inPhone: parsedJson['phone'],
        inCity: parsedJson['city'],
        inAddress: parsedJson['address'],
        inPin: parsedJson['pin code'],
        inPan: parsedJson['pan number'],
        inRegistered: parsedJson['registered on']);
  }
}

class UserCustomerCompany {
  bool success;
  String coId;
  String coName;
  String coEmail;
  String coPhoneCode;
  String coPhone;
  String coAddress;
  String coCity;
  String coPin;
  String coPan;
  String coCompanyName;
  String coCompanyType;
  String coCompanyTax;
  String coCompanyPan;
  String coCompanyWebsite;
  String coRegistered;

  UserCustomerCompany(
      {this.success,
      this.coId,
      this.coName,
      this.coEmail,
      this.coPhoneCode,
      this.coPhone,
      this.coAddress,
      this.coCity,
      this.coPin,
      this.coPan,
      this.coCompanyName,
      this.coCompanyType,
      this.coCompanyTax,
      this.coCompanyPan,
      this.coCompanyWebsite,
      this.coRegistered});

  factory UserCustomerCompany.fromJson(Map<String, dynamic> parsedJson) {
    return UserCustomerCompany(
        success: parsedJson['success'] == '1' ? true : false,
        coId: parsedJson['id'],
        coName: parsedJson['name'],
        coEmail: parsedJson['email'],
        coPhoneCode: parsedJson['phone_con_code'],
        coPhone: parsedJson['phone'],
        coAddress: parsedJson['address'],
        coCity: parsedJson['city'],
        coPin: parsedJson['pin code'],
        coPan: parsedJson['pan number'],
        coCompanyName: parsedJson['company name'],
        coCompanyType: parsedJson['company type'],
        coCompanyTax: parsedJson['company service tax'],
        coCompanyPan: parsedJson['company pan number'],
        coCompanyWebsite: parsedJson['company website'],
        coRegistered: parsedJson['registered on']);
  }
}
