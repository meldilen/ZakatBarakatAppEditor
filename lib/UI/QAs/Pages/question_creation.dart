import 'package:editor/providers/qna_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';


import 'package:provider/provider.dart';

class CreateQuestionPage extends StatefulWidget {
  @override
  _CreateQuestionPageState createState() => _CreateQuestionPageState();
}

class _CreateQuestionPageState extends State<CreateQuestionPage> {
  final _questionTextController = TextEditingController();
  final _tagControllers = <TextEditingController>[TextEditingController()];
  final quill.QuillController _quillController = quill.QuillController.basic();

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
    final question = _questionTextController.text;
    final tags = _tagControllers.map((controller) => controller.text).toList();
    final answer = _quillController.document.toPlainText();

    try{
      await context.read<QuestionListViewModel>().createQuestion(question, answer, tags);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question created successfully!')),
      );
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
        title: const Text('Create Question'),
      ),
      body: Column(
            children: [
              TextField(
                controller: _questionTextController,
                decoration: const InputDecoration(
                  labelText: 'Question text',
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
                onPressed: () => _createQuestion(),
                child: const Text('Save'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context), 
                child: const Text('Cancel')),
            ],
          ),
        );
  }
}
