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
    {'title': 'Questions\n&\nAnswers', 'route': '/question_list'},
    {'title': 'Charity Funds', 'route': '/fund_list'},
    {'title': 'Organizations', 'route': '/organization_list'},
    {'title': 'News', 'route': '/news_list'},
    {'title': 'User Requests', 'route': '/request_list'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 88, 96, 85),
      // appBar: AppBar(
      //   backgroundColor: Colors.deepPurple,
      //   title: const Text(
      //     'Home Page',
      //     style: TextStyle(
      //       fontSize: 22,
      //       fontWeight: FontWeight.bold,
      //       color: Colors.white)
      //   ),
      //   centerTitle: true,
      //   elevation: 2,
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color.fromARGB(255, 29, 43, 54),
            expandedHeight: 300,
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
            padding: const EdgeInsets.only(
                top: 50, left: 350, right: 350, bottom: 50),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
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
                childCount: 6,
              ),
            ),
          ),
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.all(20.0),
          //     child: ClipRRect(
          //       borderRadius: BorderRadius.circular(20),
          //       child: Container(
          //         height: 400,
          //         color: Color.fromARGB(255, 209, 217, 219),
          //       ),
          //     ),
          //   ),
          // ),
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.all(20.0),
          //     child: ClipRRect(
          //       borderRadius: BorderRadius.circular(20),
          //       child: Container(
          //         height: 400,
          //         color: Color.fromARGB(255, 209, 217, 219),
          //       ),
          //     ),
          //   ),
          // ),
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.all(20.0),
          //     child: ClipRRect(
          //       borderRadius: BorderRadius.circular(20),
          //       child: Container(
          //         height: 400,
          //         color: Color.fromARGB(255, 209, 217, 219),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
    //   SafeArea(
    //     top: true,
    //     child: Column(
    //       mainAxisSize: MainAxisSize.max,
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: [
    //         Expanded(
    //           child: Align(
    //               alignment: AlignmentDirectional(0, 0),
    //               child: ElevatedButton(
    //                 onPressed: () {
    //                   Navigator.pushNamed(context, '/article_list');
    //                 },
    //                 child: const Text('Articles'),
    //               )),
    //         ),
    //         Expanded(
    //           child: Align(
    //               alignment: AlignmentDirectional(0, 0),
    //               child: ElevatedButton(
    //                 onPressed: () {
    //                   Navigator.pushNamed(context, '/question_list');
    //                 },
    //                 child: const Text('Q&As'),
    //               )),
    //         ),
    //         Expanded(
    //           child: Align(
    //               alignment: AlignmentDirectional(0, 0),
    //               child: ElevatedButton(
    //                 onPressed: () {
    //                   Navigator.pushNamed(context, '/fund_list');
    //                 },
    //                 child: const Text('Funds'),
    //               )),
    //         ),
    //         Expanded(
    //           child: Align(
    //               alignment: AlignmentDirectional(0, 0),
    //               child: ElevatedButton(
    //                 onPressed: () {
    //                   Navigator.pushNamed(context, '/news_list');
    //                 },
    //                 child: const Text('News'),
    //               )),
    //         ),
    //         Expanded(
    //           child: Align(
    //               alignment: AlignmentDirectional(0, 0),
    //               child: ElevatedButton(
    //                 onPressed: () {
    //                   Navigator.pushNamed(context, '/organization_list');
    //                 },
    //                 child: const Text('Organizations'),
    //               )),
    //         ),
    //         Expanded(
    //           child: Align(
    //               alignment: AlignmentDirectional(0, 0),
    //               child: ElevatedButton(
    //                 onPressed: () {
    //                   Navigator.pushNamed(context, '/request_list');
    //                 },
    //                 child: const Text('Requests'),
    //               )),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
