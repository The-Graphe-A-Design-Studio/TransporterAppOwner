import 'package:ownerapp/Models/Location.dart';

class Post {
  String postId;
  String customerId;
  List<Location> sources;
  List<Location> destinations;
  String material;
  String tonnage;
  String truckPreferences;
  List<String> truckTypes;
  String expectedPrice;
  var paymentMode;
  String createdOn;
  String expiredOn;
  String contactPerson;
  String contactPersonPhone;

  Post({
    this.postId,
    this.customerId,
    this.sources,
    this.destinations,
    this.material,
    this.tonnage,
    this.truckPreferences,
    this.truckTypes,
    this.expectedPrice,
    this.paymentMode,
    this.createdOn,
    this.expiredOn,
    this.contactPerson,
    this.contactPersonPhone,
  });

  factory Post.fromJson(Map<String, dynamic> parsedJson) {
    List<Location> tempS = [];
    for (int i = 0; i < parsedJson['sources'].length; i++)
      tempS.add(Location.fromJson(i + 1, parsedJson['sources'][i]));

    List<Location> tempD = [];
    for (int i = 0; i < parsedJson['destinations'].length; i++)
      tempD.add(Location.fromJson(i + 1, parsedJson['destinations'][i]));

    List<String> tempP = [];
    for (var i in parsedJson['truck types']) {
      for (var j in i.keys) tempP.add(i[j]);
    }

    return Post(
      postId: parsedJson['post id'],
      customerId: parsedJson['customer id'],
      sources: tempS,
      destinations: tempD,
      material: parsedJson['material'],
      tonnage: parsedJson['tonnage'],
      truckPreferences: parsedJson['truck preference'],
      truckTypes: tempP,
      expectedPrice: parsedJson['expected price'],
      paymentMode: parsedJson['payment mode'],
      createdOn: parsedJson['created on'],
      expiredOn: parsedJson['expired on'],
      contactPerson: parsedJson['contact person'],
      contactPersonPhone: parsedJson['contact person phone'],
    );
  }
}
