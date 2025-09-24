import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  static const storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>?> fetchUserDetails() async {
    String? token = await storage.read(key: 'access_token');
    if (token != null) {
      var url = Uri.parse('https://sadqahzakaat.com/api/auth/users/me/');
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'JWT $token',
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    }
    return null;
  }
}
