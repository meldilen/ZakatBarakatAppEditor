import 'package:editor/UI/Organizations/widgets/organizations_list.dart';
import 'package:editor/providers/organization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizationsListPage extends StatefulWidget {
  const OrganizationsListPage({super.key});

  @override
  _OrganizationsListPageState createState() => _OrganizationsListPageState();
}

class _OrganizationsListPageState extends State<OrganizationsListPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<OrganisationListViewModel>(context, listen: false)
        .fetchOrganizations();
  }

  Widget _buildUI(List<OrganizationViewModel> organizations) {
    if (organizations.isEmpty) {
      return const Center(
          child: Text('No organizations found',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)));
    } else {
      return OrganizationList(organizations: organizations);
    }
  }

  Widget _buildButton() {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, '/organization_creation');
      },
      icon: Icon(Icons.add_circle, color: Colors.white),
      label: Text(
        'CREATE ORGANIZATION',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        backgroundColor: Color.fromARGB(255, 29, 43, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var organizations =
        context.watch<OrganisationListViewModel>().organizations;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 88, 96, 85),
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
                  'ORGANIZATIONS',
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
        body: _buildUI(organizations),
      ),
      floatingActionButton: Positioned(
        bottom: 40,
        child: Container(
          alignment: Alignment.bottomCenter,
          child: _buildButton(),
        ),
      ),
    );
  }
}
