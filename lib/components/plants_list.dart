import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plants_collectors/schemas/schemas.dart';

class PlantsList extends StatelessWidget {
  final List<Plant> plants;
  const PlantsList({super.key, required this.plants});

  List<Widget> _buildPlants() {
    final apiBaseUrl = dotenv.get("API_BASE_URL");

    return plants.map((plant) {
      return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  offset: const Offset(0, 2.0),
                  blurRadius: 8.0)
            ],
          ),
          // List elements separation
          margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Row(
            children: [
              // Plant image
              Column(
                children: [
                  Image.network(
                    '$apiBaseUrl${plant.imageEndpoint}',
                    width: 120,
                  )
                ],
              ),
              // Plant information
              // Use an expanded widget to take the remaining space
              Expanded(
                // Add some innner spacing to the plant information container
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    // Align the text to the left
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plant.plantName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Seller: ${plant.ownerUsername}",
                          style: const TextStyle(color: Color(0xFF6D6D6D)),
                        ),
                      ),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.start, // Center horizontally
                        children: [
                          Text(
                            "Rating: ${plant.averageRate.toString()}",
                            style: const TextStyle(color: Color(0xFF6D6D6D)),
                          ),
                          const Icon(Icons.star, color: Colors.yellow),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(children: _buildPlants())));
  }
}
