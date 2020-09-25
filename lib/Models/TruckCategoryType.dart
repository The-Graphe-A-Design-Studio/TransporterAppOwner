class TruckCategoryType {
  String id;
  String category;
  String name;

  TruckCategoryType({
    this.id,
    this.category,
    this.name,
  });

  factory TruckCategoryType.fromJson(Map<String, dynamic> parsedJson) {
    return TruckCategoryType(
      id: parsedJson['ty_id'],
      category: parsedJson['ty_cat'],
      name: parsedJson['ty_name'],
    );
  }
}
