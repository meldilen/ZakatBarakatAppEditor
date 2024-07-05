import 'package:editor/providers/organization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';

class EditOrganizationPage extends StatefulWidget {
  final OrganizationViewModel organization;

  EditOrganizationPage({super.key, required this.organization});

  @override
  _EditOrganizationPageState createState() => _EditOrganizationPageState();
}

class _EditOrganizationPageState extends State<EditOrganizationPage> {
  late final TextEditingController _nameController;
  late final List<TextEditingController> _categoryControllers;
  late final List<TextEditingController> _countryControllers;
  late final TextEditingController _linkController;
  late final TextEditingController _logoLinkController;
  late final quill.QuillController _quillController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.organization.name);
    _linkController = TextEditingController(text: widget.organization.link);
    _logoLinkController = TextEditingController(text: widget.organization.logoLink);
    _categoryControllers = widget.organization.categories.map((category) => TextEditingController(text: category)).toList();
    _countryControllers = widget.organization.countries.map((country) => TextEditingController(text: country)).toList();

    final doc = quill.Document();
    doc.insert(0, widget.organization.description);
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
    _categoryControllers.forEach((controller) => controller.dispose());
    _countryControllers.forEach((controller) => controller.dispose());
    _quillController.dispose();
    super.dispose();
  }

  void _addCountryField() {
    setState(() {
      _countryControllers.add(TextEditingController());
    });
  }

  void _removeCountryField(int index) {
    setState(() {
      _countryControllers.removeAt(index).dispose();
    });
  }

  void _addCategoryField() {
    setState(() {
      _countryControllers.add(TextEditingController());
    });
  }

  void _removeCategoryField(int index) {
    setState(() {
      _countryControllers.removeAt(index).dispose();
    });
  }

  void _updateOrganization() async {
    final name = _nameController.text;
    final countries = _countryControllers.map((controller) => controller.text).toList();
    final categories = _categoryControllers.map((controller) => controller.text).toList();
    final description = _quillController.document.toPlainText();
    final logo_link = _logoLinkController.text;
    final link = _linkController.text;

    try{
      await context.read<OrganisationListViewModel>().updateOrganization(widget.organization.id, name, description, logo_link, link, categories, countries);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Organization updated successfully!')),
      );
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update organization')),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Organization'),
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
                controller: _logoLinkController,
                decoration: const InputDecoration(
                  labelText: 'Logo Link',
                  border: OutlineInputBorder(),
                ),
              ),
              TextField(
                controller: _linkController,
                decoration: const InputDecoration(
                  labelText: 'Source Link',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ..._categoryControllers.map((controller) {
                final index = _categoryControllers.indexOf(controller);
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          labelText: 'category',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle),
                      onPressed: () => _removeCategoryField(index),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addCategoryField,
                child: const Text('Add Category'),
              ),
              const SizedBox(height: 16),
              ..._countryControllers.map((controller) {
                final index = _countryControllers.indexOf(controller);
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          labelText: 'Country',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle),
                      onPressed: () => _removeCountryField(index),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addCountryField,
                child: const Text('Add Country'),
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
                onPressed: () => _updateOrganization(),
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

