import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/models/onboarding_question.dart';
import '../../../../core/theme/app_colors.dart';

class QuestionCard extends StatefulWidget {
  final OnboardingQuestion question;
  final List<String> selectedOptions;
  final Function(String) onOptionSelected;
  final String textInput;
  final Function(String) onTextInputChanged;

  const QuestionCard({
    super.key,
    required this.question,
    required this.selectedOptions,
    required this.onOptionSelected,
    required this.textInput,
    required this.onTextInputChanged,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  String _defaultBirthDateValue() {
    final now = DateTime.now();
    final defaultDate = DateTime(now.year - 18, now.month, now.day);
    return _formatBirthDate(defaultDate);
  }

  String _formatBirthDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  DateTime _parseBirthDate(String? value) {
    if (value == null || value.isEmpty) {
      final now = DateTime.now();
      return DateTime(now.year - 18, now.month, now.day);
    }

    final parts = value.split('/');
    if (parts.length != 3) return DateTime.now();

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) return DateTime.now();

    return DateTime(year, month, day);
  }

  List<String> _buildNumericValues(String fieldKey) {
    switch (fieldKey) {
      case 'heightCm':
        return List.generate(201, (index) => '${100 + index}');
      case 'weightKg':
        return List.generate(181, (index) => '${40 + index}');
      case 'targetWeightKg':
        return List.generate(181, (index) => '${40 + index}');
      default:
        return List.generate(100, (index) => '${index + 1}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.question;
    final selectedOptions = widget.selectedOptions;
    final textInput = widget.textInput;
    final onOptionSelected = widget.onOptionSelected;
    final onTextInputChanged = widget.onTextInputChanged;

    final l10n = AppLocalizations.of(context);
    final questionText = question.getQuestion(l10n);
    final subtitleText = question.getSubtitle(l10n);
    final options = question.getOptions(l10n);
    final benefits = question.getBenefits(l10n);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Badge - Clean & Pro
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${l10n.question} ${question.id}/11',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Question Title - Professional
          Text(
            questionText,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFFFAFAFA) : const Color(0xFF111827),
              height: 1.3,
              letterSpacing: -0.5,
            ),
          ),

          if (subtitleText != null) ...[
            const SizedBox(height: 12),
            Text(
              subtitleText,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isDark ? const Color(0xFFD4D4D4) : const Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
          ],

          if (benefits != null && benefits.isNotEmpty) ...[
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: benefits.map((benefit) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8),
                    border: isDark ? Border.all(
                      color: const Color(0xFF404040),
                      width: 1,
                    ) : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 14,
                        color: AppColors.primary(context),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          benefit,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFFE5E5E5) : const Color(0xFF374151),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 28),

          // iOS-style picker mode for numeric/date questions
          if (question.isNumericInput) ...[
            Builder(
              builder: (context) {
                final isBirthDate = question.fieldKey == 'birthDate';
                final pickerItems = isBirthDate
                    ? const <String>[]
                    : _buildNumericValues(question.fieldKey);
                final currentValue = textInput.isNotEmpty
                    ? textInput
                    : (isBirthDate ? _defaultBirthDateValue() : pickerItems.first);
                final selectedIndex = isBirthDate
                    ? 0
                    : pickerItems.indexOf(currentValue).clamp(0, pickerItems.length - 1);

                return Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.primary(context),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary(context).withOpacity(isDark ? 0.22 : 0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isBirthDate ? l10n.age : 'Sélectionnez une valeur',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark ? const Color(0xFFD4D4D4) : const Color(0xFF4B5563),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.primary(context).withOpacity(isDark ? 0.18 : 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                currentValue,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 220,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF111111) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: isBirthDate
                            ? CupertinoTheme(
                                data: CupertinoThemeData(
                                  brightness: isDark ? Brightness.dark : Brightness.light,
                                ),
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.date,
                                  initialDateTime: _parseBirthDate(currentValue),
                                  minimumDate: DateTime(1950, 1, 1),
                                  maximumDate: DateTime.now(),
                                  use24hFormat: true,
                                  onDateTimeChanged: (date) {
                                    onTextInputChanged(_formatBirthDate(date));
                                  },
                                ),
                              )
                            : CupertinoPicker(
                                key: ValueKey('picker_${question.id}_$currentValue'),
                                itemExtent: 46,
                                scrollController: FixedExtentScrollController(initialItem: selectedIndex),
                                backgroundColor: Colors.transparent,
                                useMagnifier: true,
                                magnification: 1.06,
                                diameterRatio: 1.25,
                                squeeze: 1.1,
                                onSelectedItemChanged: (index) {
                                  onTextInputChanged(pickerItems[index]);
                                },
                                children: pickerItems.map((value) {
                                  final unit = question.fieldKey == 'heightCm'
                                      ? 'cm'
                                      : question.fieldKey == 'weightKg' || question.fieldKey == 'targetWeightKg'
                                          ? 'kg'
                                          : '';
                                  return Center(
                                    child: Text(
                                      unit.isEmpty ? value : '$value $unit',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? const Color(0xFFFAFAFA) : const Color(0xFF111827),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                      ),
                      if (question.getHint(l10n) != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                          child: Text(
                            question.getHint(l10n)!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isDark ? const Color(0xFF9A9A9A) : const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],

          // Options - Professional Style
          if (!question.isNumericInput)
          ...options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = selectedOptions.contains(question.optionKeys[index]);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onOptionSelected(question.optionKeys[index]),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary(context)
                          : (isDark ? const Color(0xFF1A1A1A) : Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary(context)
                            : (isDark ? const Color(0xFF404040) : const Color(0xFFE5E7EB)),
                        width: 2,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: AppColors.primary(context).withOpacity(isDark ? 0.3 : 0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        else if (isDark)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            shape: question.multiSelect
                                ? BoxShape.rectangle
                                : BoxShape.circle,
                            borderRadius: question.multiSelect
                                ? BorderRadius.circular(6)
                                : null,
                            border: isSelected
                                ? null
                                : Border.all(
                                    color: isDark ? const Color(0xFF404040) : const Color(0xFFD1D5DB),
                                    width: 2,
                                  ),
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check,
                                  size: 16,
                                  color: AppColors.primary(context),
                                )
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? const Color(0xFFFAFAFA) : const Color(0xFF111827)),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          // Text Input - Professional Style
          if (question.hasTextInput && selectedOptions.contains(question.optionKeys.last)) ...[
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary(context), width: 2),
                boxShadow: isDark ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: TextField(
                key: ValueKey('textfield_${question.id}'),
                onChanged: onTextInputChanged,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? const Color(0xFFFAFAFA) : const Color(0xFF111827),
                ),
                decoration: InputDecoration(
                  hintText: l10n.specifyHere,
                  hintStyle: TextStyle(
                    color: isDark ? const Color(0xFF737373) : const Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
