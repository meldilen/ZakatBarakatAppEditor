import 'package:editor/UI/Articles/Pages/article_creation.dart';
import 'package:editor/UI/Articles/Pages/article_editing.dart';
import 'package:editor/UI/Articles/Pages/article_list_page.dart';
import 'package:editor/UI/News/Pages/news_creation.dart';
import 'package:editor/UI/News/Pages/news_editing.dart';
import 'package:editor/UI/News/Pages/news_list_page.dart';
import 'package:editor/UI/Organizations/Pages/organization_creation.dart';
import 'package:editor/UI/Organizations/Pages/organization_editing.dart';
import 'package:editor/UI/Organizations/Pages/organizations_list_page.dart';
import 'package:editor/UI/Requests/pages/request_answer_as_article.dart';
import 'package:editor/UI/Requests/pages/request_answer_as_question.dart';
import 'package:editor/UI/Requests/pages/request_answer_type_page.dart';
import 'package:editor/UI/Requests/pages/request_list_page.dart';
import 'package:editor/providers/article_provider.dart';
import 'package:editor/UI/home_page.dart';
import 'package:editor/providers/fund_provider.dart';
import 'package:editor/providers/news_provider.dart';
import 'package:editor/providers/organization_provider.dart';
import 'package:editor/providers/qna_provider.dart';
import 'package:editor/providers/request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ArticleListViewModel()),
      ChangeNotifierProvider(create: (_) => QuestionListViewModel()),
      ChangeNotifierProvider(create: (_) => FundListViewModel()),
      ChangeNotifierProvider(create: (_) => NewsListViewModel()),
      ChangeNotifierProvider(create: (_) => OrganisationListViewModel()),
      ChangeNotifierProvider(create: (_) => RequestListViewModel()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple, fontFamily: 'Times'),
      home: const HomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/article_list': (context) => const ArticleListPage(),
        '/article_creation': (context) => CreateArticlePage(),
        '/article_editing': (context) => EditArticlePage(
              article: ModalRoute.of(context)!.settings.arguments
                  as ArticleViewModel,
            ), 
        '/news_list': (context) => const NewsListPage(),
        '/news_creation': (context) => CreateNewsArticlePage(),
        '/news_editing': (context) => EditNewsArticlePage(
              newsArticle:
                  ModalRoute.of(context)!.settings.arguments as NewsViewModel,
            ),
        '/organization_list': (context) => const OrganizationsListPage(),
        '/organization_creation': (context) => CreateOrganizationPage(),
        '/organization_editing': (context) => EditOrganizationPage(
              organization: ModalRoute.of(context)!.settings.arguments
                  as OrganizationViewModel,
            ),
        '/request_list': (context) => const RequestListPage(),
        '/request_answering': (context) => RequestAnswerTypePage(
              request: ModalRoute.of(context)!.settings.arguments
                  as RequestViewModel,
            ),
        '/request_answer_as_question': (context) => AnswerAsQuestionPage(
              request: ModalRoute.of(context)!.settings.arguments
                  as RequestViewModel,
            ),
        '/request_answer_as_article': (context) => AnswerAsArticlePage(
              request: ModalRoute.of(context)!.settings.arguments
                  as RequestViewModel,
            ),
      },
    );
  }
}




// Add this to routes for Q&A and Funds
// '/question_list': (context) => const QuestionListPage(),
//         '/question_creation': (context) => CreateQuestionPage(),
//         '/question_editing': (context) => EditQuestionPage(
//               question: ModalRoute.of(context)!.settings.arguments
//                   as QuestionViewModel,
//             ),
// '/fund_list': (context) => const FundListPage(),
//         '/fund_creation': (context) => CreateFundPage(),
//         '/fund_editing': (context) => EditFundPage(
//               fund: ModalRoute.of(context)!.settings.arguments as FundViewModel,
//             ),