import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';

class RecipeDetailsPopup extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final String emoji;

  const RecipeDetailsPopup({
    required this.recipe,
    this.emoji = '🍽️',
    super.key,
  });

  double _toDouble(dynamic v) => (v as num? ?? 0).toDouble();

  List<String> _parseList(dynamic raw) {
    if (raw is List) return raw.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toList();
    if (raw is String && raw.isNotEmpty) {
      return raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = _parseList(recipe['ingredients']);
    final steps = _parseList(recipe['steps']);
    final name = recipe['name']?.toString() ?? 'Recette';

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
          maxWidth: MediaQuery.of(context).size.width,
        ),
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
            // ── Header ──────────────────────────────────────────────────────
            _Header(name: name, emoji: emoji, context: context),
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

            // ── Footer button ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: CupertinoButton(
                  color: AppColors.primary(context),
                  borderRadius: BorderRadius.circular(14),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Fermer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
