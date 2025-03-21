import 'package:editor/models/organization_model.dart';
import 'package:editor/services/organizationAPI.dart';
import 'package:flutter/material.dart';

class OrganisationListViewModel extends ChangeNotifier{

  late List<OrganizationViewModel> publishedOrganizations = [];
  late List<OrganizationViewModel> savedOrganizations = [];
  late List<String> countries = [];
  late List<String> categories = [];

  Future<void> fetchPublishedOrganizations() async {
    final organizations = await OrganizationAPI().getPublishedOrganizations();
    this.publishedOrganizations = organizations.map((organization) => OrganizationViewModel(organization: organization)).toList();
    notifyListeners();
  }


  Future<void> fetchSavedOrganizations() async {
    final organizations = await OrganizationAPI().getSavedOrganizations();
    this.savedOrganizations = organizations.map((organization) => OrganizationViewModel(organization: organization)).toList();
    notifyListeners();
  }


  Future<void> removePublishedOrganization(String id) async {
    await OrganizationAPI().deletePublishedOrganization(id);
    publishedOrganizations.removeWhere((organization) => organization.id == id);
    notifyListeners();
  }


  Future<void> removeSavedOrganization(String id) async {
    await OrganizationAPI().deleteSavedOrganization(id);
    savedOrganizations.removeWhere((organization) => organization.id == id);
    notifyListeners();
  }

  Future<void> createPublishedOrganization(String name, String description, String link, List<String> categories, List<String> countries) async {
    Organization organization  = await OrganizationAPI().createPublishedOrganization(name, description, link, categories, countries);
    this.publishedOrganizations.add(OrganizationViewModel(organization: organization));
    notifyListeners();
  }


  Future<void> createSavedOrganization(String name, String description, String link, List<String> categories, List<String> countries) async {
    Organization organization  = await OrganizationAPI().createSavedOrganization(name, description, link, categories, countries);
    this.savedOrganizations.add(OrganizationViewModel(organization: organization));
    notifyListeners();
  }

  Future<void> updatePublishedOrganization(String id, String name, String description,  String link, List<String> categories, List<String> countries) async {
    await OrganizationAPI().editPublishedOrganization(id, name, description, link, categories, countries);
    publishedOrganizations = publishedOrganizations.map((organization) => organization.id == id ? OrganizationViewModel(organization: Organization(id: id, name: name, description: description, link: link, categories: categories, countries: countries)) : organization).toList();
    notifyListeners();
  }


  Future<void> updateSavedOrganization(String id, String name, String description,  String link, List<String> categories, List<String> countries) async {
    await OrganizationAPI().editSavedOrganization(id, name, description, link, categories, countries);
    savedOrganizations = savedOrganizations.map((organization) => organization.id == id ? OrganizationViewModel(organization: Organization(id: id, name: name, description: description, link: link, categories: categories, countries: countries)) : organization).toList();
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


  Future<String> publishOrganization(String id) async{
    Organization organization  = await OrganizationAPI().publish(id);
    publishedOrganizations.add(OrganizationViewModel(organization: organization));
    savedOrganizations.removeWhere((organizationVM) => organizationVM.id == id);
    notifyListeners();
    return organization.id;
  }


  Future<String> unpublishOrganization(String id) async{
    Organization organization  = await OrganizationAPI().unpublish(id);
    savedOrganizations.add(OrganizationViewModel(organization: organization));
    publishedOrganizations.removeWhere((organizationVM) => organizationVM.id == id);
    notifyListeners();
    return organization.id;
  }


  bool isSaved(String id) {
    return savedOrganizations.any((organization) => organization.id == id);
  }

}

class OrganizationViewModel {
  final Organization organization;

  OrganizationViewModel({required this.organization});

  String get id => organization.id;
  String get name => organization.name;
  String get description => organization.description;
  String get link => organization.link;
  List<String> get categories => organization.categories;
  List<String> get countries => organization.countries;
  set id (String id) => organization.id = id;
}
