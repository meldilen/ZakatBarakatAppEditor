import 'package:editor/providers/qna_provider.dart';
import 'package:editor/providers/request_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';

class AnswerAsQuestionPage extends StatefulWidget {
  final RequestViewModel request;

  AnswerAsQuestionPage({super.key, required this.request});

  @override
  _AnswerAsQuestionPageState createState() => _AnswerAsQuestionPageState();
}

class _AnswerAsQuestionPageState extends State<AnswerAsQuestionPage> {
  late final TextEditingController _questionTextController;
  final  _tagControllers = <TextEditingController>[TextEditingController()];
  final quill.QuillController _quillController = quill.QuillController.basic();

  @override
  void initState() {
    super.initState();
    _questionTextController = TextEditingController(text: widget.request.text);
  }

  @override
  void dispose() {
    _questionTextController.dispose();
    _tagControllers.forEach((controller) => controller.dispose());
    _quillController.dispose();
    super.dispose();
  }

  void _addTagField() {
    setState(() {
      _tagControllers.add(TextEditingController());
    });
  }

  void _removeTagField(int index) {
    setState(() {
      _tagControllers.removeAt(index).dispose();
    });
  }

  void _createQuestion() async {
    final questionText = _questionTextController.text;
    final tags = _tagControllers.map((controller) => controller.text).toList();
    final anwer = _quillController.document.toPlainText();
    try{
      await context.read<QuestionListViewModel>().createQuestion(questionText, anwer, tags);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question created successfully!')),
      ); 
      await _showDialog();
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create question')),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create answer as Question'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _questionTextController,
            decoration: const InputDecoration(
              labelText: 'Question Text',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ..._tagControllers.map((controller) {
            final index = _tagControllers.indexOf(controller);
            return Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Tag',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle),
                  onPressed: () => _removeTagField(index),
                ),
              ],
            );
          }),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _addTagField,
            child: const Text('Add Tag'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: QuillEditor.basic(
              configurations: QuillEditorConfigurations(
              controller: _quillController,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _createQuestion,
            child: const Text('Save'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/request_list')),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Close Request?'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('You answered the request.'),
              Text('Do you want to close the request?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Approve'),
            onPressed: () {
              closeRequest(widget.request.id, context);
            },
          ),
        ],
      );
    },
  );
}
  void closeRequest(String id, BuildContext context) async {
    try{
      await context.read<RequestListViewModel>().removeRequest(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request closed successfully!')),
      );
    }catch(e){
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to close question')),
      );
    }
  }
}