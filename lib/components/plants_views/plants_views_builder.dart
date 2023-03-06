import 'package:flutter/material.dart';
import 'package:plants_collectors/components/plants_views/plants_grid_card.dart';
import 'package:plants_collectors/components/plants_views/plants_list_card.dart';
import 'package:plants_collectors/schemas/schemas.dart';

class PlantsViewsBuilder {
  static Widget buildGridView(List<Plant> plants) {
    final plantsGridViewCards = plants.map((plant) {
      return PlantsGridCard(plant: plant);
    }).toList();

    return GridView.count(
      crossAxisCount: 2,
      // This is kinda hardcoded, Grind view's elemest MUST have a fixed
      // apsect ratio. TODO: Find a better way to do this
      childAspectRatio: 0.725,
      children: plantsGridViewCards,
    );
  }

  static Widget buildListView(List<Plant> plants) {
    final plantsListViewCards = plants.map((plant) {
      return PlantsListCard(plant: plant);
    }).toList();

    return ListView(
      children: plantsListViewCards,
    );
  }
}
