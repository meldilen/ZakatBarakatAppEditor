import 'package:editor/models/organization_model.dart';
import 'package:editor/services/organizationAPI.dart';
import 'package:flutter/material.dart';

class OrganisationListViewModel extends ChangeNotifier{

  late List<OrganizationViewModel> organizations = [];
  late List<String> countries = [];
  late List<String> categories = [];

  Future<void> fetchOrganizations() async {
    final organizations = await OrganizationAPI().getOrganizations();
    this.organizations = organizations.map((organization) => OrganizationViewModel(organization: organization)).toList();
    notifyListeners();
  }


  Future<void> removeOrganization(String id) async {
    await OrganizationAPI().deleteOrganization(id);
    organizations.removeWhere((organization) => organization.id == id);
    notifyListeners();
  }

  Future<void> createOrganization(String name, String description, String logoLink, String link, List<String> categories, List<String> countries) async {
    Organization organization  = await OrganizationAPI().createOrganization(name, description, logoLink, link, categories, countries);
    this.organizations.add(OrganizationViewModel(organization: organization));
    notifyListeners();
  }

  Future<void> updateOrganization(String id, String name, String description, String logoLink, String link, List<String> categories, List<String> countries) async {
    await OrganizationAPI().editOrganization(id, name, description, logoLink, link, categories, countries);
    organizations = organizations.map((organization) => organization.id == id ? OrganizationViewModel(organization: Organization(id: id, name: name, description: description, logoLink: logoLink, link: link, categories: categories, countries: countries)) : organization).toList();
    notifyListeners();
  }


  Future<void> getOrganizationCategories() async {
    final categories = await OrganizationAPI().getOrganizationCategories();
    this.categories = categories;
    notifyListeners();
  }


  Future<void> getOrganizationCountries() async {
    final countries = await OrganizationAPI().getOrganizationCountries();
    this.countries = countries;
    notifyListeners();
  }


}

class OrganizationViewModel {
  final Organization organization;

  OrganizationViewModel({required this.organization});

  String get id => organization.id;
  String get name => organization.name;
  String get description => organization.description;
  String get logoLink => organization.logoLink;
  String get link => organization.link;
  List<String> get categories => organization.categories;
  List<String> get countries => organization.countries;
}
