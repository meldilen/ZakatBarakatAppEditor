
import 'package:editor/providers/article_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class ArticleViewPage extends StatefulWidget {
  final ArticleViewModel article;
  const ArticleViewPage({super.key, required this.article});

  @override
  _ArticleViewPageState createState() => _ArticleViewPageState();
}


class _ArticleViewPageState extends State<ArticleViewPage> {
  late quill.QuillController _quillController;

  @override
  void initState() {
    super.initState();
    final jsonContent = widget.article.content.toJson();
    final ops = jsonContent['ops'] as List;
    _quillController = quill.QuillController(
      document: quill.Document.fromJson(ops),
      selection: const TextSelection.collapsed(offset: 0),
    );
    _quillController.readOnly = true;
  }


  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 70,
          elevation: 4,  
          shadowColor: Colors.grey.withOpacity(0.5),
          title: Text(
            widget.article.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: QuillEditor.basic(
                configurations: QuillEditorConfigurations(
              controller: _quillController,
              showCursor: false,
          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}