import 'package:flutter/material.dart';
import '../models/data_models.dart';
import '../data/mock_data.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final PageController _pageController = PageController();
  Map<int, int> responses = {};
  int currentPage = 0;

  void _handleOptionSelect(int questionId, int value) {
    setState(() {
      responses[questionId] = value;
    });

    // Auto-advance to next question after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (questionId == 11) {
        // Last question - navigate to results
        Navigator.pushNamed(
          context,
          '/results',
          arguments: responses,
        );
      } else {
        // Move to next question
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          key: const Key('quiz_close_button'),
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                '${currentPage + 1}/${quizQuestions.length}',
                key: const Key('quiz_question_counter'),
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            currentPage = page;
          });
        },
        itemCount: quizQuestions.length,
        itemBuilder: (context, index) {
          final question = quizQuestions[index];
          return _buildQuestionPage(question);
        },
      ),
    );
  }

  Widget _buildQuestionPage(QuizQuestion question) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Question Text
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          
          // Description (if present)
          if (question.description != null) ...[
            const SizedBox(height: 20),
            Text(
              question.description!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          
          const SizedBox(height: 40),
          
          // Options
          ...question.options.map((option) => _buildOptionButton(question, option)),
        ],
      ),
    );
  }

  Widget _buildOptionButton(QuizQuestion question, QuizOption option) {
    final isSelected = responses[question.id] == option.value;
    
    return Container(
      key: Key('quiz_option_${question.id}_${option.value}'),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleOptionSelect(question.id, option.value),
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.transparent,
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              option.text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
