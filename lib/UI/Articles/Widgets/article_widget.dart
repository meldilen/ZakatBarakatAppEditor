import 'package:editor/providers/article_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArticleWidget extends StatefulWidget {
  final ArticleViewModel article;

  ArticleWidget({super.key, required this.article});

  @override
  _ArticleWidgetState createState() => _ArticleWidgetState();
}

class _ArticleWidgetState extends State<ArticleWidget> {
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
            child: Column(
              children: [
                Text(
                  widget.article.title,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '#' + widget.article.tags.join(' #'),
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/article_editing',
                              arguments: widget.article);
                        },
                        icon: Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                    'Are you sure you want to delete this article?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      deleteArticle(widget.article.id, context);
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
            )),
      ),
    );
  }

  void deleteArticle(String id, BuildContext context) async {
    try {
      await context.read<ArticleListViewModel>().removeArticle(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article deleted successfully!')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete article')),
      );
    }
  }
}
