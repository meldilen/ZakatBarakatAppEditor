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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 200,
        vertical: 10,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
            height: 150,
            color: Color.fromARGB(255, 209, 217, 219),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    widget.newsArticle.name,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '#' + widget.newsArticle.tags.join(' #'),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/news_editing',
                                arguments: widget.newsArticle);
                          },
                          icon: Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                      'Are you sure you want to delete this News Article?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        deleteNewsArticle(
                                            widget.newsArticle.id, context);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Delete',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel',
                                          style: TextStyle(color: Colors.grey)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.delete)),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }

  void deleteNewsArticle(String id, BuildContext context) async {
    try {
      await context.read<NewsListViewModel>().removeNewsArticle(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('News article deleted successfully!')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete news article')),
      );
    }
  }
}
