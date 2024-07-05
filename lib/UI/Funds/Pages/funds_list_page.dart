import 'package:editor/UI/Funds/widgets/fund_list.dart';
import 'package:editor/providers/fund_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FundListPage extends StatefulWidget {
  const FundListPage({super.key});

  @override
  _FundListPageState createState() => _FundListPageState();
}

class _FundListPageState extends State<FundListPage> {


  @override
  void initState() {
    super.initState();
    Provider.of<FundListViewModel>(context, listen: false).fetchFunds();
  }

  Widget _buildUI(List<FundViewModel> funds) {
    if(funds.isEmpty){
    return const Center(child: Text('No funds found'));
  }else{
    return FundList(funds: funds);
  }
  }


  Widget _buildButton(){
    return FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 24, 37, 150),
        onPressed: () {
          Navigator.pushNamed(context, '/fund_creation');
        },
        child: const Icon(Icons.add),
      );
  }


  AppBar _buildAppBar() {
    return AppBar(
        backgroundColor: Color.fromARGB(255, 24, 37, 150),
        title: const Text(
          'Funds', 
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
    var funds = context.watch<FundListViewModel>().funds;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildUI(funds),
      floatingActionButton: _buildButton(),
    );
  }
  
  
}
