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
