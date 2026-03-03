import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/apple_theme.dart';
import '../../../../shared/widgets/apple_widgets.dart';

class HelpSupportPage extends ConsumerStatefulWidget {
  const HelpSupportPage({super.key});

  @override
  ConsumerState<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends ConsumerState<HelpSupportPage> {
  final List<Map<String, dynamic>> _faq = [
    {
      'question': 'Comment scanner un code-barres ?',
      'answer':
          'Allez dans le frigo, appuyez sur le bouton +, puis sélectionnez "Scanner un code-barres". Alignez le code-barres dans le cadre.',
    },
    {
      'question': 'Comment ajouter un ingrédient manuellement ?',
      'answer':
          'Dans le frigo, appuyez sur le bouton +, puis "Ajouter manuellement". Remplissez les informations et validez.',
    },
    {
      'question': 'Comment obtenir des suggestions de recettes ?',
      'answer':
          'Les recettes sont suggérées automatiquement en fonction des ingrédients dans votre frigo. Vous pouvez aussi appuyer sur le bouton sparkle dans le frigo.',
    },
    {
      'question': 'Comment suivre mes calories ?',
      'answer':
          'Rendez-vous dans l\'onglet Suivi pour voir vos statistiques quotidiennes et hebdomadaires.',
    },
    {
      'question': 'Comment activer les notifications ?',
      'answer':
          'Allez dans Profil > Paramètres > Notifications pour configurer vos préférences.',
    },
    {
      'question': 'Comment changer de langue ?',
      'answer':
          'Utilisez le sélecteur de langue en haut à gauche de l\'écran principal.',
    },
  ];

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
          'Aide et support',
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
            // Quick Actions Section
            const AppleSectionHeader(title: 'Actions rapides'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: CupertinoIcons.chat_bubble_2_fill,
                    label: 'Chat en direct',
                    color: AppColors.success,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _openLiveChat();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: CupertinoIcons.mail_solid,
                    label: 'Nous écrire',
                    color: AppColors.info,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _sendEmail();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: CupertinoIcons.book_fill,
                    label: 'Guide utilisateur',
                    color: AppColors.warning,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _openUserGuide();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: CupertinoIcons.videocam_fill,
                    label: 'Tutoriels vidéo',
                    color: AppColors.info,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _openTutorials();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // FAQ Section
            const AppleSectionHeader(title: 'Questions fréquentes'),
            const SizedBox(height: 8),
            AppleCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: _faq.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Column(
                    children: [
                      _buildFaqItem(
                        question: item['question'],
                        answer: item['answer'],
                      ),
                      if (index < _faq.length - 1) _buildDivider(),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Contact Section
            const AppleSectionHeader(title: 'Contacter le support'),
            const SizedBox(height: 8),
            AppleCard(
              child: Column(
                children: [
                  _buildContactRow(
                    icon: CupertinoIcons.mail,
                    label: 'Email',
                    value: 'support@meatay.app',
                    onTap: () => _sendEmail(),
                  ),
                  _buildDivider(),
                  _buildContactRow(
                    icon: CupertinoIcons.phone,
                    label: 'Téléphone',
                    value: '+33 1 23 45 67 89',
                    onTap: () => _callSupport(),
                  ),
                  _buildDivider(),
                  _buildContactRow(
                    icon: CupertinoIcons.time,
                    label: 'Horaires',
                    value: 'Lun-Ven 9h-18h',
                    onTap: null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Resources Section
            const AppleSectionHeader(title: 'Ressources'),
            const SizedBox(height: 8),
            AppleCard(
              child: Column(
                children: [
                  _buildNavigationRow(
                    label: 'Forum communautaire',
                    icon: CupertinoIcons.group,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _openForum();
                    },
                  ),
                  _buildDivider(),
                  _buildNavigationRow(
                    label: 'Demandes de fonctionnalités',
                    icon: CupertinoIcons.lightbulb,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _openFeatureRequests();
                    },
                  ),
                  _buildDivider(),
                  _buildNavigationRow(
                    label: 'Signaler un bug',
                    icon: CupertinoIcons.ant,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _reportBug();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // App Info Section
            const AppleSectionHeader(title: 'Informations sur l\'app'),
            const SizedBox(height: 8),
            AppleCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoRow('Version', '1.0.0'),
                  const SizedBox(height: 8),
                  _buildInfoRow('Build', '2024.02.16'),
                  const SizedBox(height: 8),
                  _buildInfoRow('Plateforme', 'iOS 17.0+'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Rate App Button
            AppleButton(
              text: 'Noter l\'application',
              backgroundColor: AppColors.primary(context),
              icon: CupertinoIcons.star_fill,
              onPressed: () {
                HapticFeedback.mediumImpact();
                _rateApp();
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(AppleTheme.radiusXLarge),
          border: Border.all(
            color: AppColors.divider(context).withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(height: 8),
            Text(
              label,
              style: AppleTheme.caption1.copyWith(
                color: AppColors.textPrimary(context),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        title: Text(
          question,
          style: AppleTheme.body.copyWith(
            color: AppColors.textPrimary(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconColor: AppColors.primary(context),
        collapsedIconColor: AppColors.textTertiary(context),
        children: [
          Text(
            answer,
            style: AppleTheme.body.copyWith(
              color: AppColors.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback? onTap,
  }) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary(context).withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary(context)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppleTheme.caption1.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppleTheme.body.copyWith(
                    color: AppColors.textPrimary(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: AppColors.textTertiary(context),
            ),
        ],
      ),
    );

    if (onTap != null) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: content,
      );
    }
    return content;
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppleTheme.body.copyWith(
            color: AppColors.textSecondary(context),
          ),
        ),
        Text(
          value,
          style: AppleTheme.body.copyWith(
            color: AppColors.textPrimary(context),
            fontWeight: FontWeight.w600,
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

  void _openLiveChat() {
    // TODO: Open live chat
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Ouverture du chat...'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _sendEmail() {
    // TODO: Open email client
  }

  void _openUserGuide() {
    // TODO: Open user guide
  }

  void _openTutorials() {
    // TODO: Open video tutorials
  }

  void _callSupport() {
    // TODO: Make phone call
  }

  void _openForum() {
    // TODO: Open community forum
  }

  void _openFeatureRequests() {
    // TODO: Open feature requests
  }

  void _reportBug() {
    // TODO: Open bug report form
  }

  void _rateApp() {
    // TODO: Open App Store rating
  }
}
