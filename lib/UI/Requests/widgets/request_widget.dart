import 'package:editor/providers/request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestWidget extends StatefulWidget {
  final RequestViewModel request;

  RequestWidget({super.key, required this.request});

  @override
  _RequestWidgetState createState() => _RequestWidgetState();
}

class _RequestWidgetState extends State<RequestWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/request_answer_as_article',
            arguments: widget.request);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(146, 29, 43, 54),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 30,
                    offset: Offset(10, 0),
                  ),
                ]),
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 20, bottom: 10, left: 40, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 16, vertical: 8),
                      //   decoration: BoxDecoration(
                      //     color: widget.request.isAnswered ? Color.fromARGB(255, 105, 143, 107) : Color.fromARGB(255, 143, 105, 105),
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: Text(
                      //     widget.request.isAnswered ? '✓ answered' : '✗ Not answered',
                      //     style: const TextStyle(
                      //         color: Colors.white, fontSize: 16),
                      //   ),
                      // ),
                      const SizedBox(height: 5),
                      Text(
                        widget.request.text,
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                Row(
                  children: [
                    // IconButton(
                    //   onPressed: () {
                    //     showDialog(
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         return AlertDialog(
                    //           title: Text(
                    //               'Are you sure you want to publish the answer to this request?'),
                    //           actions: [
                    //             TextButton(
                    //               onPressed: () {
                    //                 //publishArticle(widget.article.id, context);
                    //                 Navigator.of(context).pop();
                    //               },
                    //               child: const Text('Publish',
                    //                   style: TextStyle(
                    //                       color: Colors.red, fontSize: 15)),
                    //             ),
                    //             TextButton(
                    //               onPressed: () {
                    //                 Navigator.of(context).pop();
                    //               },
                    //               child: const Text('Cancel',
                    //                   style: TextStyle(
                    //                       color: Colors.grey, fontSize: 15)),
                    //             ),
                    //           ],
                    //         );
                    //       },
                    //     );
                    //   },
                    //   icon: Icon(Icons.public_outlined, color: Colors.white),
                    //   tooltip: "Publish",
                    // ),
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                    'Are you sure you want to close this request?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      closeRequest(widget.request.id, context);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Close',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 15)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 15)),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.close, color: Colors.white),
                        tooltip: "Close",
                        ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void closeRequest(String id, BuildContext context) async {
    try {
      await context.read<RequestListViewModel>().removeRequest(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request closed successfully!')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to close question')),
      );
    }
  }
}
