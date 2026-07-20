import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/language_selector.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/localization/app_localizations.dart';

/// 🍎 Modern Navigation Shell — 2026 Floating Tab Bar
class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(locale);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: AppBar(
              backgroundColor: isDark
                  ? AppColors.darkBackground.withValues(alpha: 0.80)
                  : AppColors.lightBackground.withValues(alpha: 0.80),
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              leadingWidth: 80,
              leading: const CompactLanguageSelector(),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient(context),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'MEATAY',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0.5),
                child: Container(
                  height: 0.5,
                  color: AppColors.divider(context).withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ),
      ),
      body: navigationShell,
      bottomNavigationBar: _ModernBottomBar(
        currentIndex: navigationShell.currentIndex,
        isDark: isDark,
        labels: [
          l10n.home,
          l10n.recipesTab,
          l10n.fridge,
          l10n.tracking,
          l10n.profileTab,
        ],
        onTap: (index) => _onTap(context, index),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

/// Modern floating bottom bar with pill indicator
class _ModernBottomBar extends StatelessWidget {
  const _ModernBottomBar({
    required this.currentIndex,
    required this.isDark,
    required this.labels,
    required this.onTap,
  });

  final int currentIndex;
  final bool isDark;
  final List<String> labels;
  final ValueChanged<int> onTap;

  static const _icons = [
    CupertinoIcons.house_fill,
    CupertinoIcons.book_fill,
    CupertinoIcons.cube_box_fill,
    CupertinoIcons.chart_bar_fill,
    CupertinoIcons.person_fill,
  ];

  static const _iconsOutlined = [
    CupertinoIcons.house,
    CupertinoIcons.book,
    CupertinoIcons.cube_box,
    CupertinoIcons.chart_bar,
    CupertinoIcons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkBackground.withValues(alpha: 0.85)
                : AppColors.lightBackground.withValues(alpha: 0.85),
            border: Border(
              top: BorderSide(
                color: AppColors.divider(context).withValues(alpha: 0.2),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: List.generate(5, (index) {
                  final isSelected = currentIndex == index;
                  return Expanded(
                    child: Semantics(
                      label: labels[index],
                      button: true,
                      selected: isSelected,
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          onTap(index);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOutCubic,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSelected ? 16 : 0,
                                  vertical: isSelected ? 6 : 0,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary(
                                          context,
                                        ).withValues(alpha: 0.12)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  isSelected
                                      ? _icons[index]
                                      : _iconsOutlined[index],
                                  color: isSelected
                                      ? AppColors.primary(context)
                                      : AppColors.textTertiary(context),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                labels[index],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? AppColors.primary(context)
                                      : AppColors.textTertiary(context),
                                  letterSpacing: 0.1,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
