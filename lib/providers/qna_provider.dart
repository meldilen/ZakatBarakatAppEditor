import 'package:editor/models/questions_model.dart';
import 'package:editor/services/qnaAPI.dart';
import 'package:flutter/material.dart';

class QuestionListViewModel extends ChangeNotifier{

  late List<QuestionViewModel> questions = [];

  Future<void> fetchQuestions() async {
    final questions = await QnaAPI().getQuestions();
    this.questions = questions.map((question) => QuestionViewModel(question: question)).toList();
    notifyListeners();
  }


  Future<void> removeQuestion(String id) async {
    await QnaAPI().deleteQuestion(id);
    questions.removeWhere((question) => question.id == id);
    notifyListeners();
  }

  Future<void> createQuestion(String questionText, String answer, List<String> tags) async {
    Question question = await QnaAPI().createQuestion(questionText, answer, tags);
    questions.add(QuestionViewModel(question: question));
    notifyListeners();
  }

  Future<void> updateQuestion(String id, String questionText, String answer, List<String> tags) async {
    await QnaAPI().editQuestion(id, questionText, answer, tags);
    questions = questions.map((question) => question.id == id ? QuestionViewModel(question: Question(id: id, question: questionText, answer: answer, tags: tags)) : question).toList();
    notifyListeners();
  }
}

class QuestionViewModel {
  final Question question;

  QuestionViewModel({required this.question});

  String get id => question.id;
  String get questionText => question.question;
  String get answerText => question.answer;
  List<String> get tags => question.tags;
}
