import 'dart:ffi';

class Plant {
  int plandId;
  String plantName;
  double averageRate;
  String ownerUsername;
  String imageEndpoint;

  // This method is used to convert the Plant object to a Map
  static Plant fromJson(Map<String, dynamic> json) {
    return Plant(
      plandId: json['plant_id'],
      plantName: json['plant_name'],
      averageRate: double.parse(json['average_rate'].toString()),
      ownerUsername: json['owner_username'],
      imageEndpoint: json['image_endpoint'],
    );
  }

  Plant({
    required this.plandId,
    required this.plantName,
    required this.averageRate,
    required this.ownerUsername,
    required this.imageEndpoint,
  });
}
