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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 200,
        vertical: 10,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
            height: 200,
            color: Color.fromARGB(255, 209, 217, 219),
            child: Column(
              children: [
                Text(
                  widget.question.questionText,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '#' + widget.question.tags.join(' #'),
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.question.answerText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/question_editing',
                              arguments: widget.question);
                        },
                        icon: Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                    'Are you sure you want to delete this question?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      deleteQuestion(
                                          widget.question.id, context);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Delete',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel',
                                        style: TextStyle(color: Colors.grey)),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.delete)),
                  ],
                )
              ],
            )),
      ),
    );
  }

  void deleteQuestion(String id, BuildContext context) async {
    try {
      await context.read<QuestionListViewModel>().removeQuestion(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question deleted successfully!')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete question')),
      );
    }
  }
}
