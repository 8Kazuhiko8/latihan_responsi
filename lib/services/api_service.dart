import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ApiService {
  static const String baseUrl = 'https://api.spaceflightnewsapi.net/v4';

  Future<List<Article>> getItems(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint/'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((item) => Article.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<Article> getItemDetail(String endpoint, int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint/$id/'));
    if (response.statusCode == 200) {
      return Article.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load item detail');
    }
  }
}
