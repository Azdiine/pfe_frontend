class Ingredient {
  final String id;
  final String emoji;
  final String name;
  final String? englishName;
  final String quantity;
  final int daysUntilExpiry;
  final String category;
  final String shelfLocation;

  Ingredient({
    required this.id,
    required this.emoji,
    required this.name,
    this.englishName,
    required this.quantity,
    required this.daysUntilExpiry,
    required this.category,
    required this.shelfLocation,
  });

  /// Name sent to the English-language recommendation model
  String get searchName => englishName ?? name;

  bool get isExpiringSoon => daysUntilExpiry <= 3;

  /// Photo réaliste de l'aliment (pollinations.ai, gratuit, sans clé).
  /// Seed déterministe : le même aliment garde toujours la même photo.
  String get imageUrl {
    final seed = searchName.codeUnits.fold<int>(0, (s, c) => s + c) % 100000;
    final prompt = Uri.encodeComponent(
      'fresh $searchName, food ingredient, on clean white background, '
      'studio photography, high quality',
    );
    return 'https://image.pollinations.ai/prompt/$prompt'
        '?width=200&height=200&nologo=true&seed=$seed';
  }

  Ingredient copyWith({
    String? id,
    String? emoji,
    String? name,
    String? englishName,
    String? quantity,
    int? daysUntilExpiry,
    String? category,
    String? shelfLocation,
  }) {
    return Ingredient(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      name: name ?? this.name,
      englishName: englishName ?? this.englishName,
      quantity: quantity ?? this.quantity,
      daysUntilExpiry: daysUntilExpiry ?? this.daysUntilExpiry,
      category: category ?? this.category,
      shelfLocation: shelfLocation ?? this.shelfLocation,
    );
  }
}
