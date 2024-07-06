import 'package:editor/UI/Requests/pages/request_answer_as_question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:editor/providers/qna_provider.dart';
import 'package:editor/providers/request_provider.dart';
import 'package:editor/models/request_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class MockQuestionListViewModel extends Mock implements QuestionListViewModel {
  @override
  Future<void> createQuestion(String questionText, String answer, List<String> tags) => super.noSuchMethod(
      Invocation.method(#createQuestion, [questionText, answer, tags]), 
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
  );
}

class MockRequestListViewModel extends Mock implements RequestListViewModel {
  @override
  Future<void> removeRequest(String id) => super.noSuchMethod(
      Invocation.method(#removeRequest, [id]), 
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
  );
}

void main() {
  group('AnswerAsQuestionPage', () {
    testWidgets('renders initial UI elements', (WidgetTester tester) async {
      final request = RequestViewModel(request: RequestModel(id: '1', requestText: 'Test Request'));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<QuestionListViewModel>(
              create: (_) => MockQuestionListViewModel(),
            ),
            ChangeNotifierProvider<RequestListViewModel>(
              create: (_) => MockRequestListViewModel(),
            ),
          ],
          child: MaterialApp(
            home: AnswerAsQuestionPage(request: request),
          ),
        ),
      );

      expect(find.text('Create answer as Question'), findsOneWidget);
      expect(find.text('Question Text'), findsOneWidget);
      expect(find.text('Test Request'), findsOneWidget);
      expect(find.text('Add Tag'), findsOneWidget);
      expect(find.byType(quill.QuillEditor), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('adds and removes tag fields', (WidgetTester tester) async {
      final request = RequestViewModel(request: RequestModel(id: '1', requestText: 'Test Request'));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<QuestionListViewModel>(
              create: (_) => MockQuestionListViewModel(),
            ),
            ChangeNotifierProvider<RequestListViewModel>(
              create: (_) => MockRequestListViewModel(),
            ),
          ],
          child: MaterialApp(
            home: AnswerAsQuestionPage(request: request),
          ),
        ),
      );

      await tester.tap(find.text('Add Tag'));
      await tester.pump();
      expect(find.text('Tag'), findsNWidgets(2));

      await tester.tap(find.byIcon(Icons.remove_circle).first);
      await tester.pump();
      expect(find.text('Tag'), findsOneWidget);
    });

    testWidgets('creates a question and shows success message', (WidgetTester tester) async {
      final request = RequestViewModel(request: RequestModel(id: '1', requestText: 'Test Request'));
      final mockQuestionListViewModel = MockQuestionListViewModel();

      when(mockQuestionListViewModel.createQuestion('Test Question', 'Test Answer', ['tag1', 'tag2'])).thenAnswer((_) async => Future<void>.value());

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<QuestionListViewModel>(
              create: (_) => mockQuestionListViewModel,
            ),
            ChangeNotifierProvider<RequestListViewModel>(
              create: (_) => MockRequestListViewModel(),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: AnswerAsQuestionPage(request: request),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Save'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Question created successfully!'), findsOneWidget);
    });
  });
}
