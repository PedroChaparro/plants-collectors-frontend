import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plants_collectors/schemas/schemas.dart';
import 'package:plants_collectors/services/sqlite.services.dart';
import 'package:plants_collectors/services/user.services.dart';

final sqliteServices = SqliteServices();
final userServices = UserServices();

class PlantsGridCard extends StatefulWidget {
  const PlantsGridCard({super.key, required this.plant});

  final Plant plant;

  @override
  State<PlantsGridCard> createState() => _PlantsGridCardState();
}

class _PlantsGridCardState extends State<PlantsGridCard> {
  // -- State
  var _isLoading = false;
  var _isFavorite = false;
  final apiBaseUrl = dotenv.get("API_BASE_URL");

  // -- functions
  void _checkIfFavorite() async {
    // Set 2s timeout
    await Future.delayed(const Duration(seconds: 2));

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
      if (response['error'] == 'false') {
        await sqliteServices.deleteFavorite(widget.plant.plandId);
      }

      print('Plant removed from favorites');
    } else {
      // Send the POST request to the api
      final response = await userServices.addToFavorites(widget.plant.plandId);

      // If the request was successful, add the plant to sqlite
      if (response['error'] == 'false') {
        await sqliteServices.insertFavorite(widget.plant);
      }

      print('Plant added to favorites');
    }

    // Finally, toggle the state
    setState(() => _isFavorite = !_isFavorite);
  }

  @override
  void initState() {
    setState(() => _isLoading = true);
    super.initState();
    _checkIfFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ?
        // Loading indicator
        Container(
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
            margin: const EdgeInsets.all(8.0),
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xff01d25a),
              ),
            ),
          )
        :
        // Card itself
        Container(
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
                      child: Image.network(
                          "$apiBaseUrl${widget.plant.imageEndpoint}",
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
                                style:
                                    const TextStyle(color: Color(0xFF6D6D6D)),
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
                      onTap: _toggleFavorite,
                      child: _isFavorite
                          ? const Icon(Icons.favorite, color: Colors.red)
                          : const Icon(Icons.favorite_border,
                              color: Colors.red)),
                ),
              ],
            ),
          );
  }
}
