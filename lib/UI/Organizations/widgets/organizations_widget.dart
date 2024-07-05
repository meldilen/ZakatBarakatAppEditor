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
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.organization.name),
            IconButton(onPressed: () {
              Navigator.pushNamed(context, '/organization_editing', arguments: widget.organization);
            }, icon: Icon(Icons.edit)),
            IconButton(onPressed: () {
              deleteOrganization(widget.organization.id, context);
            }, icon: Icon(Icons.delete)),
          ],
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: Color.fromARGB(255, 16, 31, 24),
        ),
      ],
    );
  }


  void deleteOrganization(String id, BuildContext context) async {
    try{
      await context.read<OrganisationListViewModel>().removeOrganization(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Organization deleted successfully!')),
      );
    }catch(e){
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete organization')),
      );
    }
  }
}