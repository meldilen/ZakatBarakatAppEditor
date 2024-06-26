import 'package:editor/UI/Articles/Pages/article_creation.dart';
import 'package:editor/UI/Articles/Pages/article_editing.dart';
import 'package:editor/UI/Articles/Pages/article_list_page.dart';
import 'package:editor/providers/article_provider.dart';
import 'package:editor/UI/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ArticleListViewModel()),
      ],
      child: const MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple,),
      home: const HomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/article_list': (context) => const ArticleListPage(),
        '/article_creation': (context) => CreateArticlePage(),
        '/article_editing': (context) => EditArticlePage( article: ModalRoute.of(context)!.settings.arguments as ArticleViewModel,),
      },
    );
  }



}

