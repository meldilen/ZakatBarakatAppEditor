import 'dart:convert';
import 'package:editor/models/news.dart';
import 'package:http/http.dart' as http;

class NewsAPI {
  final BaseUrl = 'http://158.160.153.243:8000';

  Future<List<News>> getNews() async {
    final response = await http.get(Uri.parse('$BaseUrl/news/get-news'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return  body.map((dynamic item) => News.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load news');
    } 
  }


  Future<void> deleteNews(String id) async {
    final response = await http.delete(Uri.parse("$BaseUrl/news/edit/delete-news-article/$id"));
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete news article');
    }
  }

  Future<News> createNewsArticle(String name, String body, String image_link, String source_link, List<String> tags) async {
    final response = await http.post(
      Uri.parse('$BaseUrl/news/edit/create-news_article'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'body': body,
        'image_link': image_link,
        'source_link': source_link,
        'tags': tags,
      }),
    );

    if (response.statusCode == 200) {
      return News.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create question');
    }
  }


  Future<void> editNewsArticle(String id, String name, String body, String image_link, String source_link, List<String> tags) async {
    final response = await http.put(
      Uri.parse('$BaseUrl/news/edit/edit-news-article/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'body': body,
        'image_link': image_link,
        'source_link': source_link,
        'tags': tags,
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to update question');
    }
  }

}