import 'package:editor/providers/news_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewsWidget extends StatefulWidget {
  final NewsViewModel newsArticle;

  NewsWidget({super.key, required this.newsArticle});

  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {

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
            Text(widget.newsArticle.name),
            IconButton(onPressed: () {
              Navigator.pushNamed(context, '/news_editing', arguments: widget.newsArticle);
            }, icon: Icon(Icons.edit)),
            IconButton(onPressed: () {
              deleteNewsArticle(widget.newsArticle.id, context);
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


  void deleteNewsArticle(String id, BuildContext context) async {
    try{
      await context.read<NewsListViewModel>().removeNewsArticle(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('News article deleted successfully!')),
      );
    }catch(e){
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete news article')),
      );
    }
  }
}