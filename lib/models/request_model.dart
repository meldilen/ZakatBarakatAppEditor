class RequestModel{
  String id;
  String requestText;
  // bool isAnswered = false;

  RequestModel({required this.id, required this.requestText});

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'],
      requestText: json['requestText'],
    );
  }
}