import 'package:editor/UI/Organizations/widgets/custom_text_field.dart';
import 'package:editor/providers/organization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';


import 'package:provider/provider.dart';

class CreateOrganizationPage extends StatefulWidget {
  const CreateOrganizationPage({super.key});

  @override
  _CreateOrganizationPageState createState() => _CreateOrganizationPageState();
}

class _CreateOrganizationPageState extends State<CreateOrganizationPage> {
  final _nameController = TextEditingController();
  final _categoryControllers = <TextEditingController>[TextEditingController()];
  final _countryControllers = <TextEditingController>[TextEditingController()];
  final _linkController = TextEditingController();
  final _logoLinkController = TextEditingController();
  final quill.QuillController _quillController = quill.QuillController.basic();

  List<String> selectedCategories = [];
  List<String> selectedCountries = [];

  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _linkController.dispose();
  //   _logoLinkController.dispose();
  //   _categoryControllers.forEach((controller) => controller.dispose());
  //   _countryControllers.forEach((controller) => controller.dispose());
  //   _quillController.dispose();
  //   super.dispose();
  // }


  @override
  void initState() {
    super.initState();
    selectedCategories = context.read<OrganisationListViewModel>().categories;
    selectedCountries = context.read<OrganisationListViewModel>().countries;
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
      _categoryControllers.add(TextEditingController());
    });
  }

  void _removeCategoryField(int index) {
    setState(() {
      _categoryControllers.removeAt(index).dispose();
    });
  }

  void _createOrganization() async {
  final name = _nameController.text;
  final description = _quillController.document.toPlainText();
  final logo_link = _logoLinkController.text;
  final link = _linkController.text;
  final categories = _categoryControllers.map((controller) => controller.text).toList();
  final countries = _countryControllers.map((controller) => controller.text).toList();
  
  try {
    await context.read<OrganisationListViewModel>().createOrganization(
      name,
      description,
      logo_link,
      link,
      categories,
      countries,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Organization created successfully!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to create organization')),
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
                      child: DropdownTextField(
                        items: selectedCategories,
                        controller: controller,
                        labelText: 'Category',
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
                      child: DropdownTextField(
                        items: selectedCountries,
                        controller: controller,
                        labelText: 'Country',
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
                onPressed: () => _createOrganization(),
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


