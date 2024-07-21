import 'package:editor/providers/news_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsWidget extends StatefulWidget {
  final NewsViewModel newsArticle;

  NewsWidget({super.key, required this.newsArticle});

  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {

  void _launchURL() async {
    if (await canLaunchUrl(Uri.parse(widget.newsArticle.sourceLink))) {
      await launchUrl(Uri.parse(widget.newsArticle.sourceLink));
    } else {
      throw 'Could not launch ${widget.newsArticle.sourceLink}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/news_editing',
            arguments: widget.newsArticle);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 10,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(146, 29, 43, 54),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 30,
                    offset: Offset(10, 0),
                  ),
                ]),
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 20, bottom: 10, left: 40, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: context.watch<NewsListViewModel>().isSaved(widget.newsArticle.id) ? Color.fromARGB(255, 143, 105, 105) : Color.fromARGB(255, 105, 143, 107),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          context.watch<NewsListViewModel>().isSaved(widget.newsArticle.id) ? '✗ Not published' : '✓ Published',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.newsArticle.name,
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '#' + widget.newsArticle.tags.join(' #'),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: Text(
                      widget.newsArticle.body.length > 200
                          ? '${widget.newsArticle.body.substring(0, 200)}...'
                          : widget.newsArticle.body,
                      style:
                          const TextStyle(fontSize: 18, color: Colors.white70)),
                ),
                const SizedBox(width: 10),
                Row(
                  children: [
                    IconButton(
                      onPressed: _launchURL,
                      icon: Icon(Icons.remove_red_eye_rounded,
                          color: Colors.white),
                      tooltip: "View source",
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  'Are you sure you want to ${context.watch<NewsListViewModel>().isSaved(widget.newsArticle.id) ? 'publish' : 'unpublish'} this News Article?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    publish_unpublishNewsArticle(widget.newsArticle.id, context);
                                  },
                                  child: Text(context.watch<NewsListViewModel>().isSaved(widget.newsArticle.id) ? 'Publish' : 'Unpublish',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 15)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.public_outlined, color: Colors.white),
                      tooltip: context.watch<NewsListViewModel>().isSaved(widget.newsArticle.id) ? 'Publish' : 'Unpublish',
                    ),
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
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 15)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.delete, color: Colors.white),
                      tooltip: "Delete",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void deleteNewsArticle(String id, BuildContext context) async {

    if(context.read<NewsListViewModel>().isSaved(id)) {
      try {
        await context.read<NewsListViewModel>().removeSavedNewsArticle(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('News article deleted successfully!')),
        );
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete news article')),
        );
      }
    } else {
      try {
        await context.read<NewsListViewModel>().removePublishedNewsArticle(id);
        ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('News article deleted successfully!')));
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('Failed to delete news article')));
      }
    }
  }

  void publish_unpublishNewsArticle(String id, BuildContext context) async {

    if(context.read<NewsListViewModel>().isSaved(id)) {
      try {
        widget.newsArticle.id = await context.read<NewsListViewModel>().publishNewsArticle(id);
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
      }
    }else{
      try {
        widget.newsArticle.id = await context.read<NewsListViewModel>().unpublishNewsArticle(id);
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
      }
    }
  }

}
