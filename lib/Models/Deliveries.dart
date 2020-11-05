import 'package:ownerapp/Models/Posts.dart';

class DeliveryTruck {
  String deleteTruckId;
  String truckNumber;
  String driverName;
  String driverPhone;
  String lat;
  String lng;

  DeliveryTruck({
    this.deleteTruckId,
    this.truckNumber,
    this.driverName,
    this.driverPhone,
    this.lat,
    this.lng,
  });

  factory DeliveryTruck.fromJson(Map<String, dynamic> parsedJson) {
    return DeliveryTruck(
      deleteTruckId: parsedJson['del truck id'],
      truckNumber: parsedJson['truck number'],
      driverName: parsedJson['driver name'],
      driverPhone: parsedJson['driver phone'],
      lat: parsedJson['latitude'],
      lng: parsedJson['longitude'],
    );
  }
}

class Delivery {
  String deliveryId;
  String priceUnit;
  String quantity;
  String dealPrice;
  String gst;
  String totalPrice;
  String deliveryTrucksStatus;
  List<DeliveryTruck> deliveryTrucks;
  String deliveryStatus;
  Post load;
  var paymentMode;

  Delivery({
    this.deliveryId,
    this.priceUnit,
    this.quantity,
    this.dealPrice,
    this.gst,
    this.totalPrice,
    this.deliveryTrucksStatus,
    this.deliveryTrucks,
    this.deliveryStatus,
    this.load,
    this.paymentMode,
  });

  factory Delivery.fromJson(Map<String, dynamic> parsedJson) {
    List<DeliveryTruck> tempTrucks = [];
    if (parsedJson['delivery trucks']['status'] != '0')
      for (var i = 0; i < parsedJson['delivery trucks']['trucks'].length; i++)
        tempTrucks.add(
            DeliveryTruck.fromJson(parsedJson['delivery trucks']['trucks'][i]));
    return Delivery(
      deliveryId: parsedJson['delivery id'],
      priceUnit: parsedJson['price unit'],
      quantity: parsedJson['quantity'],
      dealPrice: parsedJson['deal price'],
      gst: parsedJson['GST'],
      totalPrice: parsedJson['total price'],
      deliveryTrucksStatus: parsedJson['delivery trucks']['status'],
      deliveryTrucks: tempTrucks,
      deliveryStatus: parsedJson['delivery status'],
      load: Post.fromJson(parsedJson['load details']),
      paymentMode: parsedJson['load details']['payment mode'],
    );
  }
}
