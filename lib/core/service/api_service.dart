import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plant_app/models/Plant.dart';
// import 'plant_model.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/plantinfo/plantinfo/products/";

  static Future<List<Plant>> fetchPlants() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((item) => Plant.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load plants");
    }
  }
}
