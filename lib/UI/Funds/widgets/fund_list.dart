import 'package:editor/UI/Funds/widgets/fund_widget.dart';
import 'package:editor/providers/fund_provider.dart';
import 'package:flutter/material.dart';

class FundList extends StatefulWidget {
  final List<FundViewModel> funds;

  FundList({super.key, required this.funds});

  @override
  _FundListState createState() => _FundListState();
}

class _FundListState extends State<FundList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea (
      top: true,
      child: ListView.builder(
        itemCount: widget.funds.length,
        itemBuilder: (context, index) {
          return FundWidget(fund: widget.funds[index]);
        },
    )
    );
  }

}