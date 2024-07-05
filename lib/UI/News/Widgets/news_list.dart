import 'package:editor/UI/News/Widgets/news_article_widget.dart';
import 'package:editor/providers/news_provider.dart';
import 'package:flutter/material.dart';

class NewsList extends StatefulWidget {
  final List<NewsViewModel> news;

  NewsList({super.key, required this.news});

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea (
      top: true,
      child: ListView.builder(
        itemCount: widget.news.length,
        itemBuilder: (context, index) {
          return NewsWidget(newsArticle: widget.news[index]);
        },
    )
    );
  }

}