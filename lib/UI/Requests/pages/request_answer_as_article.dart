import 'package:editor/providers/article_provider.dart';
import 'package:editor/providers/request_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';

class AnswerAsArticlePage extends StatefulWidget {
  final RequestViewModel request;

  AnswerAsArticlePage({super.key, required this.request});

  @override
  _AnswerAsArticlePageState createState() => _AnswerAsArticlePageState();
}

class _AnswerAsArticlePageState extends State<AnswerAsArticlePage> {
  late final TextEditingController _titleController;
  final _tagControllers = <TextEditingController>[TextEditingController()];
  final quill.QuillController _quillController = quill.QuillController.basic();

  final _formKey = GlobalKey<FormState>();

  bool _isPublished = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.request.text);
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

  void _createArticle() async {
    final title = _titleController.text;
    final tags = _tagControllers.map((controller) => controller.text).toList();
    final text = _quillController.document.toPlainText();
    final ops = _quillController.document.toDelta().toJson();

    if(_isPublished){
      try {
        await context
            .read<ArticleListViewModel>()
            .createPublishedArticle(title, tags, text, ops);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Article created successfully!')),
        );
        // widget.request.isAnswered = true;
        // context.read<RequestListViewModel>().markAsAnswered(widget.request.id);
        await _showDialog();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create article')),
        );
        print(e);
      }
    }else{
      try {
        await context
            .read<ArticleListViewModel>()
            .createSavedArticle(title, tags, text, ops);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Article created successfully!')),
        );
        // widget.request.isAnswered = true;
        // context.read<RequestListViewModel>().markAsAnswered(widget.request.id);
        await _showDialog();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create article')),
        );
        print(e);
      }
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
                  'REQUEST ANSWER AS ARTICLE',
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
                Container(
                  constraints: BoxConstraints(maxWidth: 230),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 29, 43, 54),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color.fromARGB(255, 96, 96, 96)),
                  ),
                  child: CheckboxListTile(
                    title: Text(
                      'Publish Article',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    value: _isPublished,
                    onChanged: (bool? value) {
                      setState(() {
                        _isPublished = value!;
                      });
                    },
                    checkColor: Color.fromARGB(255, 29, 43, 54),
                    activeColor: Colors.white,
                    overlayColor: WidgetStateProperty.all(Colors.white),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                const SizedBox(height: 20),
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
                        onPressed: () => Navigator.popUntil(
                            context, ModalRoute.withName('/request_list')),
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
                Navigator.popUntil(
                    context, ModalRoute.withName('/request_list'));
              },
            ),
          ],
        );
      },
    );
  }

  void closeRequest(String id, BuildContext context) async {
    try {
      await context.read<RequestListViewModel>().removeRequest(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request closed successfully!')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to close question')),
      );
    }
  }
}
