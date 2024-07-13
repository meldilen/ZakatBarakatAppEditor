import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:editor/models/article.dart';

class ArticleAPI {

  final BaseUrl = 'https://weaviatetest.onrender.com';
  Future<List<Article>> getArticles() async {
      final response = await http.get(Uri.parse('$BaseUrl/knowledge-base/get-articles'));
      if (response.statusCode == 200) {
        final List<dynamic> responseJson = jsonDecode(response.body);
        List<Article> articles = responseJson.map((item) => Article.fromJson(item as Map<String, dynamic>)).toList();
        return articles;
      } else {
        throw Exception('Failed to load articles');
      }
  }

  Future<void> deleteAricle(String id) async {
    final response = await http.delete(Uri.parse('$BaseUrl/knowledge-base/edit/delete-article/$id'));
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete article');
    }
  }

  Future<Article> createArticle(String title, List<String> tags, String text, List<Map<String, dynamic>> ops) async {
    final response = await http.post(
      Uri.parse('$BaseUrl/knowledge-base/edit/create-article'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'tags': tags,
        'text': text,
        'content': {'ops': ops}
      }),
    );

    if (response.statusCode == 200) {
      return Article.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create article');
    }
  }


  Future<void> updateArticle(String id, String title, List<String> tags, String text, List<Map<String, dynamic>> ops) async {
    final response = await http.put(
      Uri.parse('$BaseUrl/knowledge-base/edit/edit-article/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'tags': tags,
        'text': text,
        'content': {'ops': ops}
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to update article');
    }
  }
}