import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:plants_collectors/services/session.services.dart';
import 'package:plants_collectors/utils/utils.dart';

final utils = Utils();
final sessionServices = SessionServices();

class UserServices {
  // Get the API base URL from the .env file
  final apiUrl = dotenv.get('API_BASE_URL');

  Future<Map<String, dynamic>> signup(
      String username, String email, String password) async {
    // Create the uri to send the request to
    final uri = Uri.parse('$apiUrl/user/signup');

    // Create a map to convert the data to JSON
    final Map<String, dynamic> data = {
      'username': username,
      'email': email,
      'password': password,
    };

    // Send the request to the API
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

  Future<Map<String, dynamic>> addToFavorites(int plantId,
      {int iteration = 1}) async {
    // Create the uri to send the request to
    final uri = Uri.parse('$apiUrl/user/favorites/$plantId');

    // Get the access token from the local storage
    final accessToken =
        await utils.getFromSharedPreferences('accessToken', 'string');

    if (accessToken == '') {
      return {
        'error': 'true',
        'message': 'Unable to retrieve session, please again later'
      };
    }

    // Send the request to the API
    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
    );

    final responseData = json.decode(response.body);

    // If the token has expired, try to refresh it
    if (responseData['error'] != null &&
        responseData['error'] == true &&
        response.statusCode == 403 &&
        iteration == 1) {
      // Refresh the token
      final refreshResponse = await sessionServices.refresh();

      if (refreshResponse['error'] != null &&
          refreshResponse['error'] == false) {
        return await addToFavorites(plantId, iteration: 2);
      } else {
        return refreshResponse;
      }
    }

    return responseData;
  }

  Future<Map<String, dynamic>> deleteFromFavorites(int plantId,
      {int iteration = 1}) async {
    final uri = Uri.parse('$apiUrl/user/favorites/$plantId');

    // Get the access token from the local storage
    final accessToken =
        await utils.getFromSharedPreferences('accessToken', 'string');

    if (accessToken == '') {
      return {
        'error': 'true',
        'message': 'Unable to retrieve session, please again later'
      };
    }

    // Send the request to the API
    final response = await http
        .delete(uri, headers: {"Authorization": "Bearer $accessToken"});
    final responseData = json.decode(response.body);

    // If the token has expired, try to refresh it
    if (responseData['error'] != null &&
        responseData['error'] == true &&
        response.statusCode == 403 &&
        iteration == 1) {
      // Refresh the token
      final refreshResponse = await sessionServices.refresh();

      if (refreshResponse['error'] != null &&
          refreshResponse['error'] == false) {
        return await deleteFromFavorites(plantId, iteration: 2);
      } else {
        return refreshResponse;
      }
    }

    return responseData;
  }

  Future<Map<String, dynamic>> getFavorites({int iteration = 1}) async {
    final uri = Uri.parse('$apiUrl/user/favorites');

    // Get the access token from the local storage
    final accessToken =
        await utils.getFromSharedPreferences('accessToken', 'string');

    if (accessToken == '') {
      return {
        'error': 'true',
        'message': 'Unable to retrieve session, please again later'
      };
    }

    // Send the request to the API
    final response =
        await http.get(uri, headers: {'Authorization': 'Bearer $accessToken'});

    final responseData = json.decode(response.body);

    // If the token has expired, try to refresh it
    if (responseData['error'] != null &&
        responseData['error'] == true &&
        response.statusCode == 403 &&
        iteration == 1) {
      // Refresh the token
      final refreshResponse = await sessionServices.refresh();

      if (refreshResponse['error'] != null &&
          refreshResponse['error'] == false) {
        return await getFavorites(iteration: 2);
      } else {
        return refreshResponse;
      }
    }

    return responseData;
  }
}
