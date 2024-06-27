import 'package:editor/providers/fund_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FundWidget extends StatefulWidget {
  final FundViewModel fund;

  FundWidget({required this.fund});

  @override
  _FundWidgetState createState() => _FundWidgetState();
}

class _FundWidgetState extends State<FundWidget> {

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
            Text(widget.fund.name),
            IconButton(onPressed: () {
              Navigator.pushNamed(context, '/fund_editing', arguments: widget.fund);
            }, icon: Icon(Icons.edit)),
            IconButton(onPressed: () {
              deleteFund(widget.fund.id, context);
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


  void deleteFund(String id, BuildContext context) async {
    try{
      await context.read<FundListViewModel>().removeFund(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fund deleted successfully!')),
      );
    }catch(e){
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete fund')),
      );
    }
  }
}