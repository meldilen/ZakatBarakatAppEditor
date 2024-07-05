import 'package:editor/models/request_model.dart';
import 'package:editor/services/requestAPI.dart';
import 'package:flutter/material.dart';

class RequestListViewModel extends ChangeNotifier{

  late List<RequestViewModel> requests = [];

  Future<void> fetchRequests() async {
    final requests = await RequestAPI().getRequests();
    this.requests = requests.map((request) => RequestViewModel(request: request)).toList();
    notifyListeners();
  }


  Future<void> removeRequest(String id) async {
    await RequestAPI().deleteRequest(id);
    requests.removeWhere((request) => request.id == id);
    notifyListeners();
  }
}

class RequestViewModel {
  final RequestModel request;

  RequestViewModel({required this.request});

  String get id => request.id;
  String get text => request.requestText;
  
}
