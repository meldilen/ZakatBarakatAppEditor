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
    Provider.of<OrganisationListViewModel>(context, listen: false).fetchOrganizations();
  }

  Widget _buildUI(List<OrganizationViewModel> organizations) {
    if(organizations.isEmpty){
    return const Center(child: Text('No organizations found'));
  }else{
    return OrganizationList(organizations: organizations);
  }
  }


  Widget _buildButton(){
    return FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 169, 6, 74),
        onPressed: () {
          Navigator.pushNamed(context, '/organization_creation');
        },
        child: const Icon(Icons.add),
      );
  }


  AppBar _buildAppBar() {
    return AppBar(
        backgroundColor: Color.fromARGB(255, 169, 6, 74),
        title: const Text(
          'Organizations', 
          style: TextStyle(
            fontSize: 22, 
            fontWeight: FontWeight.bold, 
            color: Colors.white)
        ),
        centerTitle: true,
        elevation: 2,
      );
  }


  @override
  Widget build(BuildContext context) {
    var organizations = context.watch<OrganisationListViewModel>().organizations;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildUI(organizations),
      floatingActionButton: _buildButton(),
    );
  }
  
  
}
