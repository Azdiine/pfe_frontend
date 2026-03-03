import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/apple_theme.dart';
import '../../../../shared/widgets/apple_widgets.dart';

class NotificationsSettingsPage extends ConsumerStatefulWidget {
  const NotificationsSettingsPage({super.key});

  @override
  ConsumerState<NotificationsSettingsPage> createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState
    extends ConsumerState<NotificationsSettingsPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;

  // Categories
  bool _mealReminders = true;
  bool _nutritionGoals = true;
  bool _recipesSuggestions = true;
  bool _expirationAlerts = true;
  bool _weeklyReports = true;
  bool _promotions = false;

  String _selectedReminderTime = '18:00';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background(context),
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
          child: Icon(CupertinoIcons.back, color: AppColors.primary(context)),
        ),
        middle: Text(
          'Notifications',
          style: AppleTheme.headline.copyWith(
            color: AppColors.textPrimary(context),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Channel Section
            const AppleSectionHeader(title: 'Canaux de notification'),
            const SizedBox(height: 8),
            AppleCard(
              child: Column(
                children: [
                  _buildSwitchRow(
                    label: 'Notifications push',
                    subtitle: 'Recevoir sur votre appareil',
                    icon: CupertinoIcons.bell_fill,
                    value: _pushNotifications,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _pushNotifications = value;
                      });
                    },
                  ),
                  _buildDivider(),
                  _buildSwitchRow(
                    label: 'Notifications par email',
                    subtitle: 'Recevoir par email',
                    icon: CupertinoIcons.mail_solid,
                    value: _emailNotifications,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _emailNotifications = value;
                      });
                    },
                  ),
                  _buildDivider(),
                  _buildSwitchRow(
                    label: 'Notifications par SMS',
                    subtitle: 'Recevoir par SMS',
                    icon: CupertinoIcons.chat_bubble_text_fill,
                    value: _smsNotifications,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _smsNotifications = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Categories Section
            const AppleSectionHeader(title: 'Catégories de notifications'),
            const SizedBox(height: 8),
            AppleCard(
              child: Column(
                children: [
                  _buildSwitchRow(
                    label: 'Rappels de repas',
                    subtitle: 'Vous rappeler de manger',
                    icon: CupertinoIcons.alarm,
                    value: _mealReminders,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _mealReminders = value;
                      });
                    },
                  ),
                  _buildDivider(),
                  _buildSwitchRow(
                    label: 'Objectifs nutritionnels',
                    subtitle: 'Suivre votre progression',
                    icon: CupertinoIcons.chart_bar_circle_fill,
                    value: _nutritionGoals,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _nutritionGoals = value;
                      });
                    },
                  ),
                  _buildDivider(),
                  _buildSwitchRow(
                    label: 'Suggestions de recettes',
                    subtitle: 'Nouvelles idées de recettes',
                    icon: CupertinoIcons.sparkles,
                    value: _recipesSuggestions,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _recipesSuggestions = value;
                      });
                    },
                  ),
                  _buildDivider(),
                  _buildSwitchRow(
                    label: 'Alertes d\'expiration',
                    subtitle: 'Ingrédients bientôt périmés',
                    icon: CupertinoIcons.exclamationmark_triangle_fill,
                    value: _expirationAlerts,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _expirationAlerts = value;
                      });
                    },
                  ),
                  _buildDivider(),
                  _buildSwitchRow(
                    label: 'Rapports hebdomadaires',
                    subtitle: 'Résumé de la semaine',
                    icon: CupertinoIcons.doc_text_fill,
                    value: _weeklyReports,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _weeklyReports = value;
                      });
                    },
                  ),
                  _buildDivider(),
                  _buildSwitchRow(
                    label: 'Promotions',
                    subtitle: 'Offres spéciales',
                    icon: CupertinoIcons.tag_fill,
                    value: _promotions,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _promotions = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quiet Hours Section
            const AppleSectionHeader(title: 'Heures de silence'),
            const SizedBox(height: 8),
            AppleCard(
              child: Column(
                children: [
                  _buildPickerRow(
                    label: 'Heure des rappels',
                    value: _selectedReminderTime,
                    icon: CupertinoIcons.time,
                    onTap: () => _showTimePicker(),
                  ),
                  _buildDivider(),
                  _buildNavigationRow(
                    label: 'Ne pas déranger (22:00 - 8:00)',
                    icon: CupertinoIcons.moon_fill,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _configureQuietHours();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Test Notification Button
            AppleButton(
              text: 'Envoyer une notification test',
              backgroundColor: AppColors.secondary(context),
              onPressed: () {
                HapticFeedback.mediumImpact();
                _sendTestNotification();
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String label,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.warning),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppleTheme.body.copyWith(
                    color: AppColors.textPrimary(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppleTheme.caption1.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildPickerRow({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onPressed: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.warning),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppleTheme.body.copyWith(
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppleTheme.caption1.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            CupertinoIcons.chevron_right,
            size: 16,
            color: AppColors.textTertiary(context),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRow({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onPressed: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.secondary(context).withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.secondary(context)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppleTheme.body.copyWith(
                color: AppColors.textPrimary(context),
              ),
            ),
          ),
          Icon(
            CupertinoIcons.chevron_right,
            size: 16,
            color: AppColors.textTertiary(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: AppColors.divider(context).withOpacity(0.3),
      indent: 68,
    );
  }

  void _showTimePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250,
        color: AppColors.surface(context),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          initialDateTime: DateTime(2024, 1, 1, 18, 0),
          onDateTimeChanged: (date) {
            setState(() {
              _selectedReminderTime =
                  '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
            });
          },
        ),
      ),
    );
  }

  void _configureQuietHours() {
    // TODO: Configure quiet hours
  }

  void _sendTestNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification test envoyée !'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
