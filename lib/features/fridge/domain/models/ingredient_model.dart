class Ingredient {
  final String id;
  final String emoji;
  final String name;
  final String quantity;
  final int daysUntilExpiry;
  final String category;
  final String shelfLocation;

  Ingredient({
    required this.id,
    required this.emoji,
    required this.name,
    required this.quantity,
    required this.daysUntilExpiry,
    required this.category,
    required this.shelfLocation,
  });

  bool get isExpiringSoon => daysUntilExpiry <= 3;

  Ingredient copyWith({
    String? id,
    String? emoji,
    String? name,
    String? quantity,
    int? daysUntilExpiry,
    String? category,
    String? shelfLocation,
  }) {
    return Ingredient(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      daysUntilExpiry: daysUntilExpiry ?? this.daysUntilExpiry,
      category: category ?? this.category,
      shelfLocation: shelfLocation ?? this.shelfLocation,
    );
  }
}
