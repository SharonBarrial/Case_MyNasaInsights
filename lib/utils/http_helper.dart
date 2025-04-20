import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:eb20242u202114900/models/PhotoInfo.dart';

class HttpHelper {
  static const String baseUrl =
      "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos";

  static Future<List<PhotoInfo>> fetchPhotos({int sol = 1000, int page = 1}) async {
    final response = await http.get(Uri.parse('$baseUrl?sol=$sol&api_key=hnNjW2rUgF3cL0JuGwRlSI48ZX40k9CZcseAAmYQ'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body)['photos'];
      return jsonData.map((e) => PhotoInfo.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch photos');
    }
  }
}