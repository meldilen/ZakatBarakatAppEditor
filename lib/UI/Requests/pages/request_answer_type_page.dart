import 'package:editor/providers/request_provider.dart';
import 'package:flutter/material.dart';

class RequestAnswerTypePage extends StatefulWidget {
  RequestViewModel request;
  RequestAnswerTypePage({super.key, required this.request});

  @override
  State<RequestAnswerTypePage> createState() => _RequestAnswerTypePageState();
}

class _RequestAnswerTypePageState extends State<RequestAnswerTypePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 6, 169, 169),
        title:  Text(
          'Request: ${widget.request.text}', 
          style: TextStyle(
            fontSize: 22, 
            fontWeight: FontWeight.bold, 
            color: Colors.white)
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children:  [
            Expanded(
              child: Align(
                alignment: AlignmentDirectional(0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/request_answer_as_question', arguments: widget.request);
                  },
                  child: const Text('Answer as Q&A'),
                )
              ),
            ),
            Expanded(
              child: Align(
                alignment: AlignmentDirectional(0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/request_answer_as_article', arguments: widget.request);
                  },
                  child: const Text('Answer as article'),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}