import 'package:flutter/material.dart';
import '../models/data_models.dart';

// Mock Data
final List<SkinType> skinTypes = [
  SkinType(
    id: '1',
    name: 'Very Fair',
    description: 'Always burns, never tans',
    color: const Color(0xFFFDDBD4),
    burnTime: 5,
  ),
  SkinType(
    id: '2',
    name: 'Fair',
    description: 'Usually burns, tans minimally',
    color: const Color(0xFFF3C4A2),
    burnTime: 10,
  ),
  SkinType(
    id: '3',
    name: 'Medium',
    description: 'Sometimes burns, tans gradually',
    color: const Color(0xFFE8B982),
    burnTime: 15,
  ),
  SkinType(
    id: '4',
    name: 'Olive',
    description: 'Burns minimally, tans well',
    color: const Color(0xFFD4A574),
    burnTime: 20,
  ),
  SkinType(
    id: '5',
    name: 'Brown',
    description: 'Rarely burns, tans darkly',
    color: const Color(0xFFB08B5B),
    burnTime: 25,
  ),
  SkinType(
    id: '6',
    name: 'Dark',
    description: 'Never burns, always tans',
    color: const Color(0xFF8B5A2B),
    burnTime: 30,
  ),
];

final List<UVRecommendation> uvRecommendations = [
  UVRecommendation(
    uvIndex: 11,
    safeExposure: 5,
    protection: [
      'Avoid sun exposure between 10 AM and 4 PM',
      'Seek shade whenever possible',
      'Use SPF 50+ sunscreen',
      'Wear protective clothing and wide-brimmed hat',
      'Wear UV-blocking sunglasses'
    ],
  ),
  UVRecommendation(
    uvIndex: 8,
    safeExposure: 10,
    protection: [
      'Minimize sun exposure between 10 AM and 4 PM',
      'Seek shade during midday hours',
      'Use SPF 30+ sunscreen',
      'Wear protective clothing and hat',
      'Wear sunglasses'
    ],
  ),
  UVRecommendation(
    uvIndex: 6,
    safeExposure: 15,
    protection: [
      'Seek shade during midday hours',
      'Use SPF 30 sunscreen',
      'Wear hat and sunglasses',
      'Cover up with clothing'
    ],
  ),
  UVRecommendation(
    uvIndex: 3,
    safeExposure: 30,
    protection: [
      'Use SPF 15+ sunscreen',
      'Wear sunglasses on bright days',
      'Be cautious around reflective surfaces'
    ],
  ),
  UVRecommendation(
    uvIndex: 0,
    safeExposure: 60,
    protection: [
      'Minimal protection needed',
      'Sunglasses recommended for snow/water activities'
    ],
  ),
];

final List<QuizQuestion> quizQuestions = [
  QuizQuestion(
    id: 0,
    question: "Which skin type are you?",
    description: "You are on your way to get personalized recommendations based on your skin type and UV index so you can have the best skin ever.",
    options: [
      QuizOption(text: "Find my skin type", value: 0),
    ],
  ),
  QuizQuestion(
    id: 1,
    question: "What color are your eyes?",
    options: [
      QuizOption(text: "Light blue, gray or green", value: 0),
      QuizOption(text: "Blue, gray, or green", value: 1),
      QuizOption(text: "Blue", value: 2),
      QuizOption(text: "Dark Brown", value: 3),
      QuizOption(text: "Brownish Black", value: 4),
    ],
  ),
  QuizQuestion(
    id: 2,
    question: "What is the natural color of your hair?",
    options: [
      QuizOption(text: "Sandy red", value: 0),
      QuizOption(text: "Blonde", value: 1),
      QuizOption(text: "Chestnut/Dark Blonde", value: 2),
      QuizOption(text: "Dark brown", value: 3),
      QuizOption(text: "Black", value: 4),
    ],
  ),
  QuizQuestion(
    id: 3,
    question: "What color is your skin in places where it is not exposed to the sun?",
    options: [
      QuizOption(text: "Reddish", value: 0),
      QuizOption(text: "Very Pale", value: 1),
      QuizOption(text: "Pale with a beige tint", value: 2),
      QuizOption(text: "Light brown", value: 3),
      QuizOption(text: "Dark brown", value: 4),
    ],
  ),
  QuizQuestion(
    id: 4,
    question: "Do you have freckles on unexposed areas? (e.g. covered)",
    options: [
      QuizOption(text: "Many", value: 0),
      QuizOption(text: "Several", value: 1),
      QuizOption(text: "Few", value: 2),
      QuizOption(text: "Incidental", value: 3),
      QuizOption(text: "None", value: 4),
    ],
  ),
  QuizQuestion(
    id: 5,
    question: "What happens when you stay too long in the sun?",
    options: [
      QuizOption(text: "Painful redness, blistering, peeling", value: 0),
      QuizOption(text: "Blistering followed by peeling", value: 1),
      QuizOption(text: "Burns sometimes followed by peeling", value: 2),
      QuizOption(text: "Rare burns", value: 3),
      QuizOption(text: "Never had burns", value: 4),
    ],
  ),
  QuizQuestion(
    id: 6,
    question: "To what degree do you turn brown?",
    options: [
      QuizOption(text: "Hardly or not at all", value: 0),
      QuizOption(text: "Light color tan", value: 1),
      QuizOption(text: "Reasonable tan", value: 2),
      QuizOption(text: "Tan very easily", value: 3),
      QuizOption(text: "Turn dark brown quickly", value: 4),
    ],
  ),
  QuizQuestion(
    id: 7,
    question: "Do you turn brown after several hours of sun exposure?",
    options: [
      QuizOption(text: "Never", value: 0),
      QuizOption(text: "Seldom", value: 1),
      QuizOption(text: "Sometimes", value: 2),
      QuizOption(text: "Often", value: 3),
      QuizOption(text: "Always", value: 4),
    ],
  ),
  QuizQuestion(
    id: 8,
    question: "How does your face react to the sun?",
    options: [
      QuizOption(text: "Very sensitive", value: 0),
      QuizOption(text: "Sensitive", value: 1),
      QuizOption(text: "Normal", value: 2),
      QuizOption(text: "Very resistant", value: 3),
      QuizOption(text: "Never had a problem", value: 4),
    ],
  ),
  QuizQuestion(
    id: 9,
    question: "When did you last expose your body to the sun?",
    options: [
      QuizOption(text: "More than 3 months ago", value: 1),
      QuizOption(text: "2-3 months ago", value: 2),
      QuizOption(text: "1-2 months ago", value: 3),
      QuizOption(text: "Less than a month ago", value: 4),
      QuizOption(text: "Less than 2 weeks ago", value: 5),
    ],
  ),
  QuizQuestion(
    id: 10,
    question: "Do you expose your face to the sun?",
    options: [
      QuizOption(text: "Never", value: 1),
      QuizOption(text: "Hardly ever", value: 2),
      QuizOption(text: "Sometimes", value: 3),
      QuizOption(text: "Often", value: 4),
      QuizOption(text: "Always", value: 5),
    ],
  ),
  QuizQuestion(
    id: 11,
    question: "Ready for your results?",
    options: [
      QuizOption(text: "Absolutely!", value: 0),
    ],
  ),
];