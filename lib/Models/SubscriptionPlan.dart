class SubscriptionPlan {
  int planId;
  int planType;
  String planName;
  double planOriginalPrice;
  double planSellingPrice;
  String planDiscount;
  String duration;
  String finalPrice;
  String quantity;

  SubscriptionPlan({
    this.planId,
    this.planType,
    this.planName,
    this.planOriginalPrice,
    this.planSellingPrice,
    this.planDiscount,
    this.duration,
    this.finalPrice,
    this.quantity,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> parsedJson) {
    return SubscriptionPlan(
      planId: int.parse(parsedJson['plan id']),
      planType: int.parse(parsedJson['plan type']),
      planName: parsedJson['plan name'],
      planOriginalPrice: double.parse(parsedJson['plan original price']),
      planSellingPrice: double.parse(parsedJson['plan selling price']),
      planDiscount: parsedJson['plan discount'],
      duration: parsedJson['plan duration'],
      finalPrice: parsedJson['final price'],
      quantity: parsedJson['quantity'],
    );
  }
}
