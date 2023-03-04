import 'dart:ffi';

class Plant {
  int plandId;
  String plantName;
  double averageRate;
  String ownerUsername;
  String imageEndpoint;

  Plant({
    required this.plandId,
    required this.plantName,
    required this.averageRate,
    required this.ownerUsername,
    required this.imageEndpoint,
  });
}
