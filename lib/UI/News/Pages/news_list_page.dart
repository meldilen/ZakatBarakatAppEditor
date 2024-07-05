import 'package:editor/UI/News/Widgets/news_list.dart';
import 'package:editor/providers/news_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {


  @override
  void initState() {
    super.initState();
    Provider.of<NewsListViewModel>(context, listen: false).fetchNews();
  }

  Widget _buildUI(List<NewsViewModel> news) {
    if(news.isEmpty){
    return const Center(child: Text('No news found'));
  }else{
    return NewsList(news: news);
  }
  }


  Widget _buildButton(){
    return FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 215, 225, 31),
        onPressed: () {
          Navigator.pushNamed(context, '/news_creation');
        },
        child: const Icon(Icons.add),
      );
  }


  AppBar _buildAppBar() {
    return AppBar(
        backgroundColor: Color.fromARGB(255, 215, 225, 31),
        title: const Text(
          'News', 
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
    var news = context.watch<NewsListViewModel>().news;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildUI(news),
      floatingActionButton: _buildButton(),
    );
  }
  
  
}
