import 'package:editor/providers/organization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizationWidget extends StatefulWidget {
  final OrganizationViewModel organization;

  OrganizationWidget({super.key, required this.organization});

  @override
  _OrganizationWidgetState createState() => _OrganizationWidgetState();
}

class _OrganizationWidgetState extends State<OrganizationWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 200,
        vertical: 10,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
            height: 150,
            color: Color.fromARGB(255, 209, 217, 219),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    widget.organization.name,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Categories: ' + widget.organization.categories.join(', '),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Countries: ' + widget.organization.countries.join(', '),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/organization_editing',
                                arguments: widget.organization);
                          },
                          icon: Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                      'Are you sure you want to delete this organization?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        deleteOrganization(
                                            widget.organization.id, context);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Delete',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel',
                                          style: TextStyle(color: Colors.grey)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.delete)),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }

  void deleteOrganization(String id, BuildContext context) async {
    try {
      await context.read<OrganisationListViewModel>().removeOrganization(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Organization deleted successfully!')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete organization')),
      );
    }
  }
}
