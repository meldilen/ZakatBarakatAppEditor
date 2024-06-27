import 'dart:convert';

import 'package:editor/models/fund_model.dart';
import 'package:http/http.dart' as http;

class FundAPI{
  Future<List<Fund>> getFunds() async {
    final response = await http.get(Uri.parse('http://10.90.137.169:8000/funds/get-funds'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return  body.map((dynamic item) => Fund.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load funds');
    }
  }

  Future<void> deleteFund(String id) async {
    final response = await http.delete(Uri.parse('http://10.90.137.169:8000/funds/edit/delete-fund/$id'));
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete fund');
    }
  }

  Future<Fund> createFund(String name, String link, String description, String logoLink) async {
    final response = await http.post(
      Uri.parse('http://10.90.137.169:8000/funds/edit/create-fund'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'description': description,
        'logoLink': logoLink,
        'link': link,
      }),
    );

    if (response.statusCode == 200) {
      return Fund.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create fund');
    }
  }

  Future<void> editFund(String id, String name, String link, String description, String logoLink) async {
    final response = await http.put(
      Uri.parse('http://10.90.137.169:8000/funds/edit/edit-fund/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'description': description,
        'logoLink': logoLink,
        'link': link,
    }));

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to update fund');
    }
  }

}