import 'package:editor/providers/qna_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';

class EditQuestionPage extends StatefulWidget {
  final QuestionViewModel question;

  EditQuestionPage({super.key, required this.question});

  @override
  _EditQuestionPageState createState() => _EditQuestionPageState();
}

class _EditQuestionPageState extends State<EditQuestionPage> {
  late final TextEditingController _questionTextController;
  late final List<TextEditingController> _tagControllers;
  late final quill.QuillController _quillController;

  @override
  void initState() {
    super.initState();
    _questionTextController = TextEditingController(text: widget.question.questionText);
    _tagControllers = widget.question.tags.map((tag) => TextEditingController(text: tag)).toList();

    final doc = quill.Document();
    doc.insert(0, widget.question.answerText);
    _quillController = quill.QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
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

  void _updateArticle() async {
    final questionText = _questionTextController.text;
    final tags = _tagControllers.map((controller) => controller.text).toList();
    final anwer = _quillController.document.toPlainText();
    try{
      await context.read<QuestionListViewModel>().updateQuestion(widget.question.id, questionText, anwer, tags);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question updated successfully!')),
      ); 
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update question')),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Question'),
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
            onPressed: _updateArticle,
            child: const Text('Save'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}