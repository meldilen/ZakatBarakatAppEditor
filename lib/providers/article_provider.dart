import 'package:editor/services/articleAPI.dart';
import 'package:flutter/material.dart';
import 'package:editor/models/article.dart';



class ArticleListViewModel extends ChangeNotifier{

  late List<ArticleViewModel> articles = [];

  Future<void> fetchArticles() async {
    final articles = await ArticleAPI().getArticles();
    this.articles = articles.map((article) => ArticleViewModel(article: article)).toList(); 
    notifyListeners();
  }

  Future<void> removeArticle(String id) async {
    await ArticleAPI().deleteAricle(id);
    articles.removeWhere((article) => article.id == id);
    notifyListeners();
  }

  Future<void> createArticle(String title, List<String> tags, String text, List<Map<String, dynamic>> ops) async {
    Article article = await ArticleAPI().createArticle(title, tags, text, ops);
    articles.add(ArticleViewModel(article: article));
    notifyListeners();
  }

  Future<void> updateArticle(String id, String title, List<String> tags, String text, List<Map<String, dynamic>> ops) async {
    await ArticleAPI().updateArticle(id, title, tags, text, ops);
    articles = articles.map((articleVM) {
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


}


class ArticleViewModel {
  final Article article;

  ArticleViewModel({required this.article});

  String get title => article.title;
  String get text => article.text;
  String get id => article.id;
  List<String> get tags => article.tags;
  get content => article.content;
}

