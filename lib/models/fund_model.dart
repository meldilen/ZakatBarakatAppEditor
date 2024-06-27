class Fund{
  String id;
  String name;
  String link;
  String description;
  String logoLink;

  Fund({required this.id, required this.name, required this.link, required this.description, required this.logoLink});

  factory Fund.fromJson(Map<String, dynamic> json) {
    return Fund(
      id: json['id'],
      name: json['name'],
      link: json['link'],
      description: json['description'],
      logoLink: json['logoLink'],
    );
  }
}