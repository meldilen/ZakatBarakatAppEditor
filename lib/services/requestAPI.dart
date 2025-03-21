import 'dart:convert';
import 'package:editor/models/request_model.dart';
import 'package:http/http.dart' as http;

class RequestAPI{
  final BaseUrl = 'https://weaviatetest.onrender.com';

  Future<List<RequestModel>> getRequests() async {
    final response = await http.get(Uri.parse('$BaseUrl/knowledge-base/edit/get-requests'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<RequestModel> requests = body.map((dynamic item) => RequestModel.fromJson(item)).toList();
      return requests;
    } else {
      throw Exception('Failed to load requests');
    }
  }

  Future<void> deleteRequest(String id) async {
    final response = await http.delete(Uri.parse('$BaseUrl/knowledge-base/edit/delete-request/$id'));
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete request');
    }
  }

}