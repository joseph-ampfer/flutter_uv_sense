import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:simple_app/data/mock_data.dart';
import 'package:simple_app/providers/skin_type_provider.dart';
import 'app_test_wrapper.dart';
import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Quiz Flow Integration Tests', () {
    testWidgets('Complete quiz flow from UV Monitor to Results and back',
        (WidgetTester tester) async {
      // Arrange - Create app with mock services
      final skinTypeProvider = SkinTypeProvider();
      final mockBleService = MockBleService();

      await tester.pumpWidget(
        createTestApp(
          mockBleService: mockBleService,
          skinTypeProvider: skinTypeProvider,
        ),
      );
      await tester.pumpAndSettle();

      // Verify we're on UV Monitor screen
      expect(find.text('UV Monitor'), findsOneWidget);

      // Act - Navigate to quiz by tapping the quiz card
      await tester.tap(find.byKey(const Key('uv_quiz_button')));
      await tester.pumpAndSettle();

      // Assert - Verify Quiz screen opened
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byKey(const Key('quiz_close_button')), findsOneWidget);
      expect(find.byKey(const Key('quiz_question_counter')), findsOneWidget);

      // Verify first question is shown (intro question)
      expect(find.text(quizQuestions[0].question), findsOneWidget);
      expect(find.text('1/${quizQuestions.length}'), findsOneWidget);

      // Answer all questions
      for (int i = 0; i < quizQuestions.length; i++) {
        final question = quizQuestions[i];
        
        // Verify question counter
        expect(find.text('${i + 1}/${quizQuestions.length}'), findsOneWidget);

        // Select first option for each question
        final optionKey = Key('quiz_option_${question.id}_${question.options[0].value}');
        await tester.tap(find.byKey(optionKey));
        await tester.pump(const Duration(milliseconds: 100));

        // Wait for auto-advance animation
        if (i < quizQuestions.length - 1) {
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
        } else {
          // Last question navigates to results
          await tester.pumpAndSettle(const Duration(seconds: 1));
        }
      }

      // Assert - Verify Results screen is displayed
      expect(find.text('Your Results'), findsOneWidget);
      expect(find.byKey(const Key('results_close_button')), findsOneWidget);
      expect(find.byKey(const Key('results_skin_type_name')), findsOneWidget);
      expect(find.byKey(const Key('results_recommendations_list')), findsOneWidget);

      // Verify skin type is displayed (based on selecting first option for all questions)
      // With all 0 values from questions 1-10, average would be 0, so "Very Fair"
      expect(find.text('Very Fair'), findsOneWidget);

      // Act - Apply skin type to UV Monitor
      final initialSkinType = skinTypeProvider.selectedSkinType;
      await tester.tap(find.byKey(const Key('results_apply_button')));
      await tester.pump();

      // Assert - Verify SnackBar appears with confirmation
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.textContaining('skin type applied'), findsOneWidget);

      // Wait for snackbar and navigation (SnackBar takes 2s to dismiss by default)
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Assert - Verify navigated back to UV Monitor
      expect(find.text('UV Monitor'), findsOneWidget);

      // Verify skin type was updated in provider
      expect(skinTypeProvider.selectedSkinType.name, 'Very Fair');
      expect(skinTypeProvider.selectedSkinType.id, '1');
      expect(skinTypeProvider.selectedSkinType.name, isNot(initialSkinType.name));
    });

    testWidgets('Quiz can be retaken from Results screen',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Navigate to quiz
      await tester.tap(find.byKey(const Key('uv_quiz_button')));
      await tester.pumpAndSettle();

      // Complete quiz quickly by answering all questions
      for (int i = 0; i < quizQuestions.length; i++) {
        final question = quizQuestions[i];
        final optionKey = Key('quiz_option_${question.id}_${question.options[0].value}');
        await tester.tap(find.byKey(optionKey));
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle(const Duration(milliseconds: 500));
      }

      // Should be on Results screen
      expect(find.text('Your Results'), findsOneWidget);

      // Act - Tap "Retake Quiz"
      await tester.tap(find.byKey(const Key('results_retake_button')));
      await tester.pumpAndSettle();

      // Assert - Verify back on Quiz screen at first question
      expect(find.byKey(const Key('quiz_question_counter')), findsOneWidget);
      expect(find.text('1/${quizQuestions.length}'), findsOneWidget);
      expect(find.text(quizQuestions[0].question), findsOneWidget);
    });

    testWidgets('Quiz can be closed and returns to UV Monitor',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Navigate to quiz
      await tester.tap(find.byKey(const Key('uv_quiz_button')));
      await tester.pumpAndSettle();

      // Verify on quiz screen
      expect(find.byKey(const Key('quiz_close_button')), findsOneWidget);

      // Act - Close quiz
      await tester.tap(find.byKey(const Key('quiz_close_button')));
      await tester.pumpAndSettle();

      // Assert - Back on UV Monitor
      expect(find.text('UV Monitor'), findsOneWidget);
    });

    testWidgets('Results screen can be closed and returns to UV Monitor',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Navigate to quiz and complete it
      await tester.tap(find.byKey(const Key('uv_quiz_button')));
      await tester.pumpAndSettle();

      for (int i = 0; i < quizQuestions.length; i++) {
        final question = quizQuestions[i];
        final optionKey = Key('quiz_option_${question.id}_${question.options[0].value}');
        await tester.tap(find.byKey(optionKey));
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle(const Duration(milliseconds: 500));
      }

      // Should be on Results screen
      expect(find.text('Your Results'), findsOneWidget);

      // Act - Close results
      await tester.tap(find.byKey(const Key('results_close_button')));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Assert - Back on UV Monitor
      expect(find.text('UV Monitor'), findsOneWidget);
    });

    testWidgets('Different quiz responses lead to different skin types',
        (WidgetTester tester) async {
      // Arrange
      final skinTypeProvider = SkinTypeProvider();
      await tester.pumpWidget(
        createTestApp(skinTypeProvider: skinTypeProvider),
      );
      await tester.pumpAndSettle();

      // Navigate to quiz
      await tester.tap(find.byKey(const Key('uv_quiz_button')));
      await tester.pumpAndSettle();

      // Answer questions with highest values (4) for questions 1-10
      for (int i = 0; i < quizQuestions.length; i++) {
        final question = quizQuestions[i];
        
        if (i == 0 || i == 11) {
          // Intro and final questions - just select first option
          final optionKey = Key('quiz_option_${question.id}_${question.options[0].value}');
          await tester.tap(find.byKey(optionKey));
        } else {
          // Questions 1-10: select last option (highest value)
          final lastOption = question.options.last;
          final optionKey = Key('quiz_option_${question.id}_${lastOption.value}');
          await tester.tap(find.byKey(optionKey));
        }
        
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle(const Duration(milliseconds: 500));
      }

      // Assert - Should get "Dark" skin type with high values
      expect(find.text('Your Results'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);

      // Apply and verify
      await tester.tap(find.byKey(const Key('results_apply_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(skinTypeProvider.selectedSkinType.name, 'Dark');
    });
  });
}

