import 'dart:convert';
import 'package:editor/models/questions_model.dart';
import 'package:http/http.dart' as http;

class QnaAPI {
  Future<List<Question>> getQuestions() async {
    final response = await http.get(Uri.parse('http://10.90.137.169:8000/qna/get-questions'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return  body.map((dynamic item) => Question.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load questions');
    } 
  }


  Future<void> deleteQuestion(String id) async {
    final response = await http.delete(Uri.parse("http://10.90.137.169:8000/qna/edit/delete-question/$id"));
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete question');
    }
  }

  Future<Question> createQuestion(String question, String answer, List<String> tags) async {
    final response = await http.post(
      Uri.parse('http://10.90.137.169:8000/qna/edit/create-question'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'question': question,
        'answer': answer,
        'tags': tags,
      }),
    );

    if (response.statusCode == 200) {
      return Question.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create question');
    }
  }


  Future<void> editQuestion(String id, String question, String answer, List<String> tags) async {
    final response = await http.put(
      Uri.parse('http://10.90.137.169:8000/qna/edit/edit-question/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'question': question,
        'answer': answer,
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