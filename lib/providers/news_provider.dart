import 'package:editor/models/news.dart';
import 'package:editor/services/newsAPI.dart';

import 'package:flutter/material.dart';

class NewsListViewModel extends ChangeNotifier{

  late List<NewsViewModel> publishedNews = [];
  late List<NewsViewModel> savedNews = [];

  Future<void> fetchPublishedNews() async {
    final news = await NewsAPI().getPublishedNews();
    this.publishedNews = news.map((news) => NewsViewModel(news: news)).toList();
    notifyListeners();
  }

  Future<void> fetchSavedNews() async {
    final news = await NewsAPI().getSavedNews();
    this.savedNews = news.map((news) => NewsViewModel(news: news)).toList();
    notifyListeners();
  }


  Future<void> removePublishedNewsArticle(String id) async {
    await NewsAPI().deletePublishedNews(id);
    publishedNews.removeWhere((news) => news.id == id);
    notifyListeners();
  }


  Future<void> removeSavedNewsArticle(String id) async {
    await NewsAPI().deleteSavedNews(id);
    savedNews.removeWhere((news) => news.id == id);
    notifyListeners();
  }

  Future<void> createPublishedNewsArticle(String name, String body, String sourceLink, List<String> tags) async {
    News news  = await NewsAPI().createPublishedNewsArticle(name, body, sourceLink, tags);
    this.publishedNews.add(NewsViewModel(news: news));
    notifyListeners();
  }

  Future<void> createSavedNewsArticle(String name, String body, String sourceLink, List<String> tags) async {
    News news  = await NewsAPI().createSavedNewsArticle(name, body, sourceLink, tags);
    this.savedNews.add(NewsViewModel(news: news));
    notifyListeners();
  }

  Future<void> updatePublishedNewsArticle(String id, String name, String body, String sourceLink, List<String> tags) async {
    await NewsAPI().editPublishedNewsArticle(id, name, body, sourceLink, tags);
    publishedNews = publishedNews.map((newsArticle) => newsArticle.id == id ? NewsViewModel(news: News(id: id, name: name, body: body, sourceLink: sourceLink, tags: tags)) : newsArticle).toList();
    notifyListeners();
  }

  Future<void> updateSavedNewsArticle(String id, String name, String body, String sourceLink, List<String> tags) async {
    await NewsAPI().editSavedNewsArticle(id, name, body, sourceLink, tags);
    savedNews = savedNews.map((newsArticle) => newsArticle.id == id ? NewsViewModel(news: News(id: id, name: name, body: body, sourceLink: sourceLink, tags: tags)) : newsArticle).toList();
    notifyListeners();
  }


  Future<String> publishNewsArticle(String id) async {
    News news = await NewsAPI().publish(id);
    publishedNews.add(NewsViewModel(news: news));
    savedNews.removeWhere((newsVM) => newsVM.id == id);
    notifyListeners();
    return news.id;
  }


  Future<String> unpublishNewsArticle(String id) async {
    News news = await NewsAPI().unpublish(id);
    savedNews.add(NewsViewModel(news: news));
    publishedNews.removeWhere((newsVM) => newsVM.id == id);
    notifyListeners();
    return news.id;
  }


  bool isSaved(String id) {
    return savedNews.any((news) => news.id == id);
  }
}

class NewsViewModel {
  final News news;

  NewsViewModel({required this.news});

  String get id => news.id;
  String get body => news.body;
  String get name => news.name;
  String get sourceLink => news.sourceLink;
  List<String> get tags => news.tags;
  set id (String id) => news.id = id;
}
