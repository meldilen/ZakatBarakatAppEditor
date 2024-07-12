import 'package:editor/providers/article_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';

import 'package:provider/provider.dart';

class CreateArticlePage extends StatefulWidget {
  const CreateArticlePage({super.key});

  @override
  _CreateArticlePageState createState() => _CreateArticlePageState();
}

class _CreateArticlePageState extends State<CreateArticlePage> {
  final _titleController = TextEditingController();
  final _tagControllers = <TextEditingController>[TextEditingController()];
  final quill.QuillController _quillController = quill.QuillController.basic();

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

  void _createArticle() async {
    final title = _titleController.text;
    final tags = _tagControllers.map((controller) => controller.text).toList();
    final text = _quillController.document.toPlainText();
    final ops = _quillController.document.toDelta().toJson();

    try {
      await context
          .read<ArticleListViewModel>()
          .createArticle(title, tags, text, ops);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article created successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create article')),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 88, 96, 85),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Color.fromARGB(255, 29, 43, 54),
              expandedHeight: 200,
              collapsedHeight: 85,
              floating: false,
              pinned: true,
              leading: IconButton(
                padding: EdgeInsets.only(left: 10, top: 20),
                icon: const Icon(Icons.arrow_back_ios_new_outlined,
                    color: Colors.white, size: 40),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Color.fromARGB(255, 29, 43, 54),
                ),
                titlePadding:
                    const EdgeInsetsDirectional.only(start: 0.0, bottom: 20.0),
                title: Text(
                  'CREATE ARTICLE',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: 'Times',
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
              ),
            ),
          ];
        },
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
              onPressed: () => _createArticle(),
              child: const Text('Save'),
            ),
            ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
          ],
        ),
      ),
    );
    //);
  }
}
