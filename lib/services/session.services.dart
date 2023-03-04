import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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
}
