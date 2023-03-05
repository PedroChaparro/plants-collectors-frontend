import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plants_collectors/components/list_view/plants_list_card.dart';
import 'package:plants_collectors/schemas/schemas.dart';

class PlantsList extends StatelessWidget {
  final List<Plant> plants;
  const PlantsList({super.key, required this.plants});

  List<Widget> _buildPlants() {
    return plants.map((plant) {
      return PlantsListCard(plant: plant);
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
