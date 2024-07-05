import 'dart:convert';
import 'package:editor/models/organization_model.dart';
import 'package:http/http.dart' as http;

class OrganizationAPI{
  final BaseUrl = 'http://158.160.153.243:8000';

  Future<List<Organization>> getOrganizations() async {
    final response = await http.get(Uri.parse('$BaseUrl/organization/get-organizations'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Organization> organizations = body.map((dynamic item) => Organization.fromJson(item)).toList();
      return organizations;
    } else {
      throw Exception('Failed to load organizations');
    }
  }

  Future<void> deleteOrganization(String id) async {
    final response = await http.delete(Uri.parse('$BaseUrl/organization/edit/delete-organization/$id'));
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete organization');
    }
  }

  Future<Organization> createOrganization(String name, String description, String logo_link, String link, List<String> categories, List<String> countries) async {
    final response = await http.post(
      Uri.parse('$BaseUrl/organization/edit/create-organization'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'description': description,
        'logo_link': logo_link,
        'link': link,
        'categories': categories,
        'countries': countries, 
      }),
    );

    if (response.statusCode == 200) {
      return Organization.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create organization');
    }
  }

  Future<void> editOrganization(String id, String name, String description, String logo_link, String link, List<String> categories, List<String> countries) async {
    final response = await http.put(
      Uri.parse('$BaseUrl/organization/edit/edit-organization/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'description': description,
        'logo_link': logo_link,
        'link': link,
        'categories': categories,
        'countries': countries, 
    }));

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to update organization');
    }
  }

}