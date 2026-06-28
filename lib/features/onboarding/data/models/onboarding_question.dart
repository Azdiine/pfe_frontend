import '../../../../l10n/generated/app_localizations.dart';

class OnboardingQuestion {
  final int id;
  final String questionKey;
  final String? subtitleKey;
  final String fieldKey; // DB column name
  final List<String> optionKeys; // actual DB values
  final List<String>? benefitKeys;
  final bool multiSelect;
  final bool hasTextInput;
  final bool isNumericInput;
  final String? hintKey;

  OnboardingQuestion({
    required this.id,
    required this.questionKey,
    this.subtitleKey,
    required this.fieldKey,
    this.optionKeys = const [],
    this.benefitKeys,
    this.multiSelect = false,
    this.hasTextInput = false,
    this.isNumericInput = false,
    this.hintKey,
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
      case 'onbQ2Sub': return l10n.onbQ2Sub;
      case 'onbQ3Sub': return l10n.onbQ3Sub;
      case 'onbQ4Sub': return l10n.onbQ4Sub;
      case 'onbQ5Sub': return l10n.onbQ5Sub;
      case 'onbQ7Sub': return l10n.onbQ7Sub;
      case 'onbQ9Sub': return l10n.onbQ9Sub;
      case 'onbQ10Sub': return l10n.onbQ10Sub;
      case 'onbQ11Sub': return l10n.onbQ11Sub;
      default: return null;
    }
  }

  String? getHint(AppLocalizations l10n) {
    if (hintKey == null) return null;
    switch (hintKey) {
      case 'onbQ2Hint': return l10n.onbQ2Hint;
      case 'onbQ3Hint': return l10n.onbQ3Hint;
      case 'onbQ4Hint': return l10n.onbQ4Hint;
      case 'onbQ5Hint': return l10n.onbQ5Hint;
      default: return null;
    }
  }

  String _getOptionLabel(String key, AppLocalizations l10n) {
    switch (key) {
      // Gender
      case 'male': return l10n.onbGenderMale;
      case 'female': return l10n.onbGenderFemale;
      case 'other': return l10n.onbGenderOther;
      // Goal
      case 'lose_weight': return l10n.onbGoalLose;
      case 'gain_muscle': return l10n.onbGoalGain;
      case 'maintain': return l10n.onbGoalMaintain;
      case 'eat_healthier': return l10n.onbGoalHealthy;
      case 'improve_fitness': return l10n.onbGoalFitness;
      // Activity level
      case 'sedentary': return l10n.onbActivitySedentary;
      case 'lightly_active': return l10n.onbActivityLight;
      case 'moderately_active': return l10n.onbActivityModerate;
      case 'active': return l10n.onbActivityActive;
      case 'very_active': return l10n.onbActivityVery;
      // Diet
      case 'omnivore': return l10n.onbDietOmnivore;
      case 'vegetarian': return l10n.onbDietVegetarian;
      case 'vegan': return l10n.onbDietVegan;
      case 'halal': return l10n.onbDietHalal;
      case 'keto': return l10n.onbDietKeto;
      case 'paleo': return l10n.onbDietPaleo;
      case 'no_preference': return l10n.onbDietNone;
      // Allergies
      case 'peanuts': return l10n.onbAllergyPeanuts;
      case 'seafood': return l10n.onbAllergySeafood;
      case 'dairy': return l10n.onbAllergyDairy;
      case 'eggs': return l10n.onbAllergyEggs;
      case 'gluten': return l10n.onbAllergyGluten;
      case 'soy': return l10n.onbAllergySoy;
      case 'allergy_other': return l10n.onbAllergyOther;
      case 'allergy_none': return l10n.onbAllergyNone;
      // Health conditions
      case 'diabetes': return l10n.onbHealthDiabetes;
      case 'hypertension': return l10n.onbHealthHypertension;
      case 'high_cholesterol': return l10n.onbHealthCholesterol;
      case 'heart_disease': return l10n.onbHealthHeart;
      case 'health_other': return l10n.onbHealthOther;
      case 'health_none': return l10n.onbHealthNone;
      // Cuisine
      case 'quick_simple': return l10n.onbCuisineQuick;
      case 'healthy': return l10n.onbCuisineHealthy;
      case 'high_protein': return l10n.onbCuisineProtein;
      case 'budget_friendly': return l10n.onbCuisineBudget;
      case 'gourmet': return l10n.onbCuisineGourmet;
      case 'world_cuisine': return l10n.onbCuisineWorld;
      case 'traditional': return l10n.onbCuisineTraditional;
      default: return key;
    }
  }

  List<String> getOptions(AppLocalizations l10n) {
    return optionKeys.map((key) => _getOptionLabel(key, l10n)).toList();
  }

  List<String>? getBenefits(AppLocalizations l10n) {
    if (benefitKeys == null) return null;
    return benefitKeys!.map((key) {
      switch (key) {
        case 'onbQ1Ben1': return l10n.onbQ1Ben1;
        case 'onbQ2Ben1': return l10n.onbQ2Ben1;
        case 'onbQ3Ben1': return l10n.onbQ3Ben1;
        case 'onbQ4Ben1': return l10n.onbQ4Ben1;
        case 'onbQ5Ben1': return l10n.onbQ5Ben1;
        case 'onbQ6Ben1': return l10n.onbQ6Ben1;
        case 'onbQ7Ben1': return l10n.onbQ7Ben1;
        case 'onbQ8Ben1': return l10n.onbQ8Ben1;
        case 'onbQ9Ben1': return l10n.onbQ9Ben1;
        case 'onbQ10Ben1': return l10n.onbQ10Ben1;
        case 'onbQ11Ben1': return l10n.onbQ11Ben1;
        default: return key;
      }
    }).toList();
  }
}
