import 'package:editor/providers/fund_provider.dart';
import 'package:editor/providers/qna_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';


import 'package:provider/provider.dart';

class CreateFundPage extends StatefulWidget {
  @override
  _CreateFundPageState createState() => _CreateFundPageState();
}

class _CreateFundPageState extends State<CreateFundPage> {
  final _nameController = TextEditingController();
  final _linkController = TextEditingController();
  final _logoLinkController = TextEditingController();
  final quill.QuillController _quillController = quill.QuillController.basic();

  @override
  void dispose() {
    _nameController.dispose();
    _linkController.dispose();
    _logoLinkController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  void _createFund() async {
    final name = _nameController.text;
    final link = _linkController.text;
    final logoLink = _logoLinkController.text;
    final description = _quillController.document.toPlainText();

    try{
      await context.read<FundListViewModel>().createFund(name, link, description, logoLink);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fund created successfully!')),
      );
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create fund')),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Fund'),
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
                onPressed: () => _createFund(),
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
