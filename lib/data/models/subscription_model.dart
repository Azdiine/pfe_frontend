// Base Subscription Model
class SubscriptionModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final String period; // monthly, yearly, etc.
  final List<String> features;
  final bool isActive;
  final DateTime? expiresAt;

  SubscriptionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.period,
    required this.features,
    this.isActive = false,
    this.expiresAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      period: json['period'] as String,
      features: List<String>.from(json['features'] as List),
      isActive: json['isActive'] as bool? ?? false,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'period': period,
      'features': features,
      'isActive': isActive,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }
}
