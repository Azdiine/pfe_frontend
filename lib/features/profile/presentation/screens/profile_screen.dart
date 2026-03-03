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
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import 'personal_info_page.dart';
import 'security_privacy_page.dart';
import 'notifications_settings_page.dart';
import 'help_support_page.dart';

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
    final locale = ref.read(localeProvider);
    final l10n = AppLocalizations.of(locale);

    final shouldLogout = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(l10n.logoutTitle),
        content: Text(l10n.logoutMessage),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.logout),
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
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(locale);

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background(context),
      child: profileState.isLoading
          ? LoadingIndicator(message: l10n.loadingProfile)
          : profileState.hasError
          ? EmptyState(
              icon: Icons.error_outline,
              title: l10n.error,
              message: profileState.error,
              actionText: l10n.retry,
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
                  backgroundColor: AppColors.surface(context).withOpacity(0.8),
                  elevation: 0,
                  flexibleSpace: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: AppColors.surface(context).withOpacity(0.8),
                      ),
                    ),
                  ),
                  title: Text(
                    l10n.profile,
                    style: AppleTheme.headline.copyWith(
                      color: AppColors.textPrimary(context),
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
                          gradient: AppColors.primaryGradient(context),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary(
                                context,
                              ).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          l10n.edit,
                          style: AppleTheme.subhead.copyWith(
                            color: AppColors.textOnPrimary(context),
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

                      const SizedBox(height: AppleTheme.spacing24),

                      // Stats Cards Row
                      _buildStatsRow(),

                      const SizedBox(height: AppleTheme.spacing32),

                      // Activity Section
                      _buildActivitySection(),

                      const SizedBox(height: AppleTheme.spacing32),

                      // Settings Section
                      _buildSettingsSection(),

                      const SizedBox(height: AppleTheme.spacing32),

                      // Logout Button
                      _buildLogoutButton(),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  /// Premium Header with Gradient Background
  Widget _buildPremiumHeader(authState) {
    final locale = ref.read(localeProvider);
    final l10n = AppLocalizations.of(locale);
    return Container(
      margin: const EdgeInsets.all(AppleTheme.spacing20),
      padding: const EdgeInsets.all(AppleTheme.spacing28),
      decoration: BoxDecoration(
        gradient: AppColors.aiGradient(context),
        borderRadius: BorderRadius.circular(AppleTheme.spacing24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary(context).withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with White Border
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.textOnPrimary(context),
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    AppColors.isDark(context) ? 0.3 : 0.1,
                  ),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.surface(context),
              child: Text(
                (authState.user?.name.isNotEmpty == true)
                    ? authState.user!.name.substring(0, 1).toUpperCase()
                    : 'U',
                style: AppleTheme.largeTitle.copyWith(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: AppColors.secondary(context), // Teal
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Name
          Text(
            authState.user?.name ?? l10n.user,
            style: AppleTheme.title1.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textOnPrimary(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          // Email with Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.mail_solid,
                size: 14,
                color: AppColors.textOnPrimary(context).withOpacity(0.9),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  authState.user?.email ?? 'email@exemple.com',
                  style: AppleTheme.callout.copyWith(
                    color: AppColors.textOnPrimary(context).withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Member Since Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.textOnPrimary(context).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.textOnPrimary(context).withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.star_fill,
                  size: 14,
                  color: Colors.amber,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    l10n.memberSince,
                    style: AppleTheme.footnote.copyWith(
                      color: Colors.amber,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
    final locale = ref.read(localeProvider);
    final l10n = AppLocalizations.of(locale);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppleTheme.spacing20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context: context,
              icon: CupertinoIcons.flame_fill,
              value: '7',
              label: l10n.days,
              subtitle: l10n.streak,
              color: AppColors.primary(context),
            ),
          ),
          const SizedBox(width: AppleTheme.spacing12),
          Expanded(
            child: _buildStatCard(
              context: context,
              icon: CupertinoIcons.heart_fill,
              value: '42',
              label: l10n.recipes,
              subtitle: l10n.favorites,
              color: AppColors.secondary(context),
            ),
          ),
          const SizedBox(width: AppleTheme.spacing12),
          Expanded(
            child: _buildStatCard(
              context: context,
              icon: CupertinoIcons.chart_bar_fill,
              value: '89%',
              label: l10n.goal,
              subtitle: l10n.achieved,
              color: AppColors.primary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String value,
    required String label,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppleTheme.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(AppleTheme.radiusXLarge),
        border: Border.all(
          color: AppColors.divider(context).withOpacity(0.3),
          width: 0.5,
        ),
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
              color: AppColors.textPrimary(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppleTheme.caption1.copyWith(
              color: AppColors.textSecondary(context),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: AppleTheme.caption2.copyWith(
              color: AppColors.textTertiary(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Activity Section with Timeline
  Widget _buildActivitySection() {
    final locale = ref.read(localeProvider);
    final l10n = AppLocalizations.of(locale);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.recentActivity,
                style: AppleTheme.title3.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(context),
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(
                  l10n.viewAll,
                  style: AppleTheme.subhead.copyWith(
                    color: AppColors.primary(context),
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
              color: AppColors.surface(context),
              borderRadius: BorderRadius.circular(AppleTheme.radiusXLarge),
              border: Border.all(
                color: AppColors.divider(context).withOpacity(0.3),
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                _buildActivityItem(
                  context: context,
                  icon: CupertinoIcons.checkmark_seal_fill,
                  title: l10n.dailyGoalAchieved,
                  time: l10n.hoursAgo,
                  color: AppColors.success,
                ),
                _buildActivityDivider(),
                _buildActivityItem(
                  context: context,
                  icon: CupertinoIcons.book_fill,
                  title: l10n.newRecipeAdded,
                  time: l10n.yesterday,
                  color: AppColors.primary(context),
                ),
                _buildActivityDivider(),
                _buildActivityItem(
                  context: context,
                  icon: CupertinoIcons.heart_fill,
                  title: l10n.recipesAddedToFavorites,
                  time: l10n.daysAgo,
                  color: AppColors.secondary(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required BuildContext context,
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
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: AppleTheme.caption1.copyWith(
                    color: AppColors.textTertiary(context),
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
      color: AppColors.divider(context),
    );
  }

  /// Settings Section
  Widget _buildSettingsSection() {
    final locale = ref.read(localeProvider);
    final l10n = AppLocalizations.of(locale);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settings,
            style: AppleTheme.title3.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface(context),
              borderRadius: BorderRadius.circular(AppleTheme.radiusXLarge),
              border: Border.all(
                color: AppColors.divider(context).withOpacity(0.3),
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                _buildSettingsItem(
                  context: context,
                  icon: CupertinoIcons.person_circle_fill,
                  title: l10n.personalInfo,
                  color: AppColors.info,
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const PersonalInfoPage(),
                      ),
                    );
                  },
                ),
                _buildActivityDivider(),
                _buildSettingsItem(
                  context: context,
                  icon: CupertinoIcons.lock_shield_fill,
                  title: l10n.securityAndPrivacy,
                  color: AppColors.success,
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const SecurityPrivacyPage(),
                      ),
                    );
                  },
                ),
                _buildActivityDivider(),
                _buildSettingsItem(
                  context: context,
                  icon: CupertinoIcons.bell_fill,
                  title: l10n.notifications,
                  color: AppColors.warning,
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const NotificationsSettingsPage(),
                      ),
                    );
                  },
                ),
                _buildActivityDivider(),
                _buildSettingsItem(
                  context: context,
                  icon: CupertinoIcons.question_circle_fill,
                  title: l10n.helpAndSupport,
                  color: AppColors.info,
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const HelpSupportPage(),
                      ),
                    );
                  },
                ),
                _buildActivityDivider(),
                _buildThemeSwitcherItem(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required BuildContext context,
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
                color: AppColors.textPrimary(context),
              ),
            ),
          ),
          Icon(
            CupertinoIcons.chevron_right,
            size: 20,
            color: AppColors.textTertiary(context),
          ),
        ],
      ),
    );
  }

  /// Theme Switcher Item
  Widget _buildThemeSwitcherItem(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (isDark ? Colors.amber : AppColors.primary(context)).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isDark ? CupertinoIcons.moon_fill : CupertinoIcons.sun_max_fill,
              color: isDark ? Colors.amber : AppColors.primary(context),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isDark ? 'Mode Sombre' : 'Mode Clair',
              style: AppleTheme.subhead.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary(context),
              ),
            ),
          ),
          CupertinoSwitch(
            value: isDark,
            activeTrackColor: Colors.amber.shade700,
            onChanged: (value) {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
    );
  }

  /// Logout Button with Modern Design
  Widget _buildLogoutButton() {
    final locale = ref.read(localeProvider);
    final l10n = AppLocalizations.of(locale);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: _handleLogout,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppleTheme.spacing16),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.08),
            borderRadius: BorderRadius.circular(AppleTheme.radiusCard),
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
                l10n.logout,
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
