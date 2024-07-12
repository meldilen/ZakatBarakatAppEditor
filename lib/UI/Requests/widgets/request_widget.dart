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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 200,
        vertical: 10,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
            height: 100,
            color: Color.fromARGB(255, 209, 217, 219),
            child: Column(
              children: [
                Text(
                  widget.request.text,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/request_answer_as_article', arguments: widget.request);
                        },
                        icon: Icon(Icons.add_comment_outlined)),
                    IconButton(
                        onPressed: () {
                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return AlertDialog(
                          //       title: Text(
                          //           'Are you sure you want to close this request?'),
                          //       actions: [
                          //         TextButton(
                          //           onPressed: () {
                          closeRequest(widget.request.id, context);
                          //     Navigator.of(context).pop();
                          //   },
                          //   child: const Text('Delete',
                          //       style: TextStyle(color: Colors.red)),
                          // ),
                          // TextButton(
                          //   onPressed: () {
                          //     Navigator.of(context).pop();
                          //   },
                          //   child: const Text('Cancel',
                          //       style: TextStyle(color: Colors.grey)),
                          // ),
                          //   ],
                          // );
                          //   },
                          // );
                        },
                        icon: Icon(Icons.close)),
                  ],
                )
              ],
            )),
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
