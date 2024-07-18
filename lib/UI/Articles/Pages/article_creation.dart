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

  final _formKey = GlobalKey<FormState>();

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
      backgroundColor: Color.fromARGB(255, 197, 198, 200),
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
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 50),
                Container(
                  constraints: BoxConstraints(maxWidth: 600),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: _titleController,
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter some text';
                      return null;
                    },
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                      hintText: "Enter article title here",
                      hintStyle: TextStyle(fontSize: 20),
                      prefixIcon: Icon(Icons.article),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 40.0),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                    minLines: 1,
                    maxLines: 5,
                  ),
                ),
                const SizedBox(height: 16),
                ..._tagControllers.map((controller) {
                  final index = _tagControllers.indexOf(controller);
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 560),
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                controller: controller,
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return 'Please enter some text';
                                  return null;
                                },
                                onChanged: (value) {},
                                decoration: const InputDecoration(
                                  hintText: "Enter article tag here",
                                  hintStyle: TextStyle(fontSize: 20),
                                  prefixIcon: Icon(Icons.queue),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 40.0),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                ),
                                minLines: 1,
                                maxLines: 5,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.white,
                            ),
                            onPressed: () => _removeTagField(index),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  );
                }),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: _addTagField,
                  child: const Text(
                    'Add Tag',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 15.0),
                    backgroundColor: Color.fromARGB(255, 29, 43, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(horizontal: 37),
                  child: QuillToolbar.simple(
                    configurations: QuillSimpleToolbarConfigurations(
                      controller: _quillController,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                  ),
                  child: QuillEditor.basic(
                    configurations: QuillEditorConfigurations(
                      controller: _quillController,
                      autoFocus: true,
                      minHeight: 400,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                      'Are you sure you want to save this article?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        _createArticle();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Save',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 39, 72, 45),
                                              fontSize: 15)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 135, 7, 7),
                                              fontSize: 15)),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 56.0, vertical: 15.0),
                          backgroundColor: Color.fromARGB(255, 29, 43, 54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 47.0, vertical: 15.0),
                          backgroundColor: Color.fromARGB(255, 29, 43, 54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
