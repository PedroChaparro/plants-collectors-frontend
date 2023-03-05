import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plants_collectors/schemas/schemas.dart';

class PlantsGrid extends StatelessWidget {
  final List<Plant> plants;
  const PlantsGrid({super.key, required this.plants});

  List<Widget> _buildPlants() {
    final apiBaseUrl = dotenv.get("API_BASE_URL");

    return plants.map((plant) {
      return Container(
        // Box border
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

        // Grid separation]
        padding: const EdgeInsets.all(4.0),
        margin: const EdgeInsets.all(8.0),

        // Plant card
        child: Column(
          children: [
            // Plant image
            Expanded(
              child: Image.network("$apiBaseUrl${plant.imageEndpoint}",
                  fit: BoxFit.contain),
            ),
            // Plant "body"
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  Text(plant.plantName),
                  Text(
                    "Seller: ${plant.ownerUsername}",
                    style: const TextStyle(color: Color(0xFF6D6D6D)),
                  ),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center horizontally
                    children: [
                      const Icon(Icons.star, color: Colors.yellow),
                      Text(
                        plant.averageRate.toString(),
                        style: const TextStyle(color: Color(0xFF6D6D6D)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              // This is kinda hardcoded, Grind view's elemest MUST have a fixed
              // apsect ratio. TODO: Find a better way to do this
              childAspectRatio: 0.725,
              children: _buildPlants(),
            )));
  }
}
