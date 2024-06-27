import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';

@JsonSerializable()
class Article {
  final String id;
  final List<String> tags;
  final String title;
  final String text;
  final Content content;

  Article({
    required this.id,
    required this.tags,
    required this.title,
    required this.text,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}

@JsonSerializable()
class Content {
  final List<ContentItem> ops;

  Content({required this.ops});

  factory Content.fromJson(Map<String, dynamic> json) => _$ContentFromJson(json);
  Map<String, dynamic> toJson() => _$ContentToJson(this);
}

@JsonSerializable()
class ContentItem {
  final String? insert;
  final Map<String, dynamic>? attributes;

  ContentItem({this.insert, this.attributes});

  factory ContentItem.fromJson(Map<String, dynamic> json) => _$ContentItemFromJson(json);
  Map<String, dynamic> toJson() => _$ContentItemToJson(this);
}