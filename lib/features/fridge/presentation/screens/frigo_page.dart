import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/apple_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/ingredient_model.dart';
import 'barcode_scanner_page.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../core/localization/app_localizations.dart';

class FrigoPage extends ConsumerStatefulWidget {
  const FrigoPage({super.key});

  @override
  ConsumerState<FrigoPage> createState() => _FrigoPageState();
}

class _FrigoPageState extends ConsumerState<FrigoPage> {
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
      isScrollControlled: true,
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
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(locale);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.mySmartFridge,
              style: AppleTheme.title2.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary(context),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${l10n.itemsCount(allIngredients.length)} • ${l10n.itemsExpiringSoon(expiringCount)}',
              style: AppleTheme.caption1.copyWith(
                color: AppColors.textSecondary(context),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          if (expiringCount > 0)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.warning, width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.exclamationmark_triangle,
                    color: AppColors.warning,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$expiringCount',
                    style: AppleTheme.caption1.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.depthGradient(context)),
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
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 60,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // AI Recipe Suggestion Button
            Semantics(
              label: 'Recipe suggestions',
              button: true,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _showRecipeSuggestions,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.surface(context),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.divider(context).withOpacity(0.3),
                      width: 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    CupertinoIcons.sparkles,
                    color: AppColors.secondary(context),
                    size: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Add Ingredient Button - Round
            Semantics(
              label: 'Add ingredient',
              button: true,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _showAddIngredientModal,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary(context),
                        AppColors.primary(context).withOpacity(0.85),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary(context).withOpacity(0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    CupertinoIcons.add,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _build3DFridge() {
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(locale);

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
                gradient: LinearGradient(
                  colors: [
                    AppColors.surfaceElevated(context),
                    AppColors.surface(context),
                  ],
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
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient(context),
                      borderRadius: const BorderRadius.vertical(
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
                          AppColors.primary(context).withOpacity(0.1),
                          AppColors.primary(context).withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        // Top Shelf
                        _buildShelf(l10n.topShelf, _topShelfItems, 'top'),
                        const SizedBox(height: 20),
                        // Middle Shelf
                        _buildShelf(
                          l10n.middleShelf,
                          _middleShelfItems,
                          'middle',
                        ),
                        const SizedBox(height: 20),
                        // Bottom Shelf
                        _buildShelf(
                          l10n.bottomShelf,
                          _bottomShelfItems,
                          'bottom',
                        ),
                        const SizedBox(height: 20),
                        // Door Compartment
                        _buildShelf(l10n.door, _doorItems, 'door'),
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
                ? AppColors.secondary(context).withOpacity(0.2)
                : AppColors.surface(context).withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHovering
                  ? AppColors.secondary(context)
                  : AppColors.divider(context),
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
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary(context),
                      shadows: const [
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
                      color: AppColors.secondary(context),
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
              ? [AppColors.warning, AppColors.warning]
              : [
                  AppColors.surface(context),
                  AppColors.surfaceElevated(context),
                ],
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
                  : AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 4),
          if (ingredient.isExpiringSoon)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.surface(context),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${ingredient.daysUntilExpiry}d',
                style: AppleTheme.caption2.copyWith(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.warning,
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
        gradient: AppColors.aiGradient(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary(context).withOpacity(0.4),
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
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final locale = ref.watch(localeProvider);
                    final l10n = AppLocalizations.of(locale);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.aiRecipeSuggestions,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          l10n.basedOnYourIngredients,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final locale = ref.watch(localeProvider);
                    final l10n = AppLocalizations.of(locale);
                    return _buildRecipePreviewCard(
                      '🍝',
                      l10n.pastaCarbonara,
                      '15 ${l10n.minutes}',
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final locale = ref.watch(localeProvider);
                    final l10n = AppLocalizations.of(locale);
                    return _buildRecipePreviewCard(
                      '🥗',
                      l10n.caesarSalad,
                      '10 ${l10n.minutes}',
                    );
                  },
                ),
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
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(locale);

    return Container(
      padding: const EdgeInsets.all(AppleTheme.spacing24),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider(context),
              borderRadius: BorderRadius.circular(AppleTheme.radiusSmall),
            ),
          ),
          const SizedBox(height: AppleTheme.spacing20),
          Text(ingredient.emoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: AppleTheme.spacing16),
          Text(
            ingredient.name,
            style: AppleTheme.title2.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 24),
          _buildDetailRow(
            CupertinoIcons.cube_box,
            l10n.quantity,
            ingredient.quantity,
          ),
          _buildDetailRow(
            CupertinoIcons.calendar,
            l10n.expiresIn,
            l10n.expiringDays(ingredient.daysUntilExpiry),
          ),
          _buildDetailRow(
            CupertinoIcons.tag,
            l10n.category,
            ingredient.category,
          ),
          _buildDetailRow(
            CupertinoIcons.square_grid_2x2,
            l10n.location,
            ingredient.shelfLocation,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pop(context);
                    _removeIngredient(ingredient.id);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.trash,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.remove,
                          style: AppleTheme.callout.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.secondary(context),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.pencil,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.edit,
                          style: AppleTheme.callout.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
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
              color: AppColors.secondary(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: AppColors.secondary(context)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary(context),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
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
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(locale);

    return Container(
      padding: const EdgeInsets.all(AppleTheme.spacing24),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider(context),
              borderRadius: BorderRadius.circular(AppleTheme.radiusSmall),
            ),
          ),
          const SizedBox(height: AppleTheme.spacing20),
          Text(
            l10n.addNewIngredient,
            style: AppleTheme.title2.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 24),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              Navigator.pop(context);
              final result = await Navigator.of(context, rootNavigator: true).push(
                PageRouteBuilder(
                  opaque: true,
                  barrierDismissible: false,
                  barrierColor: Colors.black,
                  fullscreenDialog: true,
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const BarcodeScannerPage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );

              if (result != null && mounted) {
                _addScannedProduct(result);
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.warning,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.barcode_viewfinder,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.scanBarcode,
                    style: AppleTheme.callout.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _showManualAddForm,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.secondary(context),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.pencil,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.addManually,
                    style: AppleTheme.callout.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }

  Widget _buildManualAddForm() {
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(locale);

    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final daysController = TextEditingController(text: '7');
    String selectedEmoji = '🍎';
    String selectedCategory = l10n.fruits;
    String selectedShelf = 'middle';

    final categories = [
      l10n.fruits,
      l10n.vegetables,
      l10n.dairy,
      l10n.meat,
      l10n.beverages,
      l10n.condiments,
      l10n.snacks,
      l10n.other,
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
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider(context),
                      borderRadius: BorderRadius.circular(
                        AppleTheme.radiusSmall,
                      ),
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
                        gradient: AppColors.aiGradient(context),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.add_circle,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        l10n.addIngredientManually,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Emoji Picker
                Text(
                  l10n.chooseIcon,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.surface(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider(context)),
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
                                ? AppColors.secondary(context)
                                : AppColors.surface(context),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.secondary(context)
                                  : AppColors.divider(context),
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

                // Nom du Produit
                Text(
                  l10n.productName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: l10n.productNameHint,
                    filled: true,
                    fillColor: AppColors.surface(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.divider(context)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.divider(context)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.secondary(context),
                        width: 2,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.fastfood,
                      color: AppColors.secondary(context),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Quantité
                Text(
                  l10n.quantity,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    hintText: l10n.quantityHint,
                    filled: true,
                    fillColor: AppColors.surface(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.divider(context)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.divider(context)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.secondary(context),
                        width: 2,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.shopping_basket,
                      color: AppColors.secondary(context),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Expire dans (jours)
                Text(
                  l10n.expiresIn,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: daysController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: l10n.numberOfDays,
                    filled: true,
                    fillColor: AppColors.surface(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.divider(context)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.divider(context)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.secondary(context),
                        width: 2,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: AppColors.secondary(context),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Catégorie
                Text(
                  l10n.category,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
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
                              ? AppColors.secondary(context)
                              : AppColors.surface(context),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.secondary(context)
                                : AppColors.divider(context),
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
                                : AppColors.textSecondary(context),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Emplacement du Frigo
                Text(
                  l10n.fridgeLocation,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    _buildShelfOption(
                      l10n.topShelf,
                      'top',
                      Icons.vertical_align_top,
                      selectedShelf,
                      (value) => setModalState(() => selectedShelf = value),
                    ),
                    const SizedBox(height: 8),
                    _buildShelfOption(
                      l10n.middleShelf,
                      'middle',
                      Icons.horizontal_rule,
                      selectedShelf,
                      (value) => setModalState(() => selectedShelf = value),
                    ),
                    const SizedBox(height: 8),
                    _buildShelfOption(
                      l10n.bottomShelf,
                      'bottom',
                      Icons.vertical_align_bottom,
                      selectedShelf,
                      (value) => setModalState(() => selectedShelf = value),
                    ),
                    const SizedBox(height: 8),
                    _buildShelfOption(
                      l10n.door,
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
                        SnackBar(
                          content: Text(l10n.enterProductName),
                          backgroundColor: AppColors.error,
                        ),
                      );
                      return;
                    }

                    if (quantityController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.enterQuantity),
                          backgroundColor: AppColors.error,
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
                                '${nameController.text} ${l10n.addedToFridge}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary(context),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    minimumSize: const Size(double.infinity, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 12),
                      Text(
                        l10n.addToFridge,
                        style: const TextStyle(
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
              ? AppColors.secondary(context).withOpacity(0.1)
              : AppColors.surface(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.secondary(context)
                : AppColors.divider(context),
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
                    ? AppColors.secondary(context)
                    : AppColors.divider(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : AppColors.textSecondary(context),
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
                    ? AppColors.secondary(context)
                    : AppColors.textSecondary(context),
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.secondary(context),
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
        'name': 'Pâtes Carbonara',
        'time': '15 min',
        'kcal': '480',
      },
      {'emoji': '🥗', 'name': 'Salade César', 'time': '10 min', 'kcal': '320'},
      {
        'emoji': '🍲',
        'name': 'Soupe au Poulet',
        'time': '25 min',
        'kcal': '250',
      },
      {'emoji': '🥪', 'name': 'Sandwich Club', 'time': '8 min', 'kcal': '420'},
    ];

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider(context),
              borderRadius: BorderRadius.circular(AppleTheme.radiusSmall),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: AppColors.aiGradient(context),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Suggestions de Recettes IA',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    Text(
                      'Recettes que vous pouvez faire maintenant',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                ...recipes.map((recipe) => _buildRecipeCard(recipe)),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(Map<String, String> recipe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider(context), width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.warning, AppColors.warning],
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textSecondary(context),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        recipe['time']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.local_fire_department,
                      size: 14,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${recipe['kcal']} kcal',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.warning,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: AppColors.textSecondary(context),
          ),
        ],
      ),
    );
  }
}
