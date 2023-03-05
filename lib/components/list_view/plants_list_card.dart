import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plants_collectors/schemas/schemas.dart';

class PlantsListCard extends StatefulWidget {
  const PlantsListCard({super.key, required this.plant});
  final Plant plant;

  @override
  State<PlantsListCard> createState() => _PlantsListCardState();
}

class _PlantsListCardState extends State<PlantsListCard> {
  final apiBaseUrl = dotenv.get("API_BASE_URL");

  @override
  Widget build(BuildContext context) {
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
        child: Stack(
          children: [
            Row(
              children: [
                // Plant image
                Column(
                  children: [
                    Image.network(
                      '$apiBaseUrl${widget.plant.imageEndpoint}',
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
                        Text(widget.plant.plantName,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Container(
                          margin: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Seller: ${widget.plant.ownerUsername}",
                            style: const TextStyle(color: Color(0xFF6D6D6D)),
                          ),
                        ),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.start, // Center horizontally
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
                )
              ],
            ),
            // Heart icon
            const Positioned(
              top: 8.0,
              right: 8.0,
              child: Icon(Icons.favorite, color: Colors.red),
            )
          ],
        ));
  }
}
