import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/apple_theme.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../fridge/presentation/widgets/recipe_details_popup.dart';
import '../../data/recipes_service.dart';

class RecettesPage extends ConsumerStatefulWidget {
  const RecettesPage({super.key});

  @override
  ConsumerState<RecettesPage> createState() => _RecettesPageState();
}

class _RecettesPageState extends ConsumerState<RecettesPage> {
  final RecipesService _recipesService = RecipesService();

  List<Map<String, dynamic>> _recipes = [];
  bool _loading = true;
  String? _error;

  static const _monthNames = [
    'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
    'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
  ];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  /// [fresh] : true = nouveau tirage aléatoire (bouton actualiser /
  /// pull-to-refresh), false = sélection stable du jour.
  Future<void> _loadRecipes({bool fresh = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final recipes = await _recipesService.getDailyRecipes(
        count: 12,
        seed: fresh ? DateTime.now().millisecondsSinceEpoch.toString() : null,
      );
      if (!mounted) return;
      setState(() {
        _recipes = recipes;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Impossible de charger les recettes du jour.';
        _loading = false;
      });
    }
  }

  Future<void> _refreshRecipes() => _loadRecipes(fresh: true);

  void _openRecipe(Map<String, dynamic> recipe) {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => RecipeDetailsPopup(recipe: recipe),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(locale);
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary(context),
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            backgroundColor:
                AppColors.background(context).withValues(alpha: 0.92),
            border: Border(
              bottom: BorderSide(
                color: AppleTheme.adaptiveSeparator(context)
                    .withValues(alpha: 0.2),
                width: 0.33,
              ),
            ),
            largeTitle: Text(
              l10n.recipesTab,
              style: AppleTheme.largeTitleEmphasized.copyWith(
                color: AppleTheme.adaptiveLabel(context),
              ),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _refreshRecipes,
              child: Icon(
                CupertinoIcons.arrow_2_circlepath,
                color: AppColors.primary(context),
                size: 22,
              ),
            ),
          ),

          CupertinoSliverRefreshControl(onRefresh: _refreshRecipes),

          // En-tête "Recettes du jour"
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient(context),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text('🍽️', style: TextStyle(fontSize: 22)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recettes du jour',
                        style: AppleTheme.title3.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppleTheme.adaptiveLabel(context),
                        ),
                      ),
                      Text(
                        '${now.day} ${_monthNames[now.month - 1]} ${now.year}',
                        style: AppleTheme.footnote.copyWith(
                          color: AppleTheme.adaptiveSecondaryLabel(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (_loading)
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildSkeletonCard(),
                  childCount: 6,
                ),
              ),
            )
          else if (_error != null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('😔', style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: AppleTheme.body.copyWith(
                        color: AppleTheme.adaptiveSecondaryLabel(context),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CupertinoButton(
                      color: AppColors.primary(context),
                      borderRadius: BorderRadius.circular(12),
                      onPressed: _loadRecipes,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildRecipeCard(_recipes[index]),
                  childCount: _recipes.length,
                ),
              ),
            ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
        ],
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(AppleTheme.radiusXLarge),
      ),
      child: const Center(child: CupertinoActivityIndicator()),
    );
  }

  String _titleCase(String name) {
    return name
        .split(' ')
        .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final name = _titleCase(recipe['name']?.toString() ?? 'Recette');
    final minutes = (recipe['minutes'] as num?)?.toInt() ?? 0;
    final calories = (recipe['calories'] as num?)?.toDouble() ?? 0;
    final imageUrl = recipe['image_url']?.toString() ?? '';

    return GestureDetector(
      onTap: () => _openRecipe(recipe),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(AppleTheme.radiusXLarge),
          border: Border.all(
            color: AppColors.divider(context).withValues(alpha: 0.3),
            width: 0.5,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo du plat
            Expanded(
              flex: 3,
              child: SizedBox(
                width: double.infinity,
                child: RecipeImage(
                  imageUrl: imageUrl,
                  height: double.infinity,
                  name: name,
                ),
              ),
            ),
            // Infos
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppleTheme.subheadEmphasized.copyWith(
                        color: AppleTheme.adaptiveLabel(context),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        if (minutes > 0) ...[
                          Icon(
                            CupertinoIcons.clock,
                            size: 13,
                            color: AppleTheme.adaptiveSecondaryLabel(context),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '$minutes min',
                            style: AppleTheme.caption1.copyWith(
                              color:
                                  AppleTheme.adaptiveSecondaryLabel(context),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                        Icon(
                          CupertinoIcons.flame_fill,
                          size: 13,
                          color: AppColors.primary(context),
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            '${calories.toStringAsFixed(0)} kcal',
                            style: AppleTheme.caption1.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary(context),
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
            ),
          ],
        ),
      ),
    );
  }
}
