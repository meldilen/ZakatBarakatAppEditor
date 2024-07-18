import 'package:editor/UI/Organizations/widgets/organizations_widget.dart';
import 'package:editor/providers/organization_provider.dart';
import 'package:flutter/material.dart';

class OrganizationList extends StatefulWidget {
  final List<OrganizationViewModel> organizations;

  OrganizationList({super.key, required this.organizations});

  @override
  _OrganizationListState createState() => _OrganizationListState();
}

class _OrganizationListState extends State<OrganizationList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
          padding: EdgeInsets.only(top: 30, bottom: 80),
          child: ListView.builder(
            itemCount: widget.organizations.length,
            itemBuilder: (context, index) {
              return OrganizationWidget(
                  organization: widget.organizations[index]);
            },
          )),
    );
  }
}
