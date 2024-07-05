import 'package:editor/providers/news_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';


import 'package:provider/provider.dart';

class CreateNewsArticlePage extends StatefulWidget {
  const CreateNewsArticlePage({super.key});

  @override
  _CreateNewsArticlePageState createState() => _CreateNewsArticlePageState();
}

class _CreateNewsArticlePageState extends State<CreateNewsArticlePage> {
  final _nameController = TextEditingController();
  final _tagControllers = <TextEditingController>[TextEditingController()];
  final _sourceLinkController = TextEditingController();
  final _imageLinkController = TextEditingController();
  final quill.QuillController _quillController = quill.QuillController.basic();//body

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

  void _createNewsArticle() async {
    final name = _nameController.text;
    final tags = _tagControllers.map((controller) => controller.text).toList();
    final body = _quillController.document.toPlainText();
    final image_link = _imageLinkController.text;
    final source_link = _sourceLinkController.text;

    try{
      await context.read<NewsListViewModel>().createNewsArticle(name, body, image_link, source_link, tags);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('News article created successfully!')),
      );
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create news article')),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create News Article'),
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
                onPressed: () => _createNewsArticle(),
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
