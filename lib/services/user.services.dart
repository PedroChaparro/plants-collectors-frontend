import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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
}
