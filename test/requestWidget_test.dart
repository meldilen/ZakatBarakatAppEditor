import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:editor/providers/request_provider.dart';
import 'package:editor/UI/Requests/widgets/request_widget.dart';
import 'package:editor/models/request_model.dart';
import 'package:mockito/mockito.dart';

class MockRequestListViewModel extends Mock implements RequestListViewModel {
  @override
  Future<void> removeRequest(String id) => super.noSuchMethod(Invocation.method(#removeRequest, [id]), returnValue: Future<void>.value(), returnValueForMissingStub: Future<void>.value());
}

void main() {
  group('RequestWidget', () {
    testWidgets('renders request text and buttons', (WidgetTester tester) async {
      final request = RequestViewModel(request: RequestModel(id: '1', requestText: 'Test Request'));
      await tester.pumpWidget(
        ChangeNotifierProvider<RequestListViewModel>(
          create: (_) => RequestListViewModel(),
          child: MaterialApp(
            home: RequestWidget(request: request),
          ),
        ),
      );

      expect(find.text('Test Request'), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('navigates to request answering screen when edit button is tapped', (WidgetTester tester) async {
      final request = RequestViewModel(request: RequestModel(id: '1', requestText: 'Test Request'));

      await tester.pumpWidget(
        ChangeNotifierProvider<RequestListViewModel>(
          create: (_) => RequestListViewModel(),
          child: MaterialApp(
            onGenerateRoute: (settings) {
              if (settings.name == '/request_answering') {
                return MaterialPageRoute(
                  builder: (context) => Scaffold(
                    body: Text('Request Answering Screen'),
                  ),
                );
              }
              return null;
            },
            home: RequestWidget(request: request),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      expect(find.text('Request Answering Screen'), findsOneWidget);
    });

    testWidgets('calls closeRequest and shows success message when close button is tapped', (WidgetTester tester) async {
      final request = RequestViewModel(request: RequestModel(id: '1', requestText: 'Test Request'));
      final mockRequestListViewModel = MockRequestListViewModel();

      when(mockRequestListViewModel.removeRequest('1')).thenAnswer((_) async => Future.value());

      await tester.pumpWidget(
        ChangeNotifierProvider<RequestListViewModel>(
          create: (_) => mockRequestListViewModel,
          child: MaterialApp(
            home: Scaffold(
              body: RequestWidget(request: request),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump(); 
      await tester.pump();

      verify(mockRequestListViewModel.removeRequest('1')).called(1);
      expect(find.text('Request closed successfully!'), findsOneWidget);
    });

    testWidgets('shows failure message when close request fails', (WidgetTester tester) async {
      final request = RequestViewModel(request: RequestModel(id: '1', requestText: 'Test Request'));
      final mockRequestListViewModel = MockRequestListViewModel();

      when(mockRequestListViewModel.removeRequest('1')).thenThrow(Exception('Failed to close request'));

      await tester.pumpWidget(
        ChangeNotifierProvider<RequestListViewModel>(
          create: (_) => mockRequestListViewModel,
          child: MaterialApp(
            home: Scaffold(
              body: RequestWidget(request: request),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump(); 
      await tester.pump();

      verify(mockRequestListViewModel.removeRequest('1')).called(1);
      expect(find.text('Failed to close question'), findsOneWidget);
    });
  });
}


