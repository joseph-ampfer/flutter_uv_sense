import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_app/screens/quiz_screen.dart';
import 'package:simple_app/data/mock_data.dart';

void main() {
  group('QuizScreen Widget Tests', () {
    Widget createTestWidget() {
      return const MaterialApp(
        home: QuizScreen(),
      );
    }

    testWidgets('should render quiz screen with first question', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verify quiz screen loads
      expect(find.byType(QuizScreen), findsOneWidget);
      
      // Verify close button exists
      expect(find.byKey(const Key('quiz_close_button')), findsOneWidget);
      
      // Verify question counter shows first question
      expect(find.byKey(const Key('quiz_question_counter')), findsOneWidget);
      expect(find.text('1/${quizQuestions.length}'), findsOneWidget);
    });

    testWidgets('should display first question text and options', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final firstQuestion = quizQuestions[0];
      
      // Verify question text is displayed
      expect(find.text(firstQuestion.question), findsOneWidget);
      
      // Verify all options are displayed
      for (var option in firstQuestion.options) {
        expect(find.text(option.text), findsOneWidget);
      }
    });

    testWidgets('should display question description when present', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final firstQuestion = quizQuestions[0];
      
      if (firstQuestion.description != null) {
        expect(find.text(firstQuestion.description!), findsOneWidget);
      }
    });

    testWidgets('should select option when tapped', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final firstQuestion = quizQuestions[0];
      final firstOption = firstQuestion.options[0];
      
      // Find and tap the first option
      final optionKey = Key('quiz_option_${firstQuestion.id}_${firstOption.value}');
      await tester.tap(find.byKey(optionKey));
      await tester.pump();

      // Verify option is selected (container should have black background)
      final container = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byKey(optionKey),
          matching: find.byType(AnimatedContainer),
        ),
      );
      
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.black);
      
      // Complete the pending timer
      await tester.pumpAndSettle();
    });

    testWidgets('should advance to next question after selecting option', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Select first option on first question
      final firstQuestion = quizQuestions[0];
      final firstOption = firstQuestion.options[0];
      final optionKey = Key('quiz_option_${firstQuestion.id}_${firstOption.value}');
      
      await tester.tap(find.byKey(optionKey));
      await tester.pump();
      
      // Wait for auto-advance delay (300ms)
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Verify we moved to the second question
      expect(find.text('2/${quizQuestions.length}'), findsOneWidget);
      
      // Verify second question is displayed
      final secondQuestion = quizQuestions[1];
      expect(find.text(secondQuestion.question), findsOneWidget);
    });

    testWidgets('should update question counter as user navigates', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Start at question 1
      expect(find.text('1/${quizQuestions.length}'), findsOneWidget);

      // Navigate to question 2
      await tester.tap(find.byKey(Key('quiz_option_${quizQuestions[0].id}_${quizQuestions[0].options[0].value}')));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Verify counter updated
      expect(find.text('2/${quizQuestions.length}'), findsOneWidget);
    });

    testWidgets('should close quiz when close button is tapped', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tap close button
      await tester.tap(find.byKey(const Key('quiz_close_button')));
      await tester.pumpAndSettle();

      // Verify we navigated back (quiz screen should no longer be present)
      expect(find.byType(QuizScreen), findsNothing);
    });

    testWidgets('should show all options for questions with multiple choices', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Navigate to a question with multiple options (question 1)
      await tester.tap(find.byKey(Key('quiz_option_${quizQuestions[0].id}_${quizQuestions[0].options[0].value}')));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      final secondQuestion = quizQuestions[1];
      
      // Verify all options are visible
      expect(secondQuestion.options.length, greaterThan(1));
      for (var option in secondQuestion.options) {
        expect(find.text(option.text), findsOneWidget);
      }
    });

    testWidgets('should maintain selected state visually', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final firstQuestion = quizQuestions[0];
      final firstOption = firstQuestion.options[0];
      final optionKey = Key('quiz_option_${firstQuestion.id}_${firstOption.value}');
      
      // Before selection - should have transparent background
      var container = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byKey(optionKey),
          matching: find.byType(AnimatedContainer),
        ),
      );
      var decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.transparent);

      // Tap option
      await tester.tap(find.byKey(optionKey));
      await tester.pump();

      // After selection - should have black background
      container = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byKey(optionKey),
          matching: find.byType(AnimatedContainer),
        ),
      );
      decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.black);
      
      // Complete the pending timer
      await tester.pumpAndSettle();
    });

    testWidgets('should handle rapid option selections', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final firstQuestion = quizQuestions[0];
      final firstOption = firstQuestion.options[0];
      final optionKey = Key('quiz_option_${firstQuestion.id}_${firstOption.value}');
      
      // Tap option multiple times rapidly
      await tester.tap(find.byKey(optionKey));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byKey(optionKey));
      await tester.pump(const Duration(milliseconds: 50));
      
      // Should not crash and should eventually settle
      await tester.pumpAndSettle();
      
      expect(find.byType(QuizScreen), findsOneWidget);
    });

    testWidgets('should navigate through multiple questions sequentially', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Navigate through first 3 questions
      for (int i = 0; i < 3; i++) {
        expect(find.text('${i + 1}/${quizQuestions.length}'), findsOneWidget);
        
        final question = quizQuestions[i];
        final option = question.options[0];
        final optionKey = Key('quiz_option_${question.id}_${option.value}');
        
        await tester.tap(find.byKey(optionKey));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pumpAndSettle();
      }

      // Should be on question 4 now
      expect(find.text('4/${quizQuestions.length}'), findsOneWidget);
    });

    testWidgets('should have proper layout structure', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verify Scaffold structure
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('should display options with proper styling', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final firstQuestion = quizQuestions[0];
      final firstOption = firstQuestion.options[0];
      
      // Verify option text is displayed
      expect(find.text(firstOption.text), findsOneWidget);
      
      // Verify InkWell for tap feedback exists
      final optionKey = Key('quiz_option_${firstQuestion.id}_${firstOption.value}');
      expect(
        find.descendant(
          of: find.byKey(optionKey),
          matching: find.byType(InkWell),
        ),
        findsOneWidget,
      );
    });
  });
}

