import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plants_collectors/schemas/schemas.dart';

class ProductsServices {
  final apiUrl = dotenv.get('API_BASE_URL');

  Future<List<Plant>> getPlants() async {
    final uri = Uri.parse('$apiUrl/product');
    final response = await http.get(uri);
    final responseData = json.decode(response.body);

    if (responseData['error'] != null && responseData['error'] == true) {
      return [];
    }

    final List<Plant> plants = [];

    // Iterate over the list of plants and parse into custom Plant class
    for (var plant in responseData['plants']) {
      // Parse the average rate to double (Some of them are int)
      double averageRate = plant['average_rate'] != null
          ? double.parse(plant['average_rate'].toString())
          : 0.0;

      plants.add(Plant(
        plandId: plant['plant_id'],
        plantName: plant['plant_name'],
        averageRate: averageRate,
        ownerUsername: plant['owner_username'],
        imageEndpoint: plant['image_endpoint'],
      ));
    }

    return plants;
  }
}
