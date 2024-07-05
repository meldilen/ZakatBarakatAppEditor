class RequestModel{
  String id;
  String requestText;

  RequestModel({required this.id, required this.requestText});

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'],
      requestText: json['request_text'],
    );
  }
}