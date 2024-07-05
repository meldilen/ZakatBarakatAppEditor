class News{
  String id;
  String name;
  String body;
  String imageLink;
  String sourceLink;
  List<String> tags;


  News({required this.id, required this.name, required this.body, required this.imageLink, required this.sourceLink, required this.tags});


  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      name: json['name'],
      body: json['body'],
      imageLink: json['image_link'],
      sourceLink: json['source_link'],
      tags: List<String>.from(json['tags']),
    );
  }
}