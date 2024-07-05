import 'package:editor/models/news.dart';
import 'package:editor/services/newsAPI.dart';

import 'package:flutter/material.dart';

class NewsListViewModel extends ChangeNotifier{

  late List<NewsViewModel> news = [];

  Future<void> fetchNews() async {
    final news = await NewsAPI().getNews();
    this.news = news.map((news) => NewsViewModel(news: news)).toList();
    notifyListeners();
  }


  Future<void> removeNewsArticle(String id) async {
    await NewsAPI().deleteNews(id);
    news.removeWhere((news) => news.id == id);
    notifyListeners();
  }

  Future<void> createNewsArticle(String name, String body, String imageLink, String sourceLink, List<String> tags) async {
    News news  = await NewsAPI().createNewsArticle(name, body, imageLink, sourceLink, tags);
    this.news.add(NewsViewModel(news: news));
    notifyListeners();
  }

  Future<void> updateNewsArticle(String id, String name, String body, String imageLink, String sourceLink, List<String> tags) async {
    await NewsAPI().editNewsArticle(id, name, body, imageLink, sourceLink, tags);
    news = news.map((newsArticle) => newsArticle.id == id ? NewsViewModel(news: News(id: id, name: name, body: body, imageLink: imageLink, sourceLink: sourceLink, tags: tags)) : newsArticle).toList();
    notifyListeners();
  }
}

class NewsViewModel {
  final News news;

  NewsViewModel({required this.news});

  String get id => news.id;
  String get body => news.body;
  String get name => news.name;
  String get imageLink => news.imageLink;
  String get sourceLink => news.sourceLink;
  List<String> get tags => news.tags;
}
