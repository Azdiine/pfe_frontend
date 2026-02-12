import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../application/profile_provider.dart';
import '../../../auth/application/auth_provider.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/apple_theme.dart';

/// 🎨 Profile Screen 2026 - Modern Premium Design
/// Complete redesign with harmonious color palette
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileProvider.notifier).loadProfile();
    });
  }

  void _handleLogout() async {
    final shouldLogout = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      await ref.read(authProvider.notifier).logout();
      if (mounted) {
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final authState = ref.watch(authProvider);

    return CupertinoPageScaffold(
      backgroundColor: AppColors.lightBackground,
      child: profileState.isLoading
          ? const LoadingIndicator(message: 'Chargement du profil...')
          : profileState.hasError
          ? EmptyState(
              icon: Icons.error_outline,
              title: 'Erreur',
              message: profileState.error,
              actionText: 'Réessayer',
              onAction: () {
                ref.read(profileProvider.notifier).loadProfile();
              },
            )
          : CustomScrollView(
              slivers: [
                // Modern App Bar with Glassmorphism
                SliverAppBar(
                  expandedHeight: 0,
                  floating: true,
                  pinned: true,
                  backgroundColor: Colors.white.withOpacity(0.8),
                  elevation: 0,
                  flexibleSpace: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(color: Colors.white.withOpacity(0.8)),
                    ),
                  ),
                  title: Text(
                    'Profil',
                    style: AppleTheme.headline.copyWith(
                      color: AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  actions: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.lightFreshGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.lightPrimary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'Modifier',
                          style: AppleTheme.subhead.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 12),
                  ],
                ),

                // Content
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Premium Header with Gradient Background
                      _buildPremiumHeader(authState),

                      const SizedBox(height: 24),

                      // Stats Cards Row
                      _buildStatsRow(),

                      const SizedBox(height: 32),

                      // Activity Section
                      _buildActivitySection(),

                      const SizedBox(height: 32),

                      // Settings Section
                      _buildSettingsSection(),

                      const SizedBox(height: 32),

                      // Logout Button
                      _buildLogoutButton(),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  /// Premium Header with Gradient Background
  Widget _buildPremiumHeader(authState) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: AppColors.lightPremiumGradient, // Teal to Indigo
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightPrimary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with White Border
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 48,
              backgroundColor: Colors.white,
              child: Text(
                authState.user?.name.substring(0, 1).toUpperCase() ?? 'U',
                style: AppleTheme.largeTitle.copyWith(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: AppColors.lightSecondary, // Indigo
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Name
          Text(
            authState.user?.name ?? 'User',
            style: AppleTheme.title1.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          // Email with Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.mail_solid,
                size: 14,
                color: Colors.white.withOpacity(0.9),
              ),
              const SizedBox(width: 6),
              Text(
                authState.user?.email ?? 'email@example.com',
                style: AppleTheme.callout.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Member Since Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  CupertinoIcons.star_fill,
                  size: 14,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  'Membre depuis février 2026',
                  style: AppleTheme.footnote.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Stats Cards Row - 3 cards with different colors
  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: CupertinoIcons.flame_fill,
              value: '7',
              label: 'Jours',
              subtitle: 'Streak',
              color: AppColors.lightAccent, // Amber
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: CupertinoIcons.heart_fill,
              value: '42',
              label: 'Recettes',
              subtitle: 'Favorites',
              color: AppColors.lightSecondary, // Indigo
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: CupertinoIcons.chart_bar_fill,
              value: '89%',
              label: 'Objectif',
              subtitle: 'Atteint',
              color: AppColors.lightPrimary, // Teal
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppleTheme.title2.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppleTheme.caption1.copyWith(
              color: AppColors.lightTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: AppleTheme.caption2.copyWith(
              color: AppColors.lightTextTertiary,
            ),
          ),
        ],
      ),
    );
  }

  /// Activity Section with Timeline
  Widget _buildActivitySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activité Récente',
                style: AppleTheme.title3.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.lightTextPrimary,
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(
                  'Voir tout',
                  style: AppleTheme.subhead.copyWith(
                    color: AppColors.lightPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildActivityItem(
                  icon: CupertinoIcons.checkmark_seal_fill,
                  title: 'Objectif quotidien atteint',
                  time: 'Il y a 2 heures',
                  color: AppColors.success,
                ),
                _buildActivityDivider(),
                _buildActivityItem(
                  icon: CupertinoIcons.book_fill,
                  title: 'Nouvelle recette ajoutée',
                  time: 'Hier',
                  color: AppColors.lightAccent,
                ),
                _buildActivityDivider(),
                _buildActivityItem(
                  icon: CupertinoIcons.heart_fill,
                  title: '5 recettes mises en favoris',
                  time: 'Il y a 3 jours',
                  color: AppColors.lightSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String time,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppleTheme.subhead.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: AppleTheme.caption1.copyWith(
                    color: AppColors.lightTextTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 68),
      color: AppColors.lightDivider,
    );
  }

  /// Settings Section
  Widget _buildSettingsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paramètres',
            style: AppleTheme.title3.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSettingsItem(
                  icon: CupertinoIcons.person_circle_fill,
                  title: 'Informations personnelles',
                  color: AppColors.lightPrimary,
                  onTap: () {},
                ),
                _buildActivityDivider(),
                _buildSettingsItem(
                  icon: CupertinoIcons.lock_shield_fill,
                  title: 'Sécurité et confidentialité',
                  color: AppColors.lightSecondary,
                  onTap: () {},
                ),
                _buildActivityDivider(),
                _buildSettingsItem(
                  icon: CupertinoIcons.bell_fill,
                  title: 'Notifications',
                  color: AppColors.lightAccent,
                  onTap: () {},
                ),
                _buildActivityDivider(),
                _buildSettingsItem(
                  icon: CupertinoIcons.question_circle_fill,
                  title: 'Aide et support',
                  color: AppColors.info,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: const EdgeInsets.all(16),
      onPressed: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppleTheme.subhead.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.lightTextPrimary,
              ),
            ),
          ),
          Icon(
            CupertinoIcons.chevron_right,
            size: 20,
            color: AppColors.lightTextTertiary,
          ),
        ],
      ),
    );
  }

  /// Logout Button with Modern Design
  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: _handleLogout,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.error.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.arrow_right_square,
                color: AppColors.error,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'Se déconnecter',
                style: AppleTheme.headline.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
