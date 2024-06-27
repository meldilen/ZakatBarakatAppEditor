import 'package:editor/providers/article_provider.dart';
import 'package:editor/providers/fund_provider.dart';
import 'package:editor/providers/qna_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';

class EditFundPage extends StatefulWidget {
  final FundViewModel fund;

  EditFundPage({required this.fund});

  @override
  _EditFundPageState createState() => _EditFundPageState();
}

class _EditFundPageState extends State<EditFundPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _linkController;
  late final TextEditingController _logoLinkController;
  late final quill.QuillController _quillController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.fund.name);
    _linkController = TextEditingController(text: widget.fund.link);
    _logoLinkController = TextEditingController(text: widget.fund.logoLink);

    final doc = quill.Document();
    doc.insert(0, widget.fund.description);
    _quillController = quill.QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _linkController.dispose();
    _logoLinkController.dispose();
    _quillController.dispose();
    super.dispose();
  }


  void _updateFund() async {
    final name = _nameController.text;
    final link = _linkController.text;
    final logoLink = _logoLinkController.text;
    final description = _quillController.document.toPlainText();

    try{
      await context.read<FundListViewModel>().editFund(widget.fund.id, name, link, description, logoLink);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fund updated successfully!')),
      ); 
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update fund')),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Fund'),
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
              const SizedBox(height: 16),
              TextField(
                controller: _linkController,
                decoration: const InputDecoration(
                  labelText: 'Link',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _logoLinkController,
                decoration: const InputDecoration(
                  labelText: 'Logo link',
                  border: OutlineInputBorder(),
                ),
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
                onPressed: () => _updateFund(),
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