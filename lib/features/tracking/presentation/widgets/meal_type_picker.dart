import 'package:flutter/cupertino.dart';

/// Métadonnées d'affichage des types de repas (partagées par le suivi
/// et les popups de recettes).
class MealTypes {
  static const List<(String, String, String)> all = [
    ('breakfast', '🥐', 'Petit-déjeuner'),
    ('lunch', '🍽️', 'Déjeuner'),
    ('dinner', '🌙', 'Dîner'),
    ('snack', '🍎', 'Collation'),
  ];

  static String emoji(String type) =>
      all.firstWhere((m) => m.$1 == type, orElse: () => all.last).$2;

  static String label(String type) =>
      all.firstWhere((m) => m.$1 == type, orElse: () => all.last).$3;
}

/// Ouvre un action sheet « Ajouter à quel repas ? » et renvoie le type
/// choisi ('breakfast' / 'lunch' / 'dinner' / 'snack'), ou null si annulé.
Future<String?> showMealTypePicker(BuildContext context) {
  return showCupertinoModalPopup<String>(
    context: context,
    builder: (sheetContext) => CupertinoActionSheet(
      title: const Text('Ajouter à quel repas ?'),
      actions: [
        for (final (type, emoji, label) in MealTypes.all)
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(sheetContext, type),
            child: Text('$emoji  $label'),
          ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () => Navigator.pop(sheetContext),
        child: const Text('Annuler'),
      ),
    ),
  );
}
