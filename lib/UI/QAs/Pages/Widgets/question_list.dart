import 'package:editor/UI/QAs/Pages/Widgets/question_widget.dart';
import 'package:editor/providers/qna_provider.dart';
import 'package:flutter/material.dart';

class QuestionList extends StatefulWidget {
  final List<QuestionViewModel> questions;

  QuestionList({super.key, required this.questions});

  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea (
      top: true,
      child: ListView.builder(
        itemCount: widget.questions.length,
        itemBuilder: (context, index) {
          return QuestionWidget(question: widget.questions[index]);
        },
    )
    );
  }

}