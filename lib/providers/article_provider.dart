import 'package:editor/services/articleAPI.dart';
import 'package:flutter/material.dart';
import 'package:editor/models/article.dart';



class ArticleListViewModel extends ChangeNotifier{

  late List<ArticleViewModel> PublishedArticles = [];
  late List<ArticleViewModel> SavedArticles = [];

  Future<void> fetchPublshedArticles() async {
    final articles = await ArticleAPI().getPublishedArticles();
    this.PublishedArticles = articles.map((article) => ArticleViewModel(article: article)).toList(); 
    notifyListeners();
  }


  Future<void> fetchSavedArticles() async {
    final articles = await ArticleAPI().getSavedArticles();
    this.SavedArticles = articles.map((article) => ArticleViewModel(article: article)).toList();
    notifyListeners();
  }



  Future<void> removePublishedArticle(String id) async {
    await ArticleAPI().deletePublishedAricle(id);
    PublishedArticles.removeWhere((article) => article.id == id);
    notifyListeners();
  }

  Future<void> removeSavedArticle(String id) async {
    await ArticleAPI().deleteSavedAricle(id);
    SavedArticles.removeWhere((article) => article.id == id);
    notifyListeners();
  }

  Future<void> createPublishedArticle(String title, List<String> tags, String text, List<Map<String, dynamic>> ops) async {
    Article article = await ArticleAPI().createPublishedArticle(title, tags, text, ops);
    PublishedArticles.add(ArticleViewModel(article: article));
    notifyListeners();
  }


  Future<void> createSavedArticle(String title, List<String> tags, String text, List<Map<String, dynamic>> ops) async {
    Article article = await ArticleAPI().createSavedArticle(title, tags, text, ops);
    SavedArticles.add(ArticleViewModel(article: article));
    notifyListeners();
  }


  Future<void> updatePublishedArticle(String id, String title, List<String> tags, String text, List<Map<String, dynamic>> ops) async {
    await ArticleAPI().updatePublishedArticle(id, title, tags, text, ops);
    PublishedArticles = PublishedArticles.map((articleVM) {
      if (articleVM.id == id) {
        Article updatedArticle = Article(
          id: id,
          title: title,
          tags: tags,
          text: text,
          content: Content(ops: ops.map((op) => ContentItem.fromJson(op)).toList()),
        );
        return ArticleViewModel(article: updatedArticle);
      } else {
        return articleVM;
      }
    }).toList();
    notifyListeners();
  }


  Future<void> updateSavedArticle(String id, String title, List<String> tags, String text, List<Map<String, dynamic>> ops) async {
    await ArticleAPI().updateSavedArticle(id, title, tags, text, ops);
    SavedArticles = SavedArticles.map((articleVM) {
      if (articleVM.id == id) {
        Article updatedArticle = Article(
          id: id,
          title: title,
          tags: tags,
          text: text,
          content: Content(ops: ops.map((op) => ContentItem.fromJson(op)).toList()),
        );
        return ArticleViewModel(article: updatedArticle);
      } else {
        return articleVM;
      }
    }).toList();
    notifyListeners();
  }
  


  Future<String> publishArticle(String id) async {
    Article article = await ArticleAPI().publishArticle(id);
    PublishedArticles.add(ArticleViewModel(article: article));
    SavedArticles.removeWhere((articleVM) => articleVM.id == id);
    notifyListeners();
    return article.id;
  }

  Future<String> unpublishArticle(String id) async {
    Article article = await ArticleAPI().unpublishArticle(id);
    SavedArticles.add(ArticleViewModel(article: article));
    PublishedArticles.removeWhere((articleVM) => articleVM.id == id);
    notifyListeners();
    return article.id;
  }


  bool isSaved(String id) {
    return SavedArticles.any((articleVM) => articleVM.id == id);
  }
}


class ArticleViewModel {
  final Article article;

  ArticleViewModel({required this.article});

  String get title => article.title;
  String get text => article.text;
  String get id => article.id;
  List<String> get tags => article.tags;
  get content => article.content;

  set id (String id) => article.id = id;
}

