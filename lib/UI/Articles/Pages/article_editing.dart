import 'package:editor/providers/article_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';

class EditArticlePage extends StatefulWidget {
  final ArticleViewModel article;

  EditArticlePage({super.key, required this.article});

  @override
  _EditArticlePageState createState() => _EditArticlePageState();
}

class _EditArticlePageState extends State<EditArticlePage> {
  late final TextEditingController _titleController;
  late final List<TextEditingController> _tagControllers;
  late final quill.QuillController _quillController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.article.title);
    _tagControllers = widget.article.tags.map((tag) => TextEditingController(text: tag)).toList();

    final jsonContent = widget.article.content.toJson();
    final ops = jsonContent['ops'] as List<dynamic>;

    _quillController = quill.QuillController(
      document: quill.Document.fromJson(ops),
      selection: const TextSelection.collapsed(offset: 0),
    );

    
  }

  @override
  void dispose() {
    _titleController.dispose();
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
    final title = _titleController.text;
    final tags = _tagControllers.map((controller) => controller.text).toList();
    final text = _quillController.document.toPlainText();
    final ops = _quillController.document.toDelta().toJson();
    try{
      await context.read<ArticleListViewModel>().updateArticle(widget.article.id, title, tags, text, ops);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article updated successfully!')),
      ); 
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update article')),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Article'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
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
          QuillToolbar.simple(
            configurations: QuillSimpleToolbarConfigurations(
            controller: _quillController,  
            ),
          ),
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