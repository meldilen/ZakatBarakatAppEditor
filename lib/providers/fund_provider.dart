import 'package:editor/models/fund_model.dart';
import 'package:editor/services/fundAPI.dart';
import 'package:flutter/material.dart';

class FundListViewModel extends ChangeNotifier{
  List<FundViewModel> funds = [];
  Future<void> fetchFunds() async {
    final funds = await FundAPI().getFunds();
    this.funds = funds.map((fund) => FundViewModel(fund: fund)).toList();
    notifyListeners();
  }

  Future<void> removeFund(String id) async {
    await FundAPI().deleteFund(id);
    funds.removeWhere((fund) => fund.id == id);
    notifyListeners();
  }

  Future<void> createFund(String name, String link, String description, String logoLink) async {
    Fund fund = await FundAPI().createFund(name, link, description, logoLink);
    funds.add(FundViewModel(fund: fund));
    notifyListeners();
  }

  Future<void> editFund(String id, String name, String link, String description, String logoLink) async {
    await FundAPI().editFund(id, name, link, description, logoLink);
    funds = funds.map((fund) => fund.id == id ? FundViewModel(fund: Fund(id: id, name: name, link: link, description: description, logoLink: logoLink)) : fund).toList();
    notifyListeners();
  }

}

class FundViewModel {
  Fund fund;
  
  FundViewModel({required this.fund});

  String get id => fund.id;
  String get name => fund.name;
  String get link => fund.link;
  String get description => fund.description;
  String get logoLink => fund.logoLink;
}