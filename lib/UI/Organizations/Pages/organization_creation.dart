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
  final quill.QuillController _quillController = quill.QuillController.basic();

  List<String> selectedCategories = [];
  List<String> selectedCountries = [];

  final _formKey = GlobalKey<FormState>();

  bool _isPublished = false;

  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _linkController.dispose();
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
    final link = _linkController.text;
    final categories =
        _categoryControllers.map((controller) => controller.text).toList();
    final countries =
        _countryControllers.map((controller) => controller.text).toList();

    if(_isPublished){
      try {
        await context.read<OrganisationListViewModel>().createPublishedOrganization(
            name,
            description,
            link,
            categories,
            countries,
          );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Organization created successfully!')),
        );
      } catch (e) {
        String errorMessage = 'Failed to create organization';
        if (e is Exception && e.toString().contains('The site on the link is not accessible')) {
          errorMessage = 'Failed to create organization: the site on the link is not accessible';
        }else if(e is Exception && e.toString().contains('The provided link is invalid.')){
          errorMessage = 'Failed to create organization: the provided link is invalid.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
        );
        print(e);
      }
    }else{
      try {
        await context.read<OrganisationListViewModel>().createSavedOrganization(
            name,
            description,
            link,
            categories,
            countries,
          );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Organization created successfully!')),
        );
      } catch (e) {
        String errorMessage = 'Failed to create organization';
        if (e is Exception && e.toString().contains('The site on the link is not accessible')) {
          errorMessage = 'Failed to create organization: the site on the link is not accessible';
        }else if(e is Exception && e.toString().contains('The provided link is invalid.')){
          errorMessage = 'Failed to create organization: the provided link is invalid.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
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
                  'CREATE ORGANIZATION',
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
                    controller: _nameController,
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter some text';
                      return null;
                    },
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                      hintText: "Enter organization name here",
                      hintStyle: TextStyle(fontSize: 20),
                      prefixIcon: Icon(Icons.business_outlined),
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
                Container(
                  constraints: BoxConstraints(maxWidth: 600),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: _linkController,
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter some text';
                      return null;
                    },
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                      hintText: "Enter source link here",
                      hintStyle: TextStyle(fontSize: 20),
                      prefixIcon: Icon(Icons.link_outlined),
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
                ..._categoryControllers.map((controller) {
                  final index = _categoryControllers.indexOf(controller);
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                                constraints: BoxConstraints(maxWidth: 560),
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: DropdownTextField(
                                  items: selectedCategories,
                                  controller: controller,
                                  itemName: 'category',
                                )),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.white,
                            ),
                            onPressed: () => _removeCategoryField(index),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  );
                }),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: _addCategoryField,
                  child: const Text(
                    'Add Category',
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
                const SizedBox(height: 16),
                ..._countryControllers.map((controller) {
                  final index = _countryControllers.indexOf(controller);
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                                constraints: BoxConstraints(maxWidth: 560),
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: DropdownTextField(
                                  items: selectedCountries,
                                  controller: controller,
                                  itemName: 'country',
                                )),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.white,
                            ),
                            onPressed: () => _removeCountryField(index),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  );
                }),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: _addCountryField,
                  child: const Text(
                    'Add Country',
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
                  constraints: BoxConstraints(maxWidth: 280),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 29, 43, 54),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color.fromARGB(255, 96, 96, 96)),
                  ),
                  child: CheckboxListTile(
                    title: Text(
                      'Publish Organization',
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
                                      'Are you sure you want to create organisation?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        _createOrganization();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Create',
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
                          'Create',
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
