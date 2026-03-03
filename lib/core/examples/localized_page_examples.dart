/// 🌍 Example: Localized Settings Page
/// This file demonstrates how to create a fully localized page using the new i18n system
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../shared/widgets/language_switcher.dart';
import '../providers/locale_provider.dart';

/// Settings page with full localization support
class SettingsPageExample extends ConsumerWidget {
  const SettingsPageExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get localization instance
    final l10n = AppLocalizations.of(context);
    
    // Watch current locale for language-specific UI
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Language Section
          _buildSectionHeader(context, l10n.language),
          
          // Language switcher as list tile
          const LanguageSwitcher(
            style: LanguageSwitcherStyle.tile,
          ),
          
          const Divider(height: 32),
          
          // Account Section
          _buildSectionHeader(context, l10n.accountSettings),
          
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(l10n.editProfile),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to edit profile
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(l10n.changePassword),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          
          const Divider(height: 32),
          
          // Notifications Section
          _buildSectionHeader(context, l10n.notifications),
          
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: Text(l10n.pushNotifications),
            value: true,
            onChanged: (value) {},
          ),
          
          SwitchListTile(
            secondary: const Icon(Icons.email_outlined),
            title: Text(l10n.emailNotifications),
            value: false,
            onChanged: (value) {},
          ),
          
          ListTile(
            leading: const Icon(Icons.alarm),
            title: Text(l10n.reminderNotifications),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          
          const Divider(height: 32),
          
          // Appearance Section
          _buildSectionHeader(context, l10n.appearance),
          
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(l10n.theme),
            subtitle: Text(l10n.lightMode),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          
          ListTile(
            leading: const Icon(Icons.straighten),
            title: Text(l10n.units),
            subtitle: Text(l10n.metric),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          
          const Divider(height: 32),
          
          // App Info Section
          _buildSectionHeader(context, l10n.about),
          
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(l10n.help),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.terms),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.privacy),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.version),
            subtitle: const Text('1.0.0+1'),
          ),
          
          const SizedBox(height: 24),
          
          // Logout button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () {
                _showLogoutDialog(context, l10n);
              },
              icon: const Icon(Icons.logout),
              label: Text(l10n.logout),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Current language indicator
          Center(
            child: Text(
              '${l10n.language}: ${SupportedLocales.getFlagEmoji(currentLocale)} ${SupportedLocales.getLanguageName(currentLocale)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.confirmDelete), // Reusing existing key
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform logout
            },
            child: Text(
              l10n.confirm,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}


/// 🎨 Example: Localized Home Screen
class HomePageExample extends ConsumerStatefulWidget {
  const HomePageExample({super.key});

  @override
  ConsumerState<HomePageExample> createState() => _HomePageExampleState();
}

class _HomePageExampleState extends ConsumerState<HomePageExample> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          // Quick language toggle in app bar
          const QuickLanguageToggle(),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting based on time of day
            Text(
              _getGreeting(l10n),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            
            Text(
              l10n.today,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            
            const SizedBox(height: 24),
            
            // Nutrition Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.dailyNutrition,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMacroColumn(
                          context,
                          l10n.proteins,
                          '45',
                          l10n.gramsUnit,
                          Colors.blue,
                        ),
                        _buildMacroColumn(
                          context,
                          l10n.carbs,
                          '120',
                          l10n.gramsUnit,
                          Colors.orange,
                        ),
                        _buildMacroColumn(
                          context,
                          l10n.fats,
                          '35',
                          l10n.gramsUnit,
                          Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quick Actions
            Text(
              l10n.quickActions,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context,
                    l10n.scanFood,
                    Icons.qr_code_scanner,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    context,
                    l10n.addMeal,
                    Icons.restaurant,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context,
                    l10n.logWater,
                    Icons.water_drop,
                    Colors.cyan,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    context,
                    l10n.myFridge,
                    Icons.kitchen,
                    Colors.green,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Recommended Recipes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.recommendedForYou,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(l10n.viewAll),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildRecipeCard(context, l10n, l10n.breakfast),
                  _buildRecipeCard(context, l10n, l10n.lunch),
                  _buildRecipeCard(context, l10n, l10n.dinner),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Language info
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${SupportedLocales.getFlagEmoji(currentLocale)} ${SupportedLocales.getLanguageName(currentLocale)}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return l10n.goodMorning;
    } else if (hour < 18) {
      return l10n.goodAfternoon;
    } else {
      return l10n.goodEvening;
    }
  }

  Widget _buildMacroColumn(
    BuildContext context,
    String label,
    String value,
    String unit,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          '$value$unit',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(
    BuildContext context,
    AppLocalizations l10n,
    String category,
  ) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.restaurant_menu, size: 48),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '30 ${l10n.minutes}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
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
