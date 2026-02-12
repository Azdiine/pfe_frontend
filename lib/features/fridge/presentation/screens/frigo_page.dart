import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/apple_theme.dart';
import '../../domain/models/ingredient_model.dart';
import 'barcode_scanner_page.dart';

class FrigoPage extends StatefulWidget {
  const FrigoPage({super.key});

  @override
  State<FrigoPage> createState() => _FrigoPageState();
}

class _FrigoPageState extends State<FrigoPage> {
  late List<Ingredient> _topShelfItems;
  late List<Ingredient> _middleShelfItems;
  late List<Ingredient> _bottomShelfItems;
  late List<Ingredient> _doorItems;

  @override
  void initState() {
    super.initState();
    _initializeIngredients();
  }

  void _initializeIngredients() {
    _topShelfItems = [
      Ingredient(
        id: '1',
        emoji: '🥛',
        name: 'Lait',
        quantity: '1L',
        daysUntilExpiry: 7,
        category: 'Dairy',
        shelfLocation: 'top',
      ),
      Ingredient(
        id: '2',
        emoji: '🧃',
        name: 'Jus d\'orange',
        quantity: '500ml',
        daysUntilExpiry: 5,
        category: 'Beverages',
        shelfLocation: 'top',
      ),
    ];

    _middleShelfItems = [
      Ingredient(
        id: '3',
        emoji: '🍗',
        name: 'Poulet',
        quantity: '500g',
        daysUntilExpiry: 2,
        category: 'Meat',
        shelfLocation: 'middle',
      ),
      Ingredient(
        id: '4',
        emoji: '🧀',
        name: 'Fromage',
        quantity: '200g',
        daysUntilExpiry: 10,
        category: 'Dairy',
        shelfLocation: 'middle',
      ),
      Ingredient(
        id: '5',
        emoji: '🥚',
        name: 'Œufs',
        quantity: '12 pcs',
        daysUntilExpiry: 14,
        category: 'Dairy',
        shelfLocation: 'middle',
      ),
    ];

    _bottomShelfItems = [
      Ingredient(
        id: '6',
        emoji: '🍅',
        name: 'Tomates',
        quantity: '6 pcs',
        daysUntilExpiry: 4,
        category: 'Vegetables',
        shelfLocation: 'bottom',
      ),
      Ingredient(
        id: '7',
        emoji: '🥕',
        name: 'Carottes',
        quantity: '8 pcs',
        daysUntilExpiry: 8,
        category: 'Vegetables',
        shelfLocation: 'bottom',
      ),
      Ingredient(
        id: '8',
        emoji: '🥬',
        name: 'Laitue',
        quantity: '1 pc',
        daysUntilExpiry: 3,
        category: 'Vegetables',
        shelfLocation: 'bottom',
      ),
    ];

    _doorItems = [
      Ingredient(
        id: '9',
        emoji: '🍯',
        name: 'Miel',
        quantity: '250g',
        daysUntilExpiry: 365,
        category: 'Condiments',
        shelfLocation: 'door',
      ),
      Ingredient(
        id: '10',
        emoji: '🥫',
        name: 'Sauce',
        quantity: '300ml',
        daysUntilExpiry: 30,
        category: 'Condiments',
        shelfLocation: 'door',
      ),
    ];
  }

  List<Ingredient> get allIngredients => [
    ..._topShelfItems,
    ..._middleShelfItems,
    ..._bottomShelfItems,
    ..._doorItems,
  ];

  int get expiringCount => allIngredients.where((i) => i.isExpiringSoon).length;

  void _moveIngredient(Ingredient ingredient, String toShelf) {
    setState(() {
      _topShelfItems.removeWhere((i) => i.id == ingredient.id);
      _middleShelfItems.removeWhere((i) => i.id == ingredient.id);
      _bottomShelfItems.removeWhere((i) => i.id == ingredient.id);
      _doorItems.removeWhere((i) => i.id == ingredient.id);

      final updated = ingredient.copyWith(shelfLocation: toShelf);
      switch (toShelf) {
        case 'top':
          _topShelfItems.add(updated);
          break;
        case 'middle':
          _middleShelfItems.add(updated);
          break;
        case 'bottom':
          _bottomShelfItems.add(updated);
          break;
        case 'door':
          _doorItems.add(updated);
          break;
      }
    });
  }

  void _removeIngredient(String id) {
    setState(() {
      _topShelfItems.removeWhere((i) => i.id == id);
      _middleShelfItems.removeWhere((i) => i.id == id);
      _bottomShelfItems.removeWhere((i) => i.id == id);
      _doorItems.removeWhere((i) => i.id == id);
    });
  }

  void _showIngredientDetails(Ingredient ingredient) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildIngredientBottomSheet(ingredient),
    );
  }

  void _showAddIngredientModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAddIngredientSheet(),
    );
  }

  void _showRecipeSuggestions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildRecipeSuggestionsSheet(),
    );
  }

  void _showManualAddForm() {
    Navigator.pop(context); // Close the add ingredient sheet

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildManualAddForm(),
    );
  }

  void _addScannedProduct(Map<String, dynamic> productData) {
    setState(() {
      final newIngredient = Ingredient(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        emoji: productData['emoji'] ?? '🥫',
        name: productData['productName'] ?? 'Produit inconnu',
        quantity: '1',
        daysUntilExpiry: 7,
        category: 'Scanned',
        shelfLocation: 'middle',
      );
      _middleShelfItems.add(newIngredient);
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(productData['emoji'] ?? '🥫'),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${productData['productName'] ?? 'Produit'} ajouté au frigo!',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1F2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F2E),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🧊 My Smart Fridge',
              style: AppleTheme.title2.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              '${allIngredients.length} items • $expiringCount expiring soon',
              style: AppleTheme.caption1.copyWith(color: Colors.white60),
            ),
          ],
        ),
        actions: [
          if (expiringCount > 0)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFF6B35), width: 1),
              ),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.exclamationmark_triangle,
                    color: Color(0xFFFF6B35),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$expiringCount',
                    style: AppleTheme.caption1.copyWith(
                      color: const Color(0xFFFF6B35),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1F2E), Color(0xFF0F1419)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // 3D Fridge Container
              _build3DFridge(),
              const SizedBox(height: 30),
              // Recipe Suggestions Section
              _buildRecipeSuggestionsPreview(),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // AI Recipe Suggestion Button - iOS style
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _showRecipeSuggestions,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                CupertinoIcons.sparkles,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Add Ingredient Button - iOS style
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _showAddIngredientModal,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(CupertinoIcons.add, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Add Item',
                    style: AppleTheme.callout.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // 3D FRIDGE UI METHODS
  // ============================================

  Widget _build3DFridge() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Fridge Frame with 3D perspective
          Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(-0.1),
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2D3748), Color(0xFF1A202C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Fridge Header Light
                  Container(
                    height: 10,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4FD1C5), Color(0xFF38B2AC)],
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                  ),
                  // Fridge Interior
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFFE1F5FE).withOpacity(0.3),
                          const Color(0xFFB3E5FC).withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        // Top Shelf
                        _buildShelf('Top Shelf', _topShelfItems, 'top'),
                        const SizedBox(height: 20),
                        // Middle Shelf
                        _buildShelf(
                          'Middle Shelf',
                          _middleShelfItems,
                          'middle',
                        ),
                        const SizedBox(height: 20),
                        // Bottom Shelf
                        _buildShelf(
                          'Bottom Shelf',
                          _bottomShelfItems,
                          'bottom',
                        ),
                        const SizedBox(height: 20),
                        // Door Compartment
                        _buildShelf('Door', _doorItems, 'door'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShelf(String label, List<Ingredient> items, String shelfId) {
    return DragTarget<Ingredient>(
      onAcceptWithDetails: (details) {
        _moveIngredient(details.data, shelfId);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isHovering
                ? const Color(0xFF8B5CF6).withOpacity(0.2)
                : const Color(0xFFFFFFFF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHovering
                  ? const Color(0xFF8B5CF6)
                  : Colors.white.withOpacity(0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${items.length}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Drop items here',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    )
                  : Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: items
                          .map((item) => _buildDraggableIngredient(item))
                          .toList(),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDraggableIngredient(Ingredient ingredient) {
    return LongPressDraggable<Ingredient>(
      data: ingredient,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.2,
          child: _buildIngredientCard(ingredient, isDragging: true),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildIngredientCard(ingredient),
      ),
      child: GestureDetector(
        onTap: () => _showIngredientDetails(ingredient),
        child: _buildIngredientCard(ingredient),
      ),
    );
  }

  Widget _buildIngredientCard(
    Ingredient ingredient, {
    bool isDragging = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 80,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: ingredient.isExpiringSoon
              ? [const Color(0xFFFF6B35), const Color(0xFFF77F00)]
              : [const Color(0xFFFFFFFF), const Color(0xFFF3F4F6)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDragging
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: isDragging ? 20 : 10,
            offset: isDragging ? const Offset(0, 10) : const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(ingredient.emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 6),
          Text(
            ingredient.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: ingredient.isExpiringSoon
                  ? Colors.white
                  : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          if (ingredient.isExpiringSoon)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${ingredient.daysUntilExpiry}d',
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFF6B35),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRecipeSuggestionsPreview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Recipe Suggestions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Based on your ingredients',
                      style: TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildRecipePreviewCard(
                  '🍝',
                  'Pasta Carbonara',
                  '15 min',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildRecipePreviewCard('🥗', 'Caesar Salad', '10 min'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecipePreviewCard(String emoji, String name, String time) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: const TextStyle(fontSize: 10, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // ============================================
  // BOTTOM SHEETS & MODALS
  // ============================================

  Widget _buildIngredientBottomSheet(Ingredient ingredient) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Text(ingredient.emoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            ingredient.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 24),
          _buildDetailRow(
            Icons.shopping_basket,
            'Quantity',
            ingredient.quantity,
          ),
          _buildDetailRow(
            Icons.calendar_today,
            'Expires in',
            '${ingredient.daysUntilExpiry} days',
          ),
          _buildDetailRow(Icons.category, 'Category', ingredient.category),
          _buildDetailRow(Icons.shelves, 'Location', ingredient.shelfLocation),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _removeIngredient(ingredient.id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text(
                    'Remove',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF8B5CF6)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddIngredientSheet() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Add New Ingredient',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BarcodeScannerPage(),
                ),
              );

              if (result != null && mounted) {
                // Handle scanned product result
                _addScannedProduct(result);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
            label: const Text(
              'Scan Barcode',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _showManualAddForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text(
              'Add Manually',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }

  Widget _buildManualAddForm() {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final daysController = TextEditingController(text: '7');
    String selectedEmoji = '🍎';
    String selectedCategory = 'Fruits';
    String selectedShelf = 'middle';

    final categories = [
      'Fruits',
      'Vegetables',
      'Dairy',
      'Meat',
      'Beverages',
      'Condiments',
      'Snacks',
      'Other',
    ];

    final emojis = [
      '🍎',
      '🍊',
      '🍋',
      '🍌',
      '🍉',
      '🍇',
      '🍓',
      '🥝',
      '🍅',
      '🥕',
      '🥒',
      '🥬',
      '🥦',
      '🌽',
      '🥔',
      '🧄',
      '🧅',
      '🥛',
      '🧀',
      '🥚',
      '🍗',
      '🥩',
      '🍖',
      '🥓',
      '🐟',
      '🍤',
      '🍞',
      '🥐',
      '🥖',
      '🥯',
      '🧃',
      '☕',
      '🥤',
      '🍯',
      '🥫',
      '🧂',
      '🌶️',
      '🍿',
      '🍪',
      '🍰',
    ];

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.add_circle,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Add Ingredient Manually',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Emoji Picker
                const Text(
                  'Choose Icon',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: emojis.length,
                    itemBuilder: (context, index) {
                      final emoji = emojis[index];
                      final isSelected = selectedEmoji == emoji;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            selectedEmoji = emoji;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          width: 60,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF8B5CF6)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF8B5CF6)
                                  : const Color(0xFFE5E7EB),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 32),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Product Name
                const Text(
                  'Product Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'e.g., Milk, Eggs, Chicken...',
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF8B5CF6),
                        width: 2,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.fastfood,
                      color: Color(0xFF8B5CF6),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Quantity
                const Text(
                  'Quantity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    hintText: 'e.g., 1L, 500g, 6 pcs...',
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF8B5CF6),
                        width: 2,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.shopping_basket,
                      color: Color(0xFF8B5CF6),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Days Until Expiry
                const Text(
                  'Expires in (days)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: daysController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Number of days',
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF8B5CF6),
                        width: 2,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: Color(0xFF8B5CF6),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Category
                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((category) {
                    final isSelected = selectedCategory == category;
                    return GestureDetector(
                      onTap: () {
                        setModalState(() {
                          selectedCategory = category;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF8B5CF6)
                              : const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF8B5CF6)
                                : const Color(0xFFE5E7EB),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Shelf Location
                const Text(
                  'Fridge Location',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    _buildShelfOption(
                      'Top Shelf',
                      'top',
                      Icons.vertical_align_top,
                      selectedShelf,
                      (value) => setModalState(() => selectedShelf = value),
                    ),
                    const SizedBox(height: 8),
                    _buildShelfOption(
                      'Middle Shelf',
                      'middle',
                      Icons.horizontal_rule,
                      selectedShelf,
                      (value) => setModalState(() => selectedShelf = value),
                    ),
                    const SizedBox(height: 8),
                    _buildShelfOption(
                      'Bottom Shelf',
                      'bottom',
                      Icons.vertical_align_bottom,
                      selectedShelf,
                      (value) => setModalState(() => selectedShelf = value),
                    ),
                    const SizedBox(height: 8),
                    _buildShelfOption(
                      'Door',
                      'door',
                      Icons.door_front_door,
                      selectedShelf,
                      (value) => setModalState(() => selectedShelf = value),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a product name'),
                          backgroundColor: Color(0xFFEF4444),
                        ),
                      );
                      return;
                    }

                    if (quantityController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a quantity'),
                          backgroundColor: Color(0xFFEF4444),
                        ),
                      );
                      return;
                    }

                    final days = int.tryParse(daysController.text) ?? 7;

                    setState(() {
                      final newIngredient = Ingredient(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        emoji: selectedEmoji,
                        name: nameController.text,
                        quantity: quantityController.text,
                        daysUntilExpiry: days,
                        category: selectedCategory,
                        shelfLocation: selectedShelf,
                      );

                      switch (selectedShelf) {
                        case 'top':
                          _topShelfItems.add(newIngredient);
                          break;
                        case 'middle':
                          _middleShelfItems.add(newIngredient);
                          break;
                        case 'bottom':
                          _bottomShelfItems.add(newIngredient);
                          break;
                        case 'door':
                          _doorItems.add(newIngredient);
                          break;
                      }
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Text(selectedEmoji),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${nameController.text} added to fridge!',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: const Color(0xFF10B981),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    minimumSize: const Size(double.infinity, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Text(
                        'Add to Fridge',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShelfOption(
    String label,
    String value,
    IconData icon,
    String selectedValue,
    Function(String) onSelect,
  ) {
    final isSelected = selectedValue == value;
    return GestureDetector(
      onTap: () => onSelect(value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF8B5CF6).withOpacity(0.1)
              : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF8B5CF6)
                : const Color(0xFFE5E7EB),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF8B5CF6)
                    : const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF8B5CF6)
                    : const Color(0xFF6B7280),
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF8B5CF6),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeSuggestionsSheet() {
    final recipes = [
      {
        'emoji': '🍝',
        'name': 'Pasta Carbonara',
        'time': '15 min',
        'kcal': '480',
      },
      {'emoji': '🥗', 'name': 'Caesar Salad', 'time': '10 min', 'kcal': '320'},
      {'emoji': '🍲', 'name': 'Chicken Soup', 'time': '25 min', 'kcal': '250'},
      {'emoji': '🥪', 'name': 'Club Sandwich', 'time': '8 min', 'kcal': '420'},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Recipe Suggestions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    'Recipes you can make now',
                    style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...recipes.map((recipe) => _buildRecipeCard(recipe)),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(Map<String, String> recipe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFF77F00)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                recipe['emoji']!,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe['name']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      recipe['time']!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.local_fire_department,
                      size: 14,
                      color: Color(0xFFFF6B35),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${recipe['kcal']} kcal',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF6B35),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: Color(0xFF6B7280),
          ),
        ],
      ),
    );
  }
}
