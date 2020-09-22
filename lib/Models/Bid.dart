import 'package:ownerapp/Models/Posts.dart';

class Bid {
  String bidId;
  String loadId;
  String price;

  Bid({
    this.bidId,
    this.loadId,
    this.price,
  });

  factory Bid.fromJson(Map<String, dynamic> parsedJson) {
    return Bid(
      bidId: parsedJson['bid id'],
      loadId: parsedJson['load id'],
      price: parsedJson['price'],
    );
  }
}

class Bid1 {
  String bidId;
  String bidPrice;
  String bidStatus;
  String bidStatusMessage;
  Post load;

  Bid1({
    this.bidId,
    this.bidPrice,
    this.bidStatus,
    this.bidStatusMessage,
    this.load,
  });

  factory Bid1.fromJson(Map<String, dynamic> parsedJson) {
    return Bid1(
      bidId: parsedJson['bid id'],
      bidPrice: parsedJson['my price'],
      bidStatus: parsedJson['bid status']['success'],
      bidStatusMessage: parsedJson['bid status']['message'],
      load: Post.fromJson(parsedJson['load details']),
    );
  }
}
