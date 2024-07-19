class Organization{
  String id;
  String name;
  String link;
  String description;
  List<String> categories;
  List<String> countries;


  Organization({required this.id, required this.name, required this.link, required this.description, required this.categories, required this.countries});

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'],
      name: json['name'],
      link: json['link'],
      description: json['description'],
      categories: List<String>.from(json['categories']),
      countries: List<String>.from(json['countries']),
    );
  }
}