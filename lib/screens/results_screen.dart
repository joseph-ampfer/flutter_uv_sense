import 'package:flutter/material.dart';
import '../models/data_models.dart';
import '../data/mock_data.dart';
import '../main.dart';

class ResultsScreen extends StatelessWidget {
  final Map<int, int> responses;

  const ResultsScreen({
    super.key,
    required this.responses,
  });

  SkinType _calculateSkinType() {
    // Calculate total score from questions 1-10 (excluding intro and final questions)
    int totalScore = 0;
    int questionCount = 0;

    for (int i = 1; i <= 10; i++) {
      if (responses.containsKey(i)) {
        totalScore += responses[i]!;
        questionCount++;
      }
    }

    if (questionCount == 0) return skinTypes[2]; // Default to medium

    // Calculate average score
    double averageScore = totalScore / questionCount;

    // Map average score to skin type
    if (averageScore <= 1.0) return skinTypes[0]; // Very Fair
    if (averageScore <= 2.0) return skinTypes[1]; // Fair
    if (averageScore <= 3.0) return skinTypes[2]; // Medium
    if (averageScore <= 3.5) return skinTypes[3]; // Olive
    if (averageScore <= 4.0) return skinTypes[4]; // Brown
    return skinTypes[5]; // Dark
  }

  List<String> _getPersonalizedRecommendations(SkinType skinType) {
    return [
      '${skinType.name} skin requires ${skinType.burnTime} minutes safe sun exposure',
      'Use sunscreen with SPF ${skinType.burnTime < 15 ? "50+" : skinType.burnTime < 25 ? "30+" : "15+"}',
      if (skinType.burnTime < 15) 'Seek shade during peak hours (10 AM - 4 PM)',
      if (skinType.burnTime < 20) 'Wear protective clothing and wide-brimmed hat',
      'Reapply sunscreen every 2 hours',
      'Wear UV-blocking sunglasses',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final determinedSkinType = _calculateSkinType();
    final recommendations = _getPersonalizedRecommendations(determinedSkinType);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Your Results',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the close button
                ],
              ),
              
              const SizedBox(height: 40),
              
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Skin type indicator
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: determinedSkinType.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: determinedSkinType.color.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Skin type name
                    Text(
                      determinedSkinType.name,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Skin type description
                    Text(
                      determinedSkinType.description,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Recommendations card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.shield_outlined,
                                color: Theme.of(context).colorScheme.primary,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Personalized Recommendations',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...recommendations.map((tip) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '• ',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontSize: 16,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    tip,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Action buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Apply skin type to UV Monitor settings
                        globalSelectedSkinType = determinedSkinType;
                        
                        // Show confirmation snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${determinedSkinType.name} skin type applied to UV Monitor'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        
                        // Navigate back to home (pop back to main navigation)
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Apply to UV Monitor',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/quiz'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Retake Quiz',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
