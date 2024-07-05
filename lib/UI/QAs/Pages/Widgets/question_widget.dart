import 'package:editor/providers/qna_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionWidget extends StatefulWidget {
  final QuestionViewModel question;

  QuestionWidget({super.key, required this.question});

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.question.questionText),
            IconButton(onPressed: () {
              Navigator.pushNamed(context, '/question_editing', arguments: widget.question);
            }, icon: Icon(Icons.edit)),
            IconButton(onPressed: () {
              deleteQuestion(widget.question.id, context);
            }, icon: Icon(Icons.delete)),
          ],
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: Color.fromARGB(255, 16, 31, 24),
        ),
      ],
    );
  }


  void deleteQuestion(String id, BuildContext context) async {
    try{
      await context.read<QuestionListViewModel>().removeQuestion(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question deleted successfully!')),
      );
    }catch(e){
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete question')),
      );
    }
  }
}