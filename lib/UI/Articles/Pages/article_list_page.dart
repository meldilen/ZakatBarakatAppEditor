import 'package:editor/UI/Articles/Widgets/article_list.dart';
import 'package:editor/providers/article_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArticleListPage extends StatefulWidget {
  const ArticleListPage({super.key});

  @override
  _ArticleListPageState createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> {


  @override
  void initState() {
    super.initState();
    Provider.of<ArticleListViewModel>(context, listen: false).fetchArticles();
  }

  Widget _buildUI(List<ArticleViewModel> articles) {
    if(articles.isEmpty){
    return const Center(child: Text('No articles found'));
  }else{
    return ArticleList(articles: articles);
  }
  }


  Widget _buildButton(){
    return FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 9, 150, 33),
        onPressed: () {
          Navigator.pushNamed(context, '/article_creation');
        },
        child: const Icon(Icons.add),
      );
  }


  AppBar _buildAppBar() {
    return AppBar(
        backgroundColor: Color.fromARGB(255, 9, 150, 33),
        title: const Text(
          'Articles', 
          style: TextStyle(
            fontSize: 22, 
            fontWeight: FontWeight.bold, 
            color: Colors.white)
        ),
        centerTitle: true,
        elevation: 2,
      );
  }


  @override
  Widget build(BuildContext context) {
    var articles = context.watch<ArticleListViewModel>().articles;

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildUI(articles),
      floatingActionButton: _buildButton(),
    );
  }
  
  
}
