import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/onboarding_question.dart';
import '../widgets/question_card.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/providers/locale_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentIndex = 0;
  final Map<int, List<String>> _answers = {};
  final Map<int, String> _textInputs = {};

  List<OnboardingQuestion> _buildQuestions() {
    return [
      OnboardingQuestion(
        id: 1,
        questionKey: 'onbQ1',
        subtitleKey: 'onbQ1Sub',
        optionKeys: ['onbQ1Opt1', 'onbQ1Opt2', 'onbQ1Opt3', 'onbQ1Opt4'],
        benefitKeys: ['onbQ1Ben1', 'onbQ1Ben2'],
      ),
      OnboardingQuestion(
        id: 2,
        questionKey: 'onbQ2',
        optionKeys: ['onbQ2Opt1', 'onbQ2Opt2', 'onbQ2Opt3', 'onbQ2Opt4'],
        benefitKeys: ['onbQ2Ben1', 'onbQ2Ben2'],
      ),
      OnboardingQuestion(
        id: 3,
        questionKey: 'onbQ3',
        subtitleKey: 'onbQ3Sub',
        optionKeys: ['onbQ3Opt1', 'onbQ3Opt2', 'onbQ3Opt3', 'onbQ3Opt4'],
        benefitKeys: ['onbQ3Ben1', 'onbQ3Ben2'],
      ),
      OnboardingQuestion(
        id: 4,
        questionKey: 'onbQ4',
        optionKeys: ['onbQ4Opt1', 'onbQ4Opt2', 'onbQ4Opt3'],
        benefitKeys: ['onbQ4Ben1', 'onbQ4Ben2', 'onbQ4Ben3'],
      ),
      OnboardingQuestion(
        id: 5,
        questionKey: 'onbQ5',
        optionKeys: [
          'onbQ5Opt1',
          'onbQ5Opt2',
          'onbQ5Opt3',
          'onbQ5Opt4',
          'onbQ5Opt5',
          'onbQ5Opt6',
          'onbQ5Opt7',
          'onbQ5Opt8',
        ],
        benefitKeys: ['onbQ5Ben1'],
        multiSelect: true,
      ),
      OnboardingQuestion(
        id: 6,
        questionKey: 'onbQ6',
        optionKeys: [
          'onbQ6Opt1',
          'onbQ6Opt2',
          'onbQ6Opt3',
          'onbQ6Opt4',
          'onbQ6Opt5',
          'onbQ6Opt6',
        ],
        benefitKeys: ['onbQ6Ben1'],
        multiSelect: true,
        hasTextInput: true,
      ),
      OnboardingQuestion(
        id: 7,
        questionKey: 'onbQ7',
        subtitleKey: 'onbQ7Sub',
        optionKeys: [
          'onbQ7Opt1',
          'onbQ7Opt2',
          'onbQ7Opt3',
          'onbQ7Opt4',
          'onbQ7Opt5',
          'onbQ7Opt6',
          'onbQ7Opt7',
        ],
        benefitKeys: ['onbQ7Ben1'],
        multiSelect: true,
      ),
      OnboardingQuestion(
        id: 8,
        questionKey: 'onbQ8',
        optionKeys: ['onbQ8Opt1', 'onbQ8Opt2', 'onbQ8Opt3'],
        benefitKeys: ['onbQ8Ben1'],
      ),
      OnboardingQuestion(
        id: 9,
        questionKey: 'onbQ9',
        subtitleKey: 'onbQ9Sub',
        optionKeys: [
          'onbQ9Opt1',
          'onbQ9Opt2',
          'onbQ9Opt3',
          'onbQ9Opt4',
          'onbQ9Opt5',
          'onbQ9Opt6',
          'onbQ9Opt7',
        ],
        benefitKeys: ['onbQ9Ben1'],
        multiSelect: true,
      ),
      OnboardingQuestion(
        id: 10,
        questionKey: 'onbQ10',
        optionKeys: ['onbQ10Opt1', 'onbQ10Opt2', 'onbQ10Opt3', 'onbQ10Opt4'],
        benefitKeys: ['onbQ10Ben1', 'onbQ10Ben2'],
      ),
      OnboardingQuestion(
        id: 11,
        questionKey: 'onbQ11',
        subtitleKey: 'onbQ11Sub',
        optionKeys: ['onbQ11Opt1', 'onbQ11Opt2', 'onbQ11Opt3'],
        benefitKeys: ['onbQ11Ben1'],
      ),
    ];
  }

  void _handleOptionSelected(String option) {
    setState(() {
      final questions = _buildQuestions();
      final questionId = questions[_currentIndex].id;
      final question = questions[_currentIndex];

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
    final questions = _buildQuestions();
    final questionId = questions[_currentIndex].id;
    _textInputs[questionId] = value;
  }

  void _nextQuestion() {
    final l10n = AppLocalizations.of(context);
    final questions = _buildQuestions();
    final questionId = questions[_currentIndex].id;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_answers[questionId] == null || _answers[questionId]!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pleaseSelectOption),
          backgroundColor: isDark
              ? const Color(0xFF1A1A1A)
              : const Color(0xFF111111),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_currentIndex < questions.length - 1) {
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
    final l10n = AppLocalizations.of(context);
    final questions = _buildQuestions();
    final progress = (_currentIndex + 1) / questions.length;
    final currentQuestion = questions[_currentIndex];
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          color: isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF9FAFB),
          child: SafeArea(
            child: Column(
              children: [
                // AppBar Professional - UX Optimized
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.2 : 0.08),
                        blurRadius: isDark ? 12 : 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Back Button - Primary Action
                      if (_currentIndex > 0)
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF262626) : const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),
                            icon: const Icon(Icons.arrow_back_rounded, size: 20),
                            color: isDark
                                ? const Color(0xFFE5E5E5)
                                : const Color(0xFF111827),
                            onPressed: _previousQuestion,
                          ),
                        )
                      else
                        // Settings Menu (Theme + Language)
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF262626) : const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: PopupMenuButton(
                            icon: Icon(
                              Icons.settings_outlined,
                              size: 20,
                              color: isDark
                                  ? const Color(0xFFE5E5E5)
                                  : const Color(0xFF111827),
                            ),
                            offset: const Offset(0, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                enabled: false,
                                child: Row(
                                  children: [
                                    Text(
                                      l10n.settings,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: isDark
                                            ? const Color(0xFF9A9A9A)
                                            : const Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(
                                      isDark ? Icons.light_mode : Icons.dark_mode,
                                      size: 20,
                                      color: isDark ? Colors.amber : Colors.grey[700],
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        isDark ? 'Mode clair' : 'Mode sombre',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isDark
                                              ? const Color(0xFFE5E5E5)
                                              : const Color(0xFF111827),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Future.delayed(Duration.zero, () {
                                    ref.read(themeModeProvider.notifier).toggleTheme();
                                  });
                                },
                              ),
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    Text(
                                      SupportedLocales.getFlagEmoji(
                                        ref.read(localeProvider),
                                      ),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        l10n.language,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isDark
                                              ? const Color(0xFFE5E5E5)
                                              : const Color(0xFF111827),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  // Toggle language
                                  final currentLocale = ref.read(localeProvider);
                                  final newLocale = currentLocale.languageCode == 'fr'
                                      ? const Locale('en')
                                      : const Locale('fr');
                                  ref.read(localeProvider.notifier).setLocale(newLocale);
                                },
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(width: 12),

                      // Progress Bar - Visual Hierarchy Focus
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${l10n.question} ${_currentIndex + 1}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? const Color(0xFF9A9A9A)
                                        : const Color(0xFF6B7280),
                                  ),
                                ),
                                Text(
                                  '${_currentIndex + 1}/${questions.length}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? const Color(0xFFE5E5E5)
                                        : const Color(0xFF111827),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: isDark
                                    ? const Color(0xFF262626)
                                    : const Color(0xFFE5E7EB),
                                valueColor: AlwaysStoppedAnimation(
                                  AppColors.primary(context),
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
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(0, 36),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          l10n.skip,
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFF9A9A9A)
                                : const Color(0xFF6B7280),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
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
                        backgroundColor: AppColors.primary(context),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        shadowColor: AppColors.primary(context).withOpacity(0.3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentIndex == questions.length - 1
                                ? l10n.finish
                                : l10n.next,
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
