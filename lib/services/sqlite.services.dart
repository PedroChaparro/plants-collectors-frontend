import 'package:sqflite/sqflite.dart';

var database = openDatabase(
  "plants_collectors.db", // Database name

  // When the database is first created, create a table to favorites
  onCreate: (db, version) {
    return db.execute(
      "CREATE TABLE favorite(plant_id INTEGER PRIMARY KEY, plant_name TEXT, average_rate REAL, owner_username TEXT, image_endpoint TEXT)",
    );
  },

  version: 1,
);

class SqliteServices {
  Future<void> insertFavorite(Map<String, dynamic> plant) async {
    print('Inserting plant: ${plant['plant_name']}');

    // Get a reference to the database.
    final Database db = await database;

    // Insert
    await db.execute("INSERT INTO favorite VALUES(?, ?, ?, ?, ?)", [
      plant['plant_id'],
      plant['plant_name'],
      plant['average_rate'],
      plant['owner_username'],
      plant['image_endpoint']
    ]);

    print('Plant inserted');
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    // Get a reference to the database.
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorite');
    return maps;
  }

  Future<void> deleteFavorite(int id) async {
    // Get a reference to the database.
    final db = await database;

    await db.delete(
      'favorite',
      where: "plant_id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteAllFavorites() async {
    // Get a reference to the database.
    final db = await database;

    await db.delete(
      'favorite',
    );
  }
}
