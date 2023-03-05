import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plants_collectors/components/grid_view/plants_grid_card.dart';
import 'package:plants_collectors/schemas/schemas.dart';
import 'package:plants_collectors/services/user.services.dart';

final userServices = UserServices();

class PlantsGrid extends StatelessWidget {
  final List<Plant> plants;
  const PlantsGrid({super.key, required this.plants});

  List<Widget> _buildPlants() {
    return plants.map((plant) {
      return PlantsGridCard(plant: plant);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              crossAxisCount: 2,
              // This is kinda hardcoded, Grind view's elemest MUST have a fixed
              // apsect ratio. TODO: Find a better way to do this
              childAspectRatio: 0.725,
              children: _buildPlants(),
            )));
  }
}
