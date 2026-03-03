import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/apple_theme.dart';
import '../../../../shared/widgets/apple_widgets.dart';

class SecurityPrivacyPage extends ConsumerStatefulWidget {
  const SecurityPrivacyPage({super.key});

  @override
  ConsumerState<SecurityPrivacyPage> createState() =>
      _SecurityPrivacyPageState();
}

class _SecurityPrivacyPageState extends ConsumerState<SecurityPrivacyPage> {
  bool _biometricEnabled = true;
  bool _twoFactorEnabled = false;
  bool _shareDataForResearch = false;
  bool _shareDataWithPartners = false;

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
          'Sécurité et confidentialité',
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
            // Security Section
            const AppleSectionHeader(title: 'Sécurité'),
            const SizedBox(height: 8),
            AppleCard(
              child: Column(
                children: [
                  _buildSwitchRow(
                    label: 'Authentification biométrique',
                    subtitle: 'Utiliser Face ID / Empreinte',
                    icon: CupertinoIcons.lock_shield_fill,
                    value: _biometricEnabled,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _biometricEnabled = value;
                      });
                    },
                  ),
                  _buildDivider(),
                  _buildSwitchRow(
                    label: 'Authentification à 2 facteurs',
                    subtitle: 'Couche de sécurité supplémentaire',
                    icon: CupertinoIcons.shield_lefthalf_fill,
                    value: _twoFactorEnabled,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _twoFactorEnabled = value;
                      });
                    },
                  ),
                  _buildDivider(),
                  _buildNavigationRow(
                    label: 'Changer le mot de passe',
                    icon: CupertinoIcons.lock_rotation,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _showChangePasswordSheet();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Privacy Section
            const AppleSectionHeader(title: 'Confidentialité'),
            const SizedBox(height: 8),
            AppleCard(
              child: Column(
                children: [
                  _buildSwitchRow(
                    label: 'Partager les données pour la recherche',
                    subtitle: 'Aider à améliorer MEATAY',
                    icon: CupertinoIcons.chart_bar,
                    value: _shareDataForResearch,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _shareDataForResearch = value;
                      });
                    },
                  ),
                  _buildDivider(),
                  _buildSwitchRow(
                    label: 'Partager les données avec les partenaires',
                    subtitle: 'Recommandations personnalisées',
                    icon: CupertinoIcons.person_2,
                    value: _shareDataWithPartners,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _shareDataWithPartners = value;
                      });
                    },
                  ),
                  _buildDivider(),
                  _buildNavigationRow(
                    label: 'Utilisation des données',
                    icon: CupertinoIcons.doc_text,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _showDataUsageInfo();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Legal Section
            const AppleSectionHeader(title: 'Légal'),
            const SizedBox(height: 8),
            AppleCard(
              child: Column(
                children: [
                  _buildNavigationRow(
                    label: 'Politique de confidentialité',
                    icon: CupertinoIcons.doc_plaintext,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _openPrivacyPolicy();
                    },
                  ),
                  _buildDivider(),
                  _buildNavigationRow(
                    label: 'Conditions d\'utilisation',
                    icon: CupertinoIcons.doc_on_doc,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _openTermsOfService();
                    },
                  ),
                  _buildDivider(),
                  _buildNavigationRow(
                    label: 'Télécharger mes données',
                    icon: CupertinoIcons.arrow_down_doc,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _downloadData();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Active Sessions
            const AppleSectionHeader(title: 'Sessions actives'),
            const SizedBox(height: 8),
            AppleCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSessionItem(
                    device: 'iPhone 15 Pro',
                    location: 'Paris, France',
                    lastActive: 'Maintenant',
                    isCurrent: true,
                  ),
                  const SizedBox(height: 12),
                  _buildSessionItem(
                    device: 'MacBook Pro',
                    location: 'Paris, France',
                    lastActive: 'Il y a 2 heures',
                    isCurrent: false,
                  ),
                ],
              ),
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
              color: AppColors.success.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.success),
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
            activeTrackColor: AppColors.success,
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
              color: AppColors.success.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.success),
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

  Widget _buildSessionItem({
    required String device,
    required String location,
    required String lastActive,
    required bool isCurrent,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary(context).withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            device.contains('iPhone')
                ? CupertinoIcons.device_phone_portrait
                : CupertinoIcons.device_laptop,
            color: AppColors.primary(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    device,
                    style: AppleTheme.callout.copyWith(
                      color: AppColors.textPrimary(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isCurrent) ...[
                    const SizedBox(width: 6),
                    const AppleBadge(
                      text: 'Actuel',
                      backgroundColor: Color(0x1F4CAF50),
                      textColor: AppColors.success,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '$location • $lastActive',
                style: AppleTheme.caption1.copyWith(
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
        ),
        if (!isCurrent)
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              HapticFeedback.lightImpact();
              // TODO: Terminate session
            },
            child: Icon(
              CupertinoIcons.xmark_circle_fill,
              color: AppColors.error,
              size: 24,
            ),
          ),
      ],
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

  void _showChangePasswordSheet() {
    // TODO: Implement change password
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 400,
        color: AppColors.surface(context),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Changer le mot de passe',
              style: AppleTheme.title2.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            CupertinoTextField(
              placeholder: 'Mot de passe actuel',
              obscureText: true,
            ),
            const SizedBox(height: 12),
            CupertinoTextField(
              placeholder: 'Nouveau mot de passe',
              obscureText: true,
            ),
            const SizedBox(height: 12),
            CupertinoTextField(
              placeholder: 'Confirmer le mot de passe',
              obscureText: true,
            ),
            const Spacer(),
            AppleButton(
              text: 'Changer',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showDataUsageInfo() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Utilisation des données'),
        content: const Text(
          'Vos données sont utilisées pour améliorer votre expérience et vous fournir des recommandations personnalisées. Nous ne vendons jamais vos données.',
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Compris'),
          ),
        ],
      ),
    );
  }

  void _openPrivacyPolicy() {
    // TODO: Open privacy policy URL
  }

  void _openTermsOfService() {
    // TODO: Open terms URL
  }

  void _downloadData() {
    // TODO: Download user data
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Préparation de vos données...'),
        backgroundColor: AppColors.info,
      ),
    );
  }
}
