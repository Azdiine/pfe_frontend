import '../../core/constants.dart';

class Validators {
  // Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez entrer un email valide';
    }

    return null;
  }

  // Password Validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }

    if (value.length < ValidationConstants.minPasswordLength) {
      return 'Le mot de passe doit contenir au moins ${ValidationConstants.minPasswordLength} caractères';
    }

    if (value.length > ValidationConstants.maxPasswordLength) {
      return 'Le mot de passe ne doit pas dépasser ${ValidationConstants.maxPasswordLength} caractères';
    }

    // Optional: Add more password complexity requirements
    // if (!value.contains(RegExp(r'[A-Z]'))) {
    //   return 'Le mot de passe doit contenir au moins une lettre majuscule';
    // }
    
    // if (!value.contains(RegExp(r'[0-9]'))) {
    //   return 'Le mot de passe doit contenir au moins un chiffre';
    // }

    return null;
  }

  // Name Validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le nom est requis';
    }

    if (value.length < ValidationConstants.minUsernameLength) {
      return 'Le nom doit contenir au moins ${ValidationConstants.minUsernameLength} caractères';
    }

    if (value.length > ValidationConstants.maxUsernameLength) {
      return 'Le nom ne doit pas dépasser ${ValidationConstants.maxUsernameLength} caractères';
    }

    return null;
  }

  // Required Field Validation
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Ce champ'} est requis';
    }
    return null;
  }

  // Phone Number Validation (French format)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de téléphone est requis';
    }

    final phoneRegex = RegExp(r'^(?:(?:\+|00)33|0)\s*[1-9](?:[\s.-]*\d{2}){4}$');
    
    if (!phoneRegex.hasMatch(value)) {
      return 'Veuillez entrer un numéro de téléphone valide';
    }

    return null;
  }

  // Number Validation
  static String? validateNumber(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Ce champ'} est requis';
    }

    if (double.tryParse(value) == null) {
      return 'Veuillez entrer un nombre valide';
    }

    return null;
  }

  // Price Validation
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le prix est requis';
    }

    final price = double.tryParse(value);
    if (price == null) {
      return 'Veuillez entrer un prix valide';
    }

    if (price < 0) {
      return 'Le prix ne peut pas être négatif';
    }

    return null;
  }

  // URL Validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'URL est requise';
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Veuillez entrer une URL valide';
    }

    return null;
  }

  // Confirm Password Validation
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer le mot de passe';
    }

    if (value != password) {
      return 'Les mots de passe ne correspondent pas';
    }

    return null;
  }
}
