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
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/organization_editing',
            arguments: widget.organization);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(146, 29, 43, 54),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 30,
                    offset: Offset(10, 0),
                  ),
                ]),
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 20, bottom: 10, left: 40, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          //color: isPublished ? Color.fromARGB(255, 105, 143, 107) : Color.fromARGB(255, 143, 105, 105),
                          color: Color.fromARGB(255, 143, 105, 105),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "✗ Not published",
                          //isPublished ? '✓ Published' : '✗ Not published',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.organization.name,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Categories: ' +
                            widget.organization.categories.join(', '),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Countries: ' +
                            widget.organization.countries.join(', '),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: Text(
                      widget.organization.description.length > 200
                          ? '${widget.organization.description.substring(0, 200)}...'
                          : widget.organization.description,
                      style:
                          const TextStyle(fontSize: 18, color: Colors.white70)),
                ),
                const SizedBox(width: 10),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.remove_red_eye_rounded,
                          color: Colors.white),
                      tooltip: "View",
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  'Are you sure you want to publish this Organization?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    //publishArticle(widget.article.id, context);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Publish',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 15)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.public_outlined, color: Colors.white),
                      tooltip: "Publish",
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  'Are you sure you want to delete this Organization?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    deleteOrganization(
                                        widget.organization.id, context);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Delete',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 15)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.delete, color: Colors.white),
                      tooltip: "Delete",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
