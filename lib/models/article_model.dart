class Article {
  final String id;
  final List<String> tags;
  final String title;
  final String text;

  Article({
    required this.id,
    required this.tags,
    required this.title,
    required this.text,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      tags: List<String>.from(json['tags']),
      title: json['title'],
      text: json['text'],
    );
  }
}