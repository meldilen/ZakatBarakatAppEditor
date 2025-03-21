class Question{
  String id;
  String question;
  String answer;
  List<String> tags;

  Question({required this.id, required this.question, required this.answer, required this.tags});


  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      tags: List<String>.from(json['tags']),
    );
  }
}