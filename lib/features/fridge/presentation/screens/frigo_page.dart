import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/base_page.dart';

class FrigoPage extends BasePage {
  const FrigoPage({super.key}) : super(currentNavIndex: 3);

  @override
  State<FrigoPage> createState() => _FrigoPageState();
}

class _FrigoPageState extends BasePageState<FrigoPage> {
  String _selectedCategory = 'Tous';

  final List<String> _categories = [
    'Tous',
    'Fruits',
    'Légumes',
    'Viandes',
    'Produits laitiers',
    'Autres',
  ];

  final List<Map<String, dynamic>> _ingredients = [
    {'name': 'Poulet', 'quantity': '500g', 'emoji': '🍗', 'expiry': '3 jours'},
    {
      'name': 'Tomates',
      'quantity': '6 pcs',
      'emoji': '🍅',
      'expiry': '5 jours',
    },
    {'name': 'Lait', 'quantity': '1L', 'emoji': '🥛', 'expiry': '7 jours'},
    {'name': 'Œufs', 'quantity': '12 pcs', 'emoji': '🥚', 'expiry': '10 jours'},
    {'name': 'Fromage', 'quantity': '200g', 'emoji': '🧀', 'expiry': '2 jours'},
    {
      'name': 'Carottes',
      'quantity': '8 pcs',
      'emoji': '🥕',
      'expiry': '6 jours',
    },
    {'name': 'Pommes', 'quantity': '5 pcs', 'emoji': '🍎', 'expiry': '8 jours'},
    {'name': 'Pâtes', 'quantity': '500g', 'emoji': '🍝', 'expiry': '90 jours'},
  ];

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Mon Frigo',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFF111827),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add_circle_outline, color: Color(0xFFFF6B35)),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {},
      backgroundColor: const Color(0xFF8B5CF6),
      icon: const Icon(Icons.auto_awesome, color: Colors.white),
      label: const Text(
        'Recettes suggestions',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return Column(
      children: [
        // Categories
        Container(
          height: 50,
          color: Colors.white,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = category == _selectedCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  backgroundColor: Colors.white,
                  selectedColor: const Color(0xFFFF6B35),
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF6B7280),
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? const Color(0xFFFF6B35)
                        : const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
              );
            },
          ),
        ),

        // Summary card
        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  '🧊',
                  'Ingrédients',
                  '${_ingredients.length}',
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.3),
                ),
                _buildSummaryItem('⚠️', 'Expire bientôt', '2'),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.3),
                ),
                _buildSummaryItem('📝', 'Recettes', '12'),
              ],
            ),
          ),
        ),

        // Ingredients list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = _ingredients[index];
              final isExpiringSoon = index == 4; // Fromage expire dans 2 jours
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildIngredientCard(
                  ingredient['emoji'],
                  ingredient['name'],
                  ingredient['quantity'],
                  ingredient['expiry'],
                  isExpiringSoon,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientCard(
    String emoji,
    String name,
    String quantity,
    String expiry,
    bool isExpiringSoon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isExpiringSoon
            ? Border.all(color: const Color(0xFFF59E0B), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quantité: $quantity',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      isExpiringSoon ? Icons.warning : Icons.access_time,
                      size: 14,
                      color: isExpiringSoon
                          ? const Color(0xFFF59E0B)
                          : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Expire dans $expiry',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isExpiringSoon
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF6B7280)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
