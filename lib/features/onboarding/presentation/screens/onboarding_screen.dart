import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/onboarding_question.dart';
import '../widgets/question_card.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/constants.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentIndex = 0;
  bool _isSaving = false;
  final Map<int, List<String>> _answers = {};
  final Map<int, String> _textInputs = {};

  String? _toIsoBirthDate(String value) {
    final parts = value.split('/');
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) return null;

    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }

    final isoMonth = month.toString().padLeft(2, '0');
    final isoDay = day.toString().padLeft(2, '0');
    return '$year-$isoMonth-$isoDay';
  }

  List<OnboardingQuestion> _buildQuestions() {
    return [
      // Q1: Gender
      OnboardingQuestion(
        id: 1,
        questionKey: 'onbQ1',
        subtitleKey: 'onbQ1Sub',
        fieldKey: 'gender',
        optionKeys: ['male', 'female', 'other'],
        benefitKeys: ['onbQ1Ben1'],
      ),
      // Q2: Birth date
      OnboardingQuestion(
        id: 2,
        questionKey: 'onbQ2',
        subtitleKey: 'onbQ2Sub',
        fieldKey: 'birthDate',
        isNumericInput: true,
        hintKey: 'onbQ2Hint',
        benefitKeys: ['onbQ2Ben1'],
      ),
      // Q3: Height
      OnboardingQuestion(
        id: 3,
        questionKey: 'onbQ3',
        subtitleKey: 'onbQ3Sub',
        fieldKey: 'heightCm',
        isNumericInput: true,
        hintKey: 'onbQ3Hint',
        benefitKeys: ['onbQ3Ben1'],
      ),
      // Q4: Current weight
      OnboardingQuestion(
        id: 4,
        questionKey: 'onbQ4',
        subtitleKey: 'onbQ4Sub',
        fieldKey: 'weightKg',
        isNumericInput: true,
        hintKey: 'onbQ4Hint',
        benefitKeys: ['onbQ4Ben1'],
      ),
      // Q5: Target weight
      OnboardingQuestion(
        id: 5,
        questionKey: 'onbQ5',
        subtitleKey: 'onbQ5Sub',
        fieldKey: 'targetWeightKg',
        isNumericInput: true,
        hintKey: 'onbQ5Hint',
        benefitKeys: ['onbQ5Ben1'],
      ),
      // Q6: Goal
      OnboardingQuestion(
        id: 6,
        questionKey: 'onbQ6',
        fieldKey: 'goal',
        optionKeys: ['lose_weight', 'gain_muscle', 'maintain', 'eat_healthier', 'improve_fitness'],
        benefitKeys: ['onbQ6Ben1'],
      ),
      // Q7: Activity level
      OnboardingQuestion(
        id: 7,
        questionKey: 'onbQ7',
        subtitleKey: 'onbQ7Sub',
        fieldKey: 'activityLevel',
        optionKeys: ['sedentary', 'lightly_active', 'moderately_active', 'active', 'very_active'],
        benefitKeys: ['onbQ7Ben1'],
      ),
      // Q8: Diet type
      OnboardingQuestion(
        id: 8,
        questionKey: 'onbQ8',
        fieldKey: 'dietType',
        optionKeys: ['omnivore', 'vegetarian', 'vegan', 'halal', 'keto', 'paleo', 'no_preference'],
        benefitKeys: ['onbQ8Ben1'],
      ),
      // Q9: Allergies
      OnboardingQuestion(
        id: 9,
        questionKey: 'onbQ9',
        subtitleKey: 'onbQ9Sub',
        fieldKey: 'allergies',
        optionKeys: ['peanuts', 'seafood', 'dairy', 'eggs', 'gluten', 'soy', 'allergy_other', 'allergy_none'],
        benefitKeys: ['onbQ9Ben1'],
        multiSelect: true,
        hasTextInput: true,
      ),
      // Q10: Health conditions
      OnboardingQuestion(
        id: 10,
        questionKey: 'onbQ10',
        subtitleKey: 'onbQ10Sub',
        fieldKey: 'healthConditions',
        optionKeys: ['diabetes', 'hypertension', 'high_cholesterol', 'heart_disease', 'health_other', 'health_none'],
        benefitKeys: ['onbQ10Ben1'],
        multiSelect: true,
        hasTextInput: true,
      ),
      // Q11: Cuisine preferences
      OnboardingQuestion(
        id: 11,
        questionKey: 'onbQ11',
        subtitleKey: 'onbQ11Sub',
        fieldKey: 'cuisinePrefs',
        optionKeys: ['quick_simple', 'healthy', 'high_protein', 'budget_friendly', 'gourmet', 'world_cuisine', 'traditional'],
        benefitKeys: ['onbQ11Ben1'],
        multiSelect: true,
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
    final question = questions[_currentIndex];
    final questionId = question.id;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Validate: numeric → check textInputs, options → check answers
    if (question.isNumericInput) {
      final value = _textInputs[questionId];
      final isBirthDateQuestion = question.fieldKey == 'birthDate';
      final isValid = isBirthDateQuestion
          ? value != null && value.isNotEmpty
          : value != null && value.isNotEmpty && num.tryParse(value) != null;

      if (!isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.pleaseEnterValue),
            backgroundColor: isDark
                ? const Color(0xFF1A1A1A)
                : const Color(0xFF111111),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    } else {
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

  void _completeOnboarding() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final questions = _buildQuestions();
    final Map<String, dynamic> profileData = {};

    for (final q in questions) {
      if (q.isNumericInput) {
        final value = _textInputs[q.id];
        if (value != null && value.isNotEmpty) {
          profileData[q.fieldKey] = q.fieldKey == 'birthDate'
              ? _toIsoBirthDate(value)
              : num.tryParse(value);
        }
      } else if (q.multiSelect) {
        final selected = _answers[q.id] ?? [];
        // Add free-text "other" value if present
        final extra = _textInputs[q.id];
        final list = List<String>.from(selected);
        if (extra != null && extra.isNotEmpty) {
          list.remove('allergy_other');
          list.remove('health_other');
          list.add(extra);
        }
        // Remove "none" markers
        list.remove('allergy_none');
        list.remove('health_none');
        profileData[q.fieldKey] = list;
      } else {
        final selected = _answers[q.id];
        if (selected != null && selected.isNotEmpty) {
          profileData[q.fieldKey] = selected.first;
        }
      }
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.tokenKey);

      final response = await http
          .put(
            Uri.parse('${ApiConstants.baseUrl}/api/profile/onboarding'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(profileData),
          )
          .timeout(ApiConstants.connectionTimeout);

      if (!mounted) return;

      if (response.statusCode == 200) {
        context.go('/home');
      } else {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(body['message'] ?? 'Error saving profile'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
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
                      onPressed: _isSaving ? null : _nextQuestion,
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
