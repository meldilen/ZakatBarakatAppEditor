import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final List<Map<String, dynamic>> buttonData = [
    {'title': 'Articles', 'route': '/article_list'},
    {'title': 'Organizations', 'route': '/organization_list'},
    {'title': 'News', 'route': '/news_list'},
    {'title': 'User Requests', 'route': '/request_list'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 88, 96, 85),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color.fromARGB(255, 29, 43, 54),
            expandedHeight: 200,
            collapsedHeight: 85,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Color.fromARGB(255, 29, 43, 54),
              ),
              title: Text(
                'EDITOR',
                style: TextStyle(
                    fontFamily: 'Times',
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: 250,
              vertical: 50,
            ),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, buttonData[index]['route']);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 100,
                        color: const Color.fromARGB(255, 209, 217, 219),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(15),
                        child: Text(
                          buttonData[index]['title'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// Add this to button data for Q&A and Funds, and increase childCount in SilverChildBuilderDelegate 
// {'title': 'Questions\n&\nAnswers', 'route': '/question_list'},
// {'title': 'Charity Funds', 'route': '/fund_list'},
    