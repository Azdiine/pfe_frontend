import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../tracking/data/tracking_service.dart';
import '../../../tracking/presentation/widgets/meal_type_picker.dart';

class RecipeDetailsPopup extends StatefulWidget {
  final Map<String, dynamic> recipe;
  final String emoji;

  const RecipeDetailsPopup({
    required this.recipe,
    this.emoji = '🍽️',
    super.key,
  });

  @override
  State<RecipeDetailsPopup> createState() => _RecipeDetailsPopupState();
}

class _RecipeDetailsPopupState extends State<RecipeDetailsPopup> {
  final TrackingService _trackingService = TrackingService();
  bool _addingMeal = false;
  bool _mealAdded = false;

  Map<String, dynamic> get recipe => widget.recipe;

  double _toDouble(dynamic v) => (v as num? ?? 0).toDouble();

  List<String> _parseList(dynamic raw) {
    if (raw is List) return raw.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toList();
    if (raw is String && raw.isNotEmpty) {
      return raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    return [];
  }

  Future<void> _addToTracking() async {
    if (_addingMeal || _mealAdded) return;
    HapticFeedback.mediumImpact();

    // Choix du repas : petit-déjeuner / déjeuner / dîner / collation
    final mealType = await showMealTypePicker(context);
    if (mealType == null || !mounted) return;

    setState(() => _addingMeal = true);

    try {
      await _trackingService.addMeal(
        calories: _toDouble(recipe['calories']),
        proteinsG: _toDouble(recipe['proteins_g']),
        carbsG: _toDouble(recipe['carbs_g']),
        fatsG: _toDouble(recipe['fats_g']),
        mealType: mealType,
        name: recipe['name']?.toString(),
        source: 'recipe',
      );
      if (!mounted) return;
      setState(() {
        _addingMeal = false;
        _mealAdded = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ Ajouté au ${MealTypes.label(mealType).toLowerCase()} '
            '(${_toDouble(recipe['calories']).toStringAsFixed(0)} kcal)',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _addingMeal = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible d\'ajouter au suivi, réessayez.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = _parseList(recipe['ingredients']);
    final steps = _parseList(recipe['steps']);
    final name = recipe['name']?.toString() ?? 'Recette';
    final imageUrl = recipe['image_url']?.toString();

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.background(context),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.18),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Photo du plat ────────────────────────────────────────────────
            if (imageUrl != null && imageUrl.isNotEmpty)
              RecipeImage(imageUrl: imageUrl, height: 170, name: name),

            // ── Header ──────────────────────────────────────────────────────
            _Header(name: name, emoji: widget.emoji, context: context),
            Divider(height: 1, color: AppColors.divider(context)),

            // ── Scrollable body ──────────────────────────────────────────────
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _NutritionRow(recipe: recipe, toDouble: _toDouble),
                    const SizedBox(height: 16),
                    _InfoRow(recipe: recipe),
                    const SizedBox(height: 20),
                    if (ingredients.isNotEmpty) ...[
                      _SectionTitle(title: 'Ingrédients', count: ingredients.length),
                      const SizedBox(height: 10),
                      _IngredientsList(ingredients: ingredients, context: context),
                      const SizedBox(height: 20),
                    ],
                    if (steps.isNotEmpty) ...[
                      _SectionTitle(title: 'Étapes', count: steps.length),
                      const SizedBox(height: 10),
                      _StepsList(steps: steps, context: context),
                    ],
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // ── Footer buttons ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        color: _mealAdded
                            ? AppColors.success
                            : AppColors.primary(context),
                        borderRadius: BorderRadius.circular(14),
                        onPressed: _addToTracking,
                        child: _addingMeal
                            ? const CupertinoActivityIndicator(
                                color: Colors.white)
                            : Text(
                                _mealAdded
                                    ? '✓ Ajouté au suivi'
                                    : '🍽️ Ajouter à mon suivi',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 50,
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      color: AppColors.surface(context),
                      borderRadius: BorderRadius.circular(14),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Fermer',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Photo de recette (placeholder, retry automatique, fallback) ─────────────

class RecipeImage extends StatefulWidget {
  final String imageUrl;
  final double height;
  final String name;
  final BorderRadius? borderRadius;

  const RecipeImage({
    required this.imageUrl,
    required this.height,
    required this.name,
    this.borderRadius,
    super.key,
  });

  @override
  State<RecipeImage> createState() => _RecipeImageState();
}

class _RecipeImageState extends State<RecipeImage> {
  // La 1re requête pollinations peut expirer pendant la génération de
  // l'image ; on retente automatiquement (l'image est alors en cache serveur).
  static const int _maxRetries = 2;
  int _attempt = 0;
  bool _waitingRetry = false;

  String get _url {
    if (_attempt == 0) return widget.imageUrl;
    final sep = widget.imageUrl.contains('?') ? '&' : '?';
    return '${widget.imageUrl}${sep}r=$_attempt';
  }

  void _scheduleRetry() {
    if (_attempt >= _maxRetries || _waitingRetry) return;
    _waitingRetry = true;
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      setState(() {
        _attempt++;
        _waitingRetry = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget placeholder = Container(
      height: widget.height,
      width: double.infinity,
      color: AppColors.surface(context),
      child: const Center(child: CupertinoActivityIndicator()),
    );

    Widget fallback = Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary(context).withValues(alpha: 0.25),
            AppColors.primary(context).withValues(alpha: 0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(child: Text('🍽️', style: TextStyle(fontSize: 42))),
    );

    final image = Image.network(
      _url,
      height: widget.height,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return placeholder;
      },
      errorBuilder: (context, error, stack) {
        if (_attempt < _maxRetries) {
          _scheduleRetry();
          return placeholder;
        }
        return fallback;
      },
    );

    if (widget.borderRadius != null) {
      return ClipRRect(borderRadius: widget.borderRadius!, child: image);
    }
    return image;
  }
}

// ── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final String name;
  final String emoji;
  final BuildContext context;

  const _Header({required this.name, required this.emoji, required this.context});

  @override
  Widget build(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary(context).withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => Navigator.pop(ctx),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.surface(context),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 18, color: AppColors.textSecondary(context)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Nutrition row (4 cards) ──────────────────────────────────────────────────

class _NutritionRow extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final double Function(dynamic) toDouble;

  const _NutritionRow({required this.recipe, required this.toDouble});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': '🔥', 'label': 'Calories', 'value': '${toDouble(recipe['calories']).toStringAsFixed(0)}\nkcal'},
      {'icon': '💪', 'label': 'Protéines', 'value': '${toDouble(recipe['proteins_g']).toStringAsFixed(1)}g'},
      {'icon': '🌾', 'label': 'Glucides', 'value': '${toDouble(recipe['carbs_g']).toStringAsFixed(1)}g'},
      {'icon': '🥑', 'label': 'Graisses', 'value': '${toDouble(recipe['fats_g']).toStringAsFixed(1)}g'},
    ];

    return Row(
      children: items.map((item) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: item != items.last ? 8 : 0),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            decoration: BoxDecoration(
              color: AppColors.surface(context),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.divider(context)),
            ),
            child: Column(
              children: [
                Text(item['icon']!, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 6),
                Text(
                  item['value']!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                const SizedBox(height: 2),
                Text(
                  item['label']!,
                  style: TextStyle(fontSize: 10, color: AppColors.textSecondary(context)),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Info row (prep / cook / difficulty) ─────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const _InfoRow({required this.recipe});

  String _difficulty(dynamic raw) {
    final s = raw?.toString() ?? '';
    if (s.isEmpty || s == 'nan') return 'N/A';
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final chips = [
      {'icon': '⏱️', 'label': 'Prép', 'value': '${recipe['prep_time_min'] ?? 0} min'},
      {'icon': '🍳', 'label': 'Cuisson', 'value': '${recipe['cook_time_min'] ?? 0} min'},
      {'icon': '⭐', 'label': 'Difficulté', 'value': _difficulty(recipe['difficulty'])},
    ];

    return Row(
      children: chips.map((chip) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: chip != chips.last ? 8 : 0),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.primary(context).withValues(alpha:0.07),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(chip['icon']!, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 4),
                Text(
                  chip['value']!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  chip['label']!,
                  style: TextStyle(fontSize: 10, color: AppColors.textSecondary(context)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Section title ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  final int count;

  const _SectionTitle({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primary(context).withValues(alpha:0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary(context),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Ingredients list ─────────────────────────────────────────────────────────

class _IngredientsList extends StatelessWidget {
  final List<String> ingredients;
  final BuildContext context;

  const _IngredientsList({required this.ingredients, required this.context});

  @override
  Widget build(BuildContext ctx) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ingredients.map((ing) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider(context)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline, size: 14, color: AppColors.primary(context)),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  ing,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary(context),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── Steps list ───────────────────────────────────────────────────────────────

class _StepsList extends StatelessWidget {
  final List<String> steps;
  final BuildContext context;

  const _StepsList({required this.steps, required this.context});

  @override
  Widget build(BuildContext ctx) {
    return Column(
      children: List.generate(steps.length, (i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primary(context),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    steps[i],
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary(context),
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
