import 'dart:convert';
import 'package:editor/models/news.dart';
import 'package:http/http.dart' as http;

class NewsAPI {
  final BaseUrl = 'https://weaviatetest.onrender.com';

  Future<List<News>> getPublishedNews() async {
    final response = await http.get(Uri.parse('$BaseUrl/news/get-news'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return  body.map((dynamic item) => News.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load news');
    } 
  }


  Future<List<News>> getSavedNews() async {
    final response = await http.get(Uri.parse('$BaseUrl/saved-news/get-saved-news'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return  body.map((dynamic item) => News.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load news');
    } 
  }


  Future<void> deletePublishedNews(String id) async {
    final response = await http.delete(Uri.parse("$BaseUrl/news/edit/delete-news-article/$id"));
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete news article');
    }
  }


  Future<void> deleteSavedNews(String id) async {
    final response = await http.delete(Uri.parse("$BaseUrl/saved-news/delete-saved-news-article/$id"));
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete news article');
    }
  }


  Future<News> createPublishedNewsArticle(String name, String body, String source_link, List<String> tags) async {
    final response = await http.post(
      Uri.parse('$BaseUrl/news/edit/create-news_article'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'body': body,
        'source_link': source_link,
        'tags': tags,
      }),
    );

    if (response.statusCode == 200) {
      return News.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 422) {
      final errorResponse = jsonDecode(response.body);
      final errorMessage = errorResponse['detail'];
      throw Exception('Failed to create news article: $errorMessage');
    } else {
      throw Exception('Failed to create news article: ${response.reasonPhrase}');
    }
  }


  Future<News> createSavedNewsArticle(String name, String body, String source_link, List<String> tags) async {
    final response = await http.post(
      Uri.parse('$BaseUrl/saved-news/create-saved_news_article'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'body': body,
        'source_link': source_link,
        'tags': tags,
      }),
    );

    if (response.statusCode == 200) {
      return News.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 422) {
      final errorResponse = jsonDecode(response.body);
      final errorMessage = errorResponse['detail'];
      throw Exception('Failed to create news article: $errorMessage');
    } else {
      throw Exception('Failed to create news article: ${response.reasonPhrase}');
    }
  }


  Future<void> editPublishedNewsArticle(String id, String name, String body, String source_link, List<String> tags) async {
    final response = await http.put(
      Uri.parse('$BaseUrl/news/edit/edit-news-article/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'body': body,
        'source_link': source_link,
        'tags': tags,
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 422) {
      final errorResponse = jsonDecode(response.body);
      final errorMessage = errorResponse['detail'];
      throw Exception('Failed to edit news article: $errorMessage');
    } else {
      throw Exception('Failed to edit news article: ${response.reasonPhrase}');
    }
  }


  Future<void> editSavedNewsArticle(String id, String name, String body, String source_link, List<String> tags) async {
    final response = await http.put(
      Uri.parse('$BaseUrl/saved-news/edit-saved-news-article/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'body': body,
        'source_link': source_link,
        'tags': tags,
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 422) {
      final errorResponse = jsonDecode(response.body);
      final errorMessage = errorResponse['detail'];
      throw Exception('Failed to edit news article: $errorMessage');
    } else {
      throw Exception('Failed to edit news article: ${response.reasonPhrase}');
    }
  }


  Future<News> publish(String id) async {
    final response = await http.post(Uri.parse('$BaseUrl/saved-news/publish/$id'));
    if (response.statusCode == 200) {
      return News.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to publish news article');
    }
  }


  Future<News> unpublish(String id) async {
    final response = await http.post(Uri.parse('$BaseUrl/news/edit/unpublish/$id'));
    if (response.statusCode == 200) {
      return News.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to unpublish news article');
    }
  }

}