class Location {
  int index;
  String source;
  String destination;
  String lat;
  String lng;
  String city;
  String state;

  Location({
    this.index,
    this.source,
    this.destination,
    this.lat,
    this.lng,
    this.city,
    this.state,
  });

  factory Location.fromJson(int id, Map<String, dynamic> parsedJson) {
    return Location(
      index: id,
      source: parsedJson['source'],
      destination: parsedJson['destination'],
      lat: parsedJson['lat'],
      lng: parsedJson['lng'],
      city: parsedJson['city'],
      state: parsedJson['state'],
    );
  }
}
