import 'package:editor/providers/news_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';

class EditNewsArticlePage extends StatefulWidget {
  final NewsViewModel newsArticle;

  EditNewsArticlePage({super.key, required this.newsArticle});

  @override
  _EditNewsArticlePageState createState() => _EditNewsArticlePageState();
}

class _EditNewsArticlePageState extends State<EditNewsArticlePage> {
  late final TextEditingController _nameController;
  late final List<TextEditingController> _tagControllers;
  late final TextEditingController _sourceLinkController;
  late final TextEditingController _imageLinkController;
  late final quill.QuillController _quillController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.newsArticle.name);
    _sourceLinkController = TextEditingController(text: widget.newsArticle.sourceLink);
    _imageLinkController = TextEditingController(text: widget.newsArticle.imageLink);
    _tagControllers = widget.newsArticle.tags.map((tag) => TextEditingController(text: tag)).toList();

    final doc = quill.Document();
    doc.insert(0, widget.newsArticle.body);
    _quillController = quill.QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sourceLinkController.dispose();
    _imageLinkController.dispose();
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

  void _updateNewsArticle() async {
    final name = _nameController.text;
    final tags = _tagControllers.map((controller) => controller.text).toList();
    final body = _quillController.document.toPlainText();
    final image_link = _imageLinkController.text;
    final source_link = _sourceLinkController.text;

    try{
      await context.read<NewsListViewModel>().updateNewsArticle(widget.newsArticle.id ,name, body, image_link, source_link, tags);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('News article updated successfully!')),
      );
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update news article')),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update News Article'),
      ),
      body: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              TextField(
                controller: _imageLinkController,
                decoration: const InputDecoration(
                  labelText: 'Image Link',
                  border: OutlineInputBorder(),
                ),
              ),
              TextField(
                controller: _sourceLinkController,
                decoration: const InputDecoration(
                  labelText: 'Source Link',
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
                onPressed: () => _updateNewsArticle(),
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
