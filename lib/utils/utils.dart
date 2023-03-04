import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  Future<bool> saveToSharedPreferences(key, value, type) async {
    final prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> types = {
      'string': prefs.setString,
      'int': prefs.setInt,
      'double': prefs.setDouble,
      'bool': prefs.setBool,
    };

    // Validate the type is supported
    if (!types.containsKey(type)) return false;

    // Save the value
    final function = types[type];
    return function(key, value);
  }

  Future<dynamic> getFromSharedPreferences(key, type) async {
    final prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> types = {
      'string': prefs.getString,
      'int': prefs.getInt,
      'double': prefs.getDouble,
      'bool': prefs.getBool,
    };

    // Validate the type is supported
    if (!types.containsKey(type)) return false;

    // Return the value
    return types[type](key);
  }

  Future<bool> removeFromSharedPreferences(key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
