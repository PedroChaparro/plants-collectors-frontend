import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plants_collectors/schemas/schemas.dart';

class PlantsGridCard extends StatefulWidget {
  const PlantsGridCard({super.key, required this.plant});

  final Plant plant;

  @override
  State<PlantsGridCard> createState() => _PlantsGridCardState();
}

class _PlantsGridCardState extends State<PlantsGridCard> {
  final apiBaseUrl = dotenv.get("API_BASE_URL");

  @override
  Widget build(BuildContext context) {
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
      // Use a stack so we can position the heart icon on top of the plant
      child: Stack(
        children: [
          // Plant information
          Column(
            children: [
              // Plant image
              Expanded(
                child: Image.network("$apiBaseUrl${widget.plant.imageEndpoint}",
                    fit: BoxFit.contain),
              ),
              // Plant "body"
              Container(
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Text(
                      widget.plant.plantName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Seller: ${widget.plant.ownerUsername}",
                        style: const TextStyle(color: Color(0xFF6D6D6D)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center horizontally
                      children: [
                        Text(
                          "Rating: ${widget.plant.averageRate.toString()}",
                          style: const TextStyle(color: Color(0xFF6D6D6D)),
                        ),
                        const Icon(Icons.star, color: Colors.yellow),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          // Heart icon
          Positioned(
            top: 8.0,
            right: 8.0,
            child: GestureDetector(
                onTap: () async {},
                child: const Icon(Icons.favorite, color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
