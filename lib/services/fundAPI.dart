import 'dart:convert';

import 'package:editor/models/fund_model.dart';
import 'package:http/http.dart' as http;

class FundAPI{
  final BaseUrl = 'http://158.160.153.243:8000';

  Future<List<Fund>> getFunds() async {
    final response = await http.get(Uri.parse('$BaseUrl/funds/get-funds'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Fund> funds = body.map((dynamic item) => Fund.fromJson(item)).toList();
      return  funds;
    } else {
      throw Exception('Failed to load funds');
    }
  }

  Future<void> deleteFund(String id) async {
    final response = await http.delete(Uri.parse('$BaseUrl/funds/edit/delete-fund/$id'));
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete fund');
    }
  }

  Future<Fund> createFund(String name, String link, String description, String logoLink) async {
    final response = await http.post(
      Uri.parse('$BaseUrl/funds/edit/create-fund/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'description': description,
        'logo_link': logoLink,
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
      Uri.parse('$BaseUrl/funds/edit/edit-fund/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'description': description,
        'logo_link': logoLink,
        'link': link,
    }));

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to update fund');
    }
  }

}