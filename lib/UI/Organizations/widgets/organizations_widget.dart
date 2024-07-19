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
                          color: context.watch<OrganisationListViewModel>().isSaved(widget.organization.id) ? Color.fromARGB(255, 143, 105, 105) : Color.fromARGB(255, 105, 143, 107),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          context.watch<OrganisationListViewModel>().isSaved(widget.organization.id) ? '✗ Not published' : '✓ Published',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.organization.name,
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Categories: ' +
                            widget.organization.categories.join(', '),
                        style: const TextStyle(
                            fontSize: 15, color: Colors.white70),
                      ),
                      Text(
                        'Countries: ' +
                            widget.organization.countries.join(', '),
                        style: const TextStyle(
                            fontSize: 15, color: Colors.white70),
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
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  'Are you sure you want to ${context.watch<OrganisationListViewModel>().isSaved(widget.organization.id) ? 'publish' : 'unpublish'} this Organization?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    publish_unpublishOrganization(widget.organization.id, context);
                                  },
                                  child: Text(context.watch<OrganisationListViewModel>().isSaved(widget.organization.id) ? 'Publish' : 'Unpublish',
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
                      tooltip: context.watch<OrganisationListViewModel>().isSaved(widget.organization.id) ? 'Publish' : 'Unpublish',
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
    if(context.read<OrganisationListViewModel>().isSaved(id)) {
      try {
        await context.read<OrganisationListViewModel>().removeSavedOrganization(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Organization deleted successfully!')),
        );
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete organization')),
        );
      }
    }else{
      try {
        await context.read<OrganisationListViewModel>().removePublishedOrganization(id);
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

  void publish_unpublishOrganization(String id, BuildContext context) async {

    if(context.read<OrganisationListViewModel>().isSaved(id)) {
      try {
        widget.organization.id = await context.read<OrganisationListViewModel>().publishOrganization(id);
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
      }
    }else{
      try {
        widget.organization.id = await context.read<OrganisationListViewModel>().unpublishOrganization(id);
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
      }
    }
  }

}
