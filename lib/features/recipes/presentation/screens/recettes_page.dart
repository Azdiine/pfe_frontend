import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/apple_theme.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../core/localization/app_localizations.dart';

class RecettesPage extends ConsumerStatefulWidget {
  const RecettesPage({super.key});

  @override
  ConsumerState<RecettesPage> createState() => _RecettesPageState();
}

class _RecettesPageState extends ConsumerState<RecettesPage> {
  int _selectedCategory = 0;

  Map<int, Widget> _buildCategories(AppLocalizations l10n) {
    return {
      0: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          l10n.all,
          style: AppleTheme.subhead.copyWith(fontWeight: FontWeight.w500),
          maxLines: 1,
        ),
      ),
      1: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          l10n.breakfast,
          style: AppleTheme.subhead.copyWith(fontWeight: FontWeight.w500),
          maxLines: 1,
        ),
      ),
      2: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          l10n.lunch,
          style: AppleTheme.subhead.copyWith(fontWeight: FontWeight.w500),
          maxLines: 1,
        ),
      ),
      3: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          l10n.dinner,
          style: AppleTheme.subhead.copyWith(fontWeight: FontWeight.w500),
          maxLines: 1,
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(locale);
    final categories = _buildCategories(l10n);

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary(context),
      body: CustomScrollView(
        slivers: [
          // iOS 18 Navigation Bar - Plus opaque
          CupertinoSliverNavigationBar(
            backgroundColor: AppColors.background(
              context,
            ).withOpacity(0.92), // iOS 18
            border: Border(
              bottom: BorderSide(
                color: AppleTheme.adaptiveSeparator(
                  context,
                ).withOpacity(0.2), // iOS 18: Plus subtil
                width: 0.33, // iOS 18: Ultra-fin
              ),
            ),
            largeTitle: Text(
              l10n.recipesTab,
              style: AppleTheme.largeTitleEmphasized.copyWith(
                // iOS 18
                color: AppleTheme.adaptiveLabel(context),
              ),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: Icon(
                CupertinoIcons.search,
                color: AppColors.primary(context),
                size: 22,
              ),
            ),
          ),

          // Categories avec CupertinoSegmentedControl iOS 18
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.background(context),
              padding: const EdgeInsets.fromLTRB(
                AppleTheme.spacing20, // iOS 18: 20pt
                AppleTheme.spacing12,
                AppleTheme.spacing20,
                AppleTheme.spacing20, // iOS 18: 20pt
              ),
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: _selectedCategory,
                children: categories,
                onValueChanged: (value) {
                  setState(() {
                    _selectedCategory = value ?? 0;
                  });
                },
                backgroundColor: AppColors.backgroundSecondary(context),
                thumbColor: AppColors.surface(context),
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
                  '${l10n.recipe} ${index + 1}',
                  '${20 + index * 5} ${l10n.minutes}',
                  '${400 + index * 50} ${l10n.kcalUnit}',
                );
              }, childCount: 12),
            ),
          ),
          // Ajouter un padding en bas pour éviter que le contenu ne soit caché par le bottom bar
          const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(String title, String time, String calories) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {},
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(AppleTheme.radiusXLarge),
          border: Border.all(
            color: AppColors.divider(context).withOpacity(0.3),
            width: 0.5,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary(context).withOpacity(0.15),
                      AppColors.primary(context).withOpacity(0.12),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppleTheme.radiusXLarge),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          CupertinoIcons.heart_fill,
                          size: 26,
                          color: AppColors.primary(context).withOpacity(0.6),
                        ),
                      ),
                    ),
                    Positioned(
                      top: AppleTheme.spacing8,
                      right: AppleTheme.spacing8,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.surface(context).withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            CupertinoIcons.bookmark,
                            size: 16,
                            color: AppleTheme.adaptiveLabel(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppleTheme.spacing8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppleTheme.subheadEmphasized.copyWith(
                        color: AppleTheme.adaptiveLabel(context),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.clock,
                          size: 13,
                          color: AppleTheme.adaptiveSecondaryLabel(context),
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            time,
                            style: AppleTheme.caption1.copyWith(
                              color: AppleTheme.adaptiveSecondaryLabel(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          CupertinoIcons.flame_fill,
                          size: 13,
                          color: AppColors.primary(context),
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            calories,
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
