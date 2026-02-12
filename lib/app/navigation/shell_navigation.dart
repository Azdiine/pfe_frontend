import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/apple_theme.dart';

/// 🍎 iOS-Style Navigation Shell avec préservation d'état
/// Système moderne comme App Store - chaque onglet garde son état et sa navigation stack
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    // Déterminer si on est en mode sombre (basé sur la route frigo)
    final currentLocation = GoRouterState.of(context).uri.toString();
    final useDarkTheme = currentLocation.contains('/frigo');

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: useDarkTheme
                  ? AppColors.darkSurface.withOpacity(0.85)
                  : AppleTheme.backgroundLight.withOpacity(0.85),
              border: Border(
                top: BorderSide(
                  color: useDarkTheme
                      ? AppleTheme.separator.withOpacity(0.15)
                      : AppleTheme.separator.withOpacity(0.25),
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppleTheme.spacing8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      context,
                      icon: CupertinoIcons.sparkles, // iOS 18 moderne
                      iconUnselected: CupertinoIcons.circle_grid_3x3_fill,
                      label: 'Accueil',
                      index: 0,
                      useDarkTheme: useDarkTheme,
                    ),
                    _buildNavItem(
                      context,
                      icon: CupertinoIcons.book_circle_fill, // Plus élégant
                      iconUnselected: CupertinoIcons.book_circle,
                      label: 'Recettes',
                      index: 1,
                      useDarkTheme: useDarkTheme,
                    ),
                    _buildNavItem(
                      context,
                      icon: CupertinoIcons
                          .archivebox_fill, // Plus moderne que cube
                      iconUnselected: CupertinoIcons.archivebox,
                      label: 'Frigo',
                      index: 2,
                      useDarkTheme: useDarkTheme,
                    ),
                    _buildNavItem(
                      context,
                      icon: CupertinoIcons.graph_circle_fill, // iOS 18 élégant
                      iconUnselected: CupertinoIcons.graph_circle,
                      label: 'Suivi',
                      index: 3,
                      useDarkTheme: useDarkTheme,
                    ),
                    _buildNavItem(
                      context,
                      icon: CupertinoIcons
                          .person_crop_circle_fill, // Plus élégant avec cercle
                      iconUnselected: CupertinoIcons.person_crop_circle,
                      label: 'Profil',
                      index: 4,
                      useDarkTheme: useDarkTheme,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData iconUnselected,
    required String label,
    required int index,
    required bool useDarkTheme,
  }) {
    final isSelected = navigationShell.currentIndex == index;

    // iOS system colors pour les tabs
    final selectedColor = useDarkTheme
        ? AppColors.darkAccent
        : AppColors.lightPrimary;

    final unselectedColor = useDarkTheme
        ? AppleTheme.secondaryLabel
        : AppleTheme.secondaryLabel;

    return Expanded(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => _onTap(context, index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? icon : iconUnselected,
              color: isSelected ? selectedColor : unselectedColor,
              size: 26, // iOS 18: Icônes plus grandes (26pt)
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppleTheme.caption2.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? selectedColor : unselectedColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    // Navigation avec préservation d'état iOS-style
    // Si on clique sur l'onglet actif, on remonte à la racine de cet onglet
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
