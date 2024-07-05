
import 'package:editor/UI/Articles/Widgets/article_widget.dart';
import 'package:editor/providers/article_provider.dart';
import 'package:flutter/material.dart';

class ArticleList extends StatefulWidget {
  final List<ArticleViewModel> articles;

  ArticleList({super.key, required this.articles});

  @override
  _ArticleListState createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea (
      top: true,
      child: ListView.builder(
        itemCount: widget.articles.length,
        itemBuilder: (context, index) {
          return ArticleWidget(article: widget.articles[index]);
        },
    )
    );
  }

}