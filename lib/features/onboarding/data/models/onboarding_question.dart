import '../../../../l10n/generated/app_localizations.dart';

class OnboardingQuestion {
  final int id;
  final String questionKey;
  final String? subtitleKey;
  final List<String> optionKeys;
  final List<String>? benefitKeys;
  final bool multiSelect;
  final bool hasTextInput;

  OnboardingQuestion({
    required this.id,
    required this.questionKey,
    this.subtitleKey,
    required this.optionKeys,
    this.benefitKeys,
    this.multiSelect = false,
    this.hasTextInput = false,
  });

  String getQuestion(AppLocalizations l10n) {
    switch (questionKey) {
      case 'onbQ1': return l10n.onbQ1;
      case 'onbQ2': return l10n.onbQ2;
      case 'onbQ3': return l10n.onbQ3;
      case 'onbQ4': return l10n.onbQ4;
      case 'onbQ5': return l10n.onbQ5;
      case 'onbQ6': return l10n.onbQ6;
      case 'onbQ7': return l10n.onbQ7;
      case 'onbQ8': return l10n.onbQ8;
      case 'onbQ9': return l10n.onbQ9;
      case 'onbQ10': return l10n.onbQ10;
      case 'onbQ11': return l10n.onbQ11;
      default: return '';
    }
  }

  String? getSubtitle(AppLocalizations l10n) {
    if (subtitleKey == null) return null;
    switch (subtitleKey) {
      case 'onbQ1Sub': return l10n.onbQ1Sub;
      case 'onbQ3Sub': return l10n.onbQ3Sub;
      case 'onbQ7Sub': return l10n.onbQ7Sub;
      case 'onbQ9Sub': return l10n.onbQ9Sub;
      case 'onbQ11Sub': return l10n.onbQ11Sub;
      default: return null;
    }
  }

  List<String> getOptions(AppLocalizations l10n) {
    return optionKeys.map((key) {
      switch (key) {
        case 'onbQ1Opt1': return l10n.onbQ1Opt1;
        case 'onbQ1Opt2': return l10n.onbQ1Opt2;
        case 'onbQ1Opt3': return l10n.onbQ1Opt3;
        case 'onbQ1Opt4': return l10n.onbQ1Opt4;
        case 'onbQ2Opt1': return l10n.onbQ2Opt1;
        case 'onbQ2Opt2': return l10n.onbQ2Opt2;
        case 'onbQ2Opt3': return l10n.onbQ2Opt3;
        case 'onbQ2Opt4': return l10n.onbQ2Opt4;
        case 'onbQ3Opt1': return l10n.onbQ3Opt1;
        case 'onbQ3Opt2': return l10n.onbQ3Opt2;
        case 'onbQ3Opt3': return l10n.onbQ3Opt3;
        case 'onbQ3Opt4': return l10n.onbQ3Opt4;
        case 'onbQ4Opt1': return l10n.onbQ4Opt1;
        case 'onbQ4Opt2': return l10n.onbQ4Opt2;
        case 'onbQ4Opt3': return l10n.onbQ4Opt3;
        case 'onbQ5Opt1': return l10n.onbQ5Opt1;
        case 'onbQ5Opt2': return l10n.onbQ5Opt2;
        case 'onbQ5Opt3': return l10n.onbQ5Opt3;
        case 'onbQ5Opt4': return l10n.onbQ5Opt4;
        case 'onbQ5Opt5': return l10n.onbQ5Opt5;
        case 'onbQ5Opt6': return l10n.onbQ5Opt6;
        case 'onbQ5Opt7': return l10n.onbQ5Opt7;
        case 'onbQ5Opt8': return l10n.onbQ5Opt8;
        case 'onbQ6Opt1': return l10n.onbQ6Opt1;
        case 'onbQ6Opt2': return l10n.onbQ6Opt2;
        case 'onbQ6Opt3': return l10n.onbQ6Opt3;
        case 'onbQ6Opt4': return l10n.onbQ6Opt4;
        case 'onbQ6Opt5': return l10n.onbQ6Opt5;
        case 'onbQ6Opt6': return l10n.onbQ6Opt6;
        case 'onbQ7Opt1': return l10n.onbQ7Opt1;
        case 'onbQ7Opt2': return l10n.onbQ7Opt2;
        case 'onbQ7Opt3': return l10n.onbQ7Opt3;
        case 'onbQ7Opt4': return l10n.onbQ7Opt4;
        case 'onbQ7Opt5': return l10n.onbQ7Opt5;
        case 'onbQ7Opt6': return l10n.onbQ7Opt6;
        case 'onbQ7Opt7': return l10n.onbQ7Opt7;
        case 'onbQ8Opt1': return l10n.onbQ8Opt1;
        case 'onbQ8Opt2': return l10n.onbQ8Opt2;
        case 'onbQ8Opt3': return l10n.onbQ8Opt3;
        case 'onbQ9Opt1': return l10n.onbQ9Opt1;
        case 'onbQ9Opt2': return l10n.onbQ9Opt2;
        case 'onbQ9Opt3': return l10n.onbQ9Opt3;
        case 'onbQ9Opt4': return l10n.onbQ9Opt4;
        case 'onbQ9Opt5': return l10n.onbQ9Opt5;
        case 'onbQ9Opt6': return l10n.onbQ9Opt6;
        case 'onbQ9Opt7': return l10n.onbQ9Opt7;
        case 'onbQ10Opt1': return l10n.onbQ10Opt1;
        case 'onbQ10Opt2': return l10n.onbQ10Opt2;
        case 'onbQ10Opt3': return l10n.onbQ10Opt3;
        case 'onbQ10Opt4': return l10n.onbQ10Opt4;
        case 'onbQ11Opt1': return l10n.onbQ11Opt1;
        case 'onbQ11Opt2': return l10n.onbQ11Opt2;
        case 'onbQ11Opt3': return l10n.onbQ11Opt3;
        default: return key;
      }
    }).toList();
  }

  List<String>? getBenefits(AppLocalizations l10n) {
    if (benefitKeys == null) return null;
    return benefitKeys!.map((key) {
      switch (key) {
        case 'onbQ1Ben1': return l10n.onbQ1Ben1;
        case 'onbQ1Ben2': return l10n.onbQ1Ben2;
        case 'onbQ2Ben1': return l10n.onbQ2Ben1;
        case 'onbQ2Ben2': return l10n.onbQ2Ben2;
        case 'onbQ3Ben1': return l10n.onbQ3Ben1;
        case 'onbQ3Ben2': return l10n.onbQ3Ben2;
        case 'onbQ4Ben1': return l10n.onbQ4Ben1;
        case 'onbQ4Ben2': return l10n.onbQ4Ben2;
        case 'onbQ4Ben3': return l10n.onbQ4Ben3;
        case 'onbQ5Ben1': return l10n.onbQ5Ben1;
        case 'onbQ6Ben1': return l10n.onbQ6Ben1;
        case 'onbQ7Ben1': return l10n.onbQ7Ben1;
        case 'onbQ8Ben1': return l10n.onbQ8Ben1;
        case 'onbQ9Ben1': return l10n.onbQ9Ben1;
        case 'onbQ10Ben1': return l10n.onbQ10Ben1;
        case 'onbQ10Ben2': return l10n.onbQ10Ben2;
        case 'onbQ11Ben1': return l10n.onbQ11Ben1;
        default: return key;
      }
    }).toList();
  }
}
