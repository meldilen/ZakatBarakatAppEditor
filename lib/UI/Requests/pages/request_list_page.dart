import 'package:editor/UI/Requests/widgets/request_list.dart';
import 'package:editor/providers/request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestListPage extends StatefulWidget {
  const RequestListPage({super.key});

  @override
  _RequestListPageState createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {


  @override
  void initState() {
    super.initState();
    Provider.of<RequestListViewModel>(context, listen: false).fetchRequests();
  }

  Widget _buildUI(List<RequestViewModel> requests) {
    if(requests.isEmpty){
    return const Center(child: Text('No requests found'));
  }else{
    return RequestList(requests: requests);
  }
  }




  AppBar _buildAppBar() {
    return AppBar(
        backgroundColor: Color.fromARGB(255, 6, 169, 169),
        title: const Text(
          'Requests', 
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
    var requests = context.watch<RequestListViewModel>().requests;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildUI(requests),
    );
  }
  
  
}
