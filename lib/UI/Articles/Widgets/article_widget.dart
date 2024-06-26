import 'package:editor/providers/article_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArticleWidget extends StatefulWidget {
  final ArticleViewModel article;

  ArticleWidget({required this.article});

  @override
  _ArticleWidgetState createState() => _ArticleWidgetState();
}

class _ArticleWidgetState extends State<ArticleWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.article.title),
            IconButton(onPressed: () {
              Navigator.pushNamed(context, '/article_editing', arguments: widget.article);
            }, icon: Icon(Icons.edit)),
            IconButton(onPressed: () {
              deleteArticle(widget.article.id, context);
            }, icon: Icon(Icons.delete)),
          ],
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: Color.fromARGB(255, 16, 31, 24),
        ),
      ],
    );
  }


  void deleteArticle(String id, BuildContext context) async {
    try{
      await context.read<ArticleListViewModel>().removeArticle(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article deleted successfully!')),
      );
    }catch(e){
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete article')),
      );
    }
  }
}