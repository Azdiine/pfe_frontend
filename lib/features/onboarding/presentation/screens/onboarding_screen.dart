import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/onboarding_question.dart';
import '../widgets/question_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;
  final Map<int, List<String>> _answers = {};
  final Map<int, String> _textInputs = {};

  final List<OnboardingQuestion> _questions = [
    OnboardingQuestion(
      id: 1,
      question: 'Pour combien de personnes tu cuisines ?',
      subtitle: 'Très important pour les quantités.',
      options: ['Juste moi', '2 personnes', '3–4', '5+'],
      benefits: ['ajuster portions', 'liste de courses auto'],
    ),
    OnboardingQuestion(
      id: 2,
      question: 'Tu cuisines combien de fois par semaine ?',
      options: ['Jamais', '1–2 fois', '3–5 fois', 'Tous les jours'],
      benefits: ['fréquence recommandations', 'meal plan ou pas'],
    ),
    OnboardingQuestion(
      id: 3,
      question: 'Combien de temps max pour un repas ?',
      subtitle: 'Ultra important pour UX.',
      options: ['10 min (rapide)', '20 min', '30 min', 'Peu importe'],
      benefits: ['filtre recettes longues', 'recettes express'],
    ),
    OnboardingQuestion(
      id: 4,
      question: 'Ton niveau en cuisine ?',
      options: ['Débutant', 'Intermédiaire', 'Avancé'],
      benefits: [
        'difficulté recette',
        'étapes simplifiées',
        'tutoriels ou non',
      ],
    ),
    OnboardingQuestion(
      id: 5,
      question: 'Tes préférences alimentaires ?',
      options: [
        'Omnivore',
        'Végétarien',
        'Vegan',
        'Halal',
        'Sans porc',
        'Sans lactose',
        'Sans gluten',
        'Keto',
      ],
      multiSelect: true,
      benefits: ['filtre automatique recettes'],
    ),
    OnboardingQuestion(
      id: 6,
      question: 'Allergies ou aliments interdits ?',
      options: [
        'Arachides',
        'Fruits de mer',
        'Lait',
        'Œufs',
        'Autre',
        'Aucune',
      ],
      multiSelect: true,
      hasTextInput: true,
      benefits: ['sécurité + crédibilité médicale'],
    ),
    OnboardingQuestion(
      id: 7,
      question: 'Tu préfères quel type de plats ?',
      subtitle: 'Fun + utile pour personnalisation',
      options: [
        'Rapide / simple',
        'Healthy',
        'Protéiné (sport)',
        'Pas cher',
        'Gourmand / comfort food',
        'Cuisine du monde',
        'Traditionnel',
      ],
      multiSelect: true,
      benefits: ['personnalisation recommandations'],
    ),
    OnboardingQuestion(
      id: 8,
      question: 'Budget nourriture ?',
      options: ['Petit budget', 'Normal', 'Premium'],
      benefits: ['choix ingrédients (riz/poulet vs saumon/avocat)'],
    ),
    OnboardingQuestion(
      id: 9,
      question: 'Quels équipements tu as ?',
      subtitle: 'Spécifique et très intelligent',
      options: [
        'Four',
        'Micro-ondes',
        'Air fryer',
        'Mixeur',
        'Robot cuisine',
        'BBQ',
        'Plaques seulement',
      ],
      multiSelect: true,
      benefits: ['évite proposer des recettes impossibles'],
    ),
    OnboardingQuestion(
      id: 10,
      question: 'Tu fais les courses combien de fois ?',
      options: [
        'Tous les jours',
        '2–3 fois/semaine',
        '1 fois/semaine',
        'Rarement',
      ],
      benefits: ['meal plan semaine', 'gestion stock'],
    ),
    OnboardingQuestion(
      id: 11,
      question: 'Veux-tu scanner ton frigo maintenant ?',
      subtitle: 'Démarre direct la magie IA 🔥',
      options: ['Scanner avec caméra', 'Ajouter ingrédients', 'Plus tard'],
      benefits: ['démarre direct la magie IA'],
    ),
  ];

  void _handleOptionSelected(String option) {
    setState(() {
      final questionId = _questions[_currentIndex].id;
      final question = _questions[_currentIndex];

      if (!_answers.containsKey(questionId)) {
        _answers[questionId] = [];
      }

      if (question.multiSelect) {
        if (_answers[questionId]!.contains(option)) {
          _answers[questionId]!.remove(option);
        } else {
          _answers[questionId]!.add(option);
        }
      } else {
        _answers[questionId] = [option];
      }
    });
  }

  void _handleTextInputChanged(String value) {
    final questionId = _questions[_currentIndex].id;
    _textInputs[questionId] = value;
  }

  void _nextQuestion() {
    final questionId = _questions[_currentIndex].id;

    if (_answers[questionId] == null || _answers[questionId]!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner au moins une option'),
          backgroundColor: Color(0xFF111111),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      _completeOnboarding();
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _completeOnboarding() {
    // Save answers
    debugPrint('Onboarding completed!');
    debugPrint('Answers: $_answers');
    debugPrint('Text inputs: $_textInputs');

    // Navigate to home
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentIndex + 1) / _questions.length;
    final currentQuestion = _questions[_currentIndex];

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (_currentIndex == 0) {
          context.go('/');
        } else {
          _previousQuestion();
        }
      },
      child: Scaffold(
        body: Container(
          color: const Color(0xFFF9FAFB),
          child: SafeArea(
            child: Column(
              children: [
                // AppBar Professional
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      if (_currentIndex > 0)
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, size: 24),
                          color: const Color(0xFF111827),
                          onPressed: _previousQuestion,
                        )
                      else
                        const SizedBox(width: 48),

                      const SizedBox(width: 12),

                      // Barre de progression
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Question ${_currentIndex + 1}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${_currentIndex + 1}/${_questions.length}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: const Color(0xFFE5E7EB),
                                valueColor: const AlwaysStoppedAnimation(
                                  Color(0xFFFF6B35),
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      TextButton(
                        onPressed: () => context.go('/home'),
                        child: const Text(
                          'Passer',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Question Card
                Expanded(
                  child: QuestionCard(
                    key: ValueKey('question_${currentQuestion.id}'),
                    question: currentQuestion,
                    selectedOptions: _answers[currentQuestion.id] ?? [],
                    onOptionSelected: _handleOptionSelected,
                    textInput: _textInputs[currentQuestion.id] ?? '',
                    onTextInputChanged: _handleTextInputChanged,
                  ),
                ),

                // Next Button Professional
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        shadowColor: const Color(0xFFFF6B35).withOpacity(0.3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentIndex == _questions.length - 1
                                ? 'Terminer'
                                : 'Continuer',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
