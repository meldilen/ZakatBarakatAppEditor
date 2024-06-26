import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:editor/models/article_model.dart';

class ArticleAPI {
  Future<List<Article>> getArticles() async {
    final response = await http.get(Uri.parse('http://10.90.137.169:8000/knowledge-base/get-articles'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return  body.map((dynamic item) => Article.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load articles');
    } 
  }

  Future<void> deleteAricle(String id) async {
    final response = await http.delete(Uri.parse('http://10.90.137.169:8000/knowledge-base/edit/delete-article/$id'));
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete article');
    }
  }

  Future<Article> createArticle(String title, List<String> tags, String text) async {
    final response = await http.post(
      Uri.parse('http://10.90.137.169:8000/knowledge-base/edit/create-article'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'tags': tags,
        'text': text,
      }),
    );

    if (response.statusCode == 200) {
      return Article.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create article');
    }
  }


  Future<void> updateArticle(String id, String title, List<String> tags, String text) async {
    final response = await http.put(
      Uri.parse('http://10.90.137.169:8000/knowledge-base/edit/edit-article/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'tags': tags,
        'text': text,
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to update article');
    }
  }
}