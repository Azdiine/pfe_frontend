class OnboardingQuestion {
  final int id;
  final String question;
  final String? subtitle;
  final List<String> options;
  final List<String>? benefits;
  final bool multiSelect;
  final bool hasTextInput;

  OnboardingQuestion({
    required this.id,
    required this.question,
    this.subtitle,
    required this.options,
    this.benefits,
    this.multiSelect = false,
    this.hasTextInput = false,
  });
}
