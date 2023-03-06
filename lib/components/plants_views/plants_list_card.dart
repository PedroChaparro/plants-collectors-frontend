import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plants_collectors/schemas/schemas.dart';
import 'package:plants_collectors/services/sqlite.services.dart';
import 'package:plants_collectors/services/user.services.dart';

final sqliteServices = SqliteServices();
final userServices = UserServices();

class PlantsListCard extends StatefulWidget {
  const PlantsListCard({super.key, required this.plant});
  final Plant plant;

  @override
  State<PlantsListCard> createState() => _PlantsListCardState();
}

class _PlantsListCardState extends State<PlantsListCard> {
  // -- State
  var _isLoading = false;
  var _isFavorite = false;
  final apiBaseUrl = dotenv.get("API_BASE_URL");

  // -- functions
  void _checkIfFavorite() async {
    // Set 2s timeout
    await Future.delayed(const Duration(seconds: 1));

    final plant = await sqliteServices.getFavorite(widget.plant.plandId);
    var isFavorite = false;
    if (plant.isNotEmpty) isFavorite = true;

    setState(() {
      _isLoading = false;
      _isFavorite = isFavorite;
    });
  }

  void _toggleFavorite() async {
    if (_isFavorite) {
      // Send the DELETE request to the api
      final response =
          await userServices.deleteFromFavorites(widget.plant.plandId);

      // If the request was successful, remove the plant from sqlite
      if (response['error'] == false) {
        await sqliteServices.deleteFavorite(widget.plant.plandId);
      }
    } else {
      // Send the POST request to the api
      final response = await userServices.addToFavorites(widget.plant.plandId);

      // If the request was successful, add the plant to sqlite
      if (response['error'] == false) {
        await sqliteServices.insertFavorite(widget.plant);
      }
    }

    setState(() => _isFavorite = !_isFavorite);
  }

  @override
  void initState() {
    setState(() => _isLoading = true);
    super.initState();
    _checkIfFavorite();
  }

  // -- UI
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            height: 120,
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
            margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: const Center(
                child: CircularProgressIndicator(
              color: Color(0xff01d25a),
            )),
          )
        : Container(
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Container(
                              margin: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "By: ${widget.plant.ownerUsername}",
                                style:
                                    const TextStyle(color: Color(0xFF6D6D6D)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .start, // Center horizontally
                              children: [
                                Text(
                                  "Rating: ${widget.plant.averageRate.toString()}",
                                  style:
                                      const TextStyle(color: Color(0xFF6D6D6D)),
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
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: GestureDetector(
                    onTap: _toggleFavorite,
                    child: _isFavorite
                        ? const Icon(Icons.favorite, color: Colors.red)
                        : const Icon(Icons.favorite_border, color: Colors.red),
                  ),
                )
              ],
            ));
  }
}
