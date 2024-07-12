import 'package:editor/providers/fund_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FundWidget extends StatefulWidget {
  final FundViewModel fund;

  FundWidget({super.key, required this.fund});

  @override
  _FundWidgetState createState() => _FundWidgetState();
}

class _FundWidgetState extends State<FundWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 200,
        vertical: 10,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
            height: 170,
            color: Color.fromARGB(255, 209, 217, 219),
            child: Column(
              children: [
                Text(
                  widget.fund.name,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.fund.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/fund_editing',
                              arguments: widget.fund);
                        },
                        icon: Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                    'Are you sure you want to delete this charity fund?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      deleteFund(widget.fund.id, context);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Delete',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel',
                                        style: TextStyle(color: Colors.grey)),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.delete)),
                  ],
                )
              ],
            )),
      ),
    );
  }

  void deleteFund(String id, BuildContext context) async {
    try {
      await context.read<FundListViewModel>().removeFund(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fund deleted successfully!')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete fund')),
      );
    }
  }
}
