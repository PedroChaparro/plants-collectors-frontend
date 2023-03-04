import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:plants_collectors/utils/utils.dart';

final utils = Utils();

class SessionServices {
  // Get the API base URL from the .env file
  final apiUrl = dotenv.get('API_BASE_URL');

  Future<Map<String, dynamic>> login(String username, String password) async {
    final uri = Uri.parse('$apiUrl/session/login');

    final data = {
      'username': username,
      'password': password,
    };

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(data),
    );

    final responseData = json.decode(response.body);
    return responseData;
  }

  // Refresh the access token using the refresh token stored in shared preferences
  Future<Map<String, dynamic>> refresh() async {
    // print('Refreshing token...');
    final uri = Uri.parse('$apiUrl/session/refresh');

    // Get refresh token from shared preferences
    final refreshToken =
        await utils.getFromSharedPreferences('refreshToken', 'string');

    if (refreshToken == null) {
      return {"error": true, "message": "No refresh token found"};
    }

    final response =
        await http.get(uri, headers: {"Authorization": 'Bearer $refreshToken'});

    final responseData = json.decode(response.body);

    // If the resposne was successful, save the new access token to shared preferences
    if (responseData["error"] != null && responseData["error"] == false) {
      await utils.saveToSharedPreferences(
          "accessToken", responseData["accessToken"], "string");
    }

    return responseData;
  }

  // Verify the session using the access token stored in shared preferences
  // Param iteration is used to prevent infinite loop (Just try one more time if the token has expired)
  Future<Map<String, dynamic>> verify({int iteration = 1}) async {
    final uri = Uri.parse('$apiUrl/session/validate');

    // Get access token from shared preferences
    final accessToken =
        await utils.getFromSharedPreferences("accessToken", "string");

    if (accessToken == null) {
      return {"error": true, "message": "No access token found"};
    }

    final response = await http.get(
      uri,
      headers: <String, String>{
        'Authorization':
            'Bearer $accessToken', // Add the access token to the header
      },
    );

    final responseData = json.decode(response.body);

    // If the token has expired, try to refresh it
    if (responseData["error"] != null &&
        responseData["error"] == true &&
        // If the error is 403 (Forbidden)
        response.statusCode == 403) {
      if (iteration == 1) {
        final refreshResponse = await refresh();
        if (refreshResponse["error"] != null &&
            refreshResponse["error"] == false) {
          // If the refresh was successful, try to verify again
          return verify(iteration: iteration + 1);
        }
      }
    }

    return responseData;
  }
}
