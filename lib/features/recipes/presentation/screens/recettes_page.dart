import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/apple_theme.dart';

class RecettesPage extends StatefulWidget {
  const RecettesPage({super.key});

  @override
  State<RecettesPage> createState() => _RecettesPageState();
}

class _RecettesPageState extends State<RecettesPage> {
  int _selectedCategory = 0;

  final Map<int, Widget> _categories = {
    0: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        'Tous',
        style: AppleTheme.subhead.copyWith(fontWeight: FontWeight.w500),
        maxLines: 1,
      ),
    ),
    1: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        'Petit-déj',
        style: AppleTheme.subhead.copyWith(fontWeight: FontWeight.w500),
        maxLines: 1,
      ),
    ),
    2: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        'Déjeuner',
        style: AppleTheme.subhead.copyWith(fontWeight: FontWeight.w500),
        maxLines: 1,
      ),
    ),
    3: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        'Dîner',
        style: AppleTheme.subhead.copyWith(fontWeight: FontWeight.w500),
        maxLines: 1,
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppleTheme.secondaryBackgroundLight,
      body: CustomScrollView(
        slivers: [
          // iOS 18 Navigation Bar - Plus opaque
          CupertinoSliverNavigationBar(
            backgroundColor: AppleTheme.backgroundLight.withOpacity(
              0.92,
            ), // iOS 18
            border: Border(
              bottom: BorderSide(
                color: AppleTheme.separator.withOpacity(
                  0.2,
                ), // iOS 18: Plus subtil
                width: 0.33, // iOS 18: Ultra-fin
              ),
            ),
            largeTitle: Text(
              'Recettes',
              style: AppleTheme.largeTitleEmphasized.copyWith(
                // iOS 18
                color: AppleTheme.label,
              ),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 0,
              onPressed: () {},
              child: const Icon(
                CupertinoIcons.search,
                color: AppColors.lightPrimary,
                size: 22,
              ),
            ),
          ),

          // Categories avec CupertinoSegmentedControl iOS 18
          SliverToBoxAdapter(
            child: Container(
              color: AppleTheme.backgroundLight,
              padding: const EdgeInsets.fromLTRB(
                AppleTheme.spacing20, // iOS 18: 20pt
                AppleTheme.spacing12,
                AppleTheme.spacing20,
                AppleTheme.spacing20, // iOS 18: 20pt
              ),
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: _selectedCategory,
                children: _categories,
                onValueChanged: (value) {
                  setState(() {
                    _selectedCategory = value ?? 0;
                  });
                },
                backgroundColor: AppleTheme.secondaryBackgroundLight,
                thumbColor: AppleTheme.backgroundLight,
                padding: const EdgeInsets.all(4),
              ),
            ),
          ),

          // Recipes Grid iOS 18 Style - Spacing généreux
          SliverPadding(
            padding: const EdgeInsets.all(AppleTheme.spacing20), // iOS 18: 20pt
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppleTheme.spacing16, // iOS 18: 16pt
                mainAxisSpacing: AppleTheme.spacing16,
                childAspectRatio:
                    0.72, // iOS 18: Plus de hauteur pour éviter overflow
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildRecipeCard(
                  'Recette ${index + 1}',
                  '${20 + index * 5} min',
                  '${400 + index * 50} kcal',
                );
              }, childCount: 12),
            ),
          ),
          // Ajouter un padding en bas pour éviter que le contenu ne soit caché par le bottom bar
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(String title, String time, String calories) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {},
      child: Container(
        decoration: BoxDecoration(
          color: AppleTheme.backgroundLight,
          borderRadius: BorderRadius.circular(AppleTheme.radiusCard),
          border: Border.all(
            color: AppleTheme.separator.withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.lightFoodGradient,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppleTheme.radiusCard),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        CupertinoIcons.square_fill_on_square_fill,
                        size: 50,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppleTheme.backgroundLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          CupertinoIcons.heart,
                          size: 16,
                          color: AppleTheme.label,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(
                AppleTheme.spacing8,
              ), // iOS 18: Réduit pour éviter overflow
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppleTheme.subhead.copyWith(
                      // iOS 18: Subhead (15pt) au lieu de callout (16pt)
                      fontWeight: FontWeight.w700,
                      color: AppleTheme.label,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6), // iOS 18: Espacement optimisé
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.clock,
                        size: 14,
                        color: AppleTheme.secondaryLabel,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: AppleTheme.caption1.copyWith(
                          color: AppleTheme.secondaryLabel,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.flame_fill,
                        size: 14,
                        color: AppColors.lightSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        calories,
                        style: AppleTheme.caption1.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightSecondary,
                        ),
                      ),
                    ],
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
