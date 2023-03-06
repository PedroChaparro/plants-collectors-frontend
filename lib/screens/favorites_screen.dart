import 'package:flutter/material.dart';
import 'package:plants_collectors/components/plants_views/plants_views_builder.dart';
import 'package:plants_collectors/schemas/schemas.dart';
import 'package:plants_collectors/services/session.services.dart';
import 'package:plants_collectors/services/sqlite.services.dart';
import 'package:plants_collectors/utils/utils.dart';

final utils = Utils();
final sessionService = SessionServices();
final sqliteServices = SqliteServices();

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Plant> _plants = [];
  bool _showGridView = true;

  Future<void> _toggleGridView() async {
    setState(() {
      _showGridView = !_showGridView;
    });
  }

  Future<void> _redirectToLogin() {
    return Navigator.pushNamed(context, '/login');
  }

  Future<void> _checkIfUserIsLoggedIn() async {
    // Verify the access token
    final response = await sessionService.verify();

    if (response['error'] != null && response['error'] == true) {
      _redirectToLogin();
    }

    _loadPlants(); // If the user is authenticated, load the plants
  }

  Future<void> _loadPlants() async {
    // Get the plants from sqlite
    final plantsRaw = await sqliteServices.getFavorites();

    // Parse to plant objects
    final plants = plantsRaw.map((plant) => Plant.fromJson(plant)).toList();

    // Update the state with the plants
    setState(() {
      _plants = plants;
    });
  }

  void _onBottomNavigationItemTapped(int index) async {
    if (index == 0) {
      Navigator.pushNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/favorites');
    } else if (index == 2) {
      // Logout
      final response = await sessionService.logout();

      if (response['error'] != null && response['error'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response["message"] ??
              "An error occured, please try again later"),
          backgroundColor: Colors.red,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("You have been logged out"),
          backgroundColor: Colors.green,
        ));

        _redirectToLogin();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIfUserIsLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
          // Button to toggle between list and grid view
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: _toggleGridView,
                  icon: _showGridView
                      ? const Icon(Icons.list)
                      : const Icon(Icons.grid_view))
            ],
          ),
          // Wrap the list/grid in a expanded widget to make it scrollable and growable
          Expanded(
              child: _showGridView
                  ? PlantsViewsBuilder.buildGridView(_plants)
                  : PlantsViewsBuilder.buildListView(_plants))
        ])),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
              ),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout')
          ],
          currentIndex: 1,
          selectedItemColor: const Color(0xff01d25a),
          onTap: _onBottomNavigationItemTapped,
        ));
  }
}
