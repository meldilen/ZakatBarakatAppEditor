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
    if (requests.isEmpty) {
      return const Center(
          child: Text('No requests found',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)));
    } else {
      return RequestList(requests: requests);
    }
  }

  @override
  Widget build(BuildContext context) {
    var requests = context.watch<RequestListViewModel>().requests;

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
                  'REQUESTS',
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
        body: _buildUI(requests),
      ),
    );
  }
}
