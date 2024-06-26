import 'package:editor/services/articleAPI.dart';
import 'package:flutter/material.dart';
import 'package:editor/models/article_model.dart';

// Define a StateNotifier to manage the state of the articles
// class ArticleNotifier extends StateNotifier<List<Article>> {
//   ArticleNotifier() : super([]);

//   void setArticles(List<Article> articles) {
//     state = articles;
//   }

//   getArticles() {
//     return state;
//   }

//   void removeArticle(String id) {
//     state = state.where((article) => article.id != id).toList();
//   }

// }

// // Create a provider for the ArticleNotifier
// final articleProvider = StateNotifierProvider<ArticleNotifier, List<Article>>((ref) {
//   return ArticleNotifier();
// });

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

  Future<void> createArticle(String title, List<String> tags, String text) async {
    Article article = await ArticleAPI().createArticle(title, tags, text);
    articles.add(ArticleViewModel(article: article));
    notifyListeners();
  }

  Future<void> updateArticle(String id, String title, List<String> tags, String text) async {
    await ArticleAPI().updateArticle(id, title, tags, text);
    articles = articles.map((article) => article.id == id ? ArticleViewModel(article: Article(id: id, title: title, tags: tags, text: text)) : article).toList();
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
}

