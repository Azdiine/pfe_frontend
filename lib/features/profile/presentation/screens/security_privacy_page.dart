import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/apple_theme.dart';
import '../../../../shared/widgets/apple_widgets.dart';
import '../../../auth/application/auth_provider.dart';

class SecurityPrivacyPage extends ConsumerStatefulWidget {
  const SecurityPrivacyPage({super.key});

  @override
  ConsumerState<SecurityPrivacyPage> createState() =>
      _SecurityPrivacyPageState();
}

class _SecurityPrivacyPageState extends ConsumerState<SecurityPrivacyPage> {
  bool _shareDataForResearch = false;
  bool _shareDataWithPartners = false;

  List<Map<String, dynamic>>? _sessions;
  bool _sessionsLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _loadSessions();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _shareDataForResearch = prefs.getBool('privacy_share_research') ?? false;
      _shareDataWithPartners = prefs.getBool('privacy_share_partners') ?? false;
    });
  }

  Future<void> _savePref(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _loadSessions() async {
    setState(() => _sessionsLoading = true);
    try {
      final sessions = await ref.read(authRepositoryProvider).listSessions();
      if (!mounted) return;
      setState(() {
        _sessions = sessions;
        _sessionsLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _sessions = null;
        _sessionsLoading = false;
      });
    }
  }

  Future<void> _revokeSession(String sessionId) async {
    try {
      await ref.read(authRepositoryProvider).revokeSession(sessionId);
      await _loadSessions();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Impossible de révoquer cette session.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

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
              child: _buildNavigationRow(
                label: 'Changer le mot de passe',
                icon: CupertinoIcons.lock_rotation,
                onTap: () {
                  HapticFeedback.lightImpact();
                  _showChangePasswordSheet();
                },
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
                      setState(() => _shareDataForResearch = value);
                      _savePref('privacy_share_research', value);
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
                      setState(() => _shareDataWithPartners = value);
                      _savePref('privacy_share_partners', value);
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

            // Active Sessions (données réelles du serveur)
            Row(
              children: [
                const AppleSectionHeader(title: 'Sessions actives'),
                const Spacer(),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _loadSessions,
                  child: Icon(
                    CupertinoIcons.refresh,
                    size: 18,
                    color: AppColors.primary(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AppleCard(
              padding: const EdgeInsets.all(16),
              child: _buildSessionsContent(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionsContent() {
    if (_sessionsLoading) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Center(child: CupertinoActivityIndicator()),
      );
    }
    final sessions = _sessions;
    if (sessions == null) {
      return Text(
        'Impossible de charger les sessions.',
        style: AppleTheme.subhead.copyWith(
          color: AppColors.textSecondary(context),
        ),
      );
    }
    if (sessions.isEmpty) {
      return Text(
        'Aucune session active.',
        style: AppleTheme.subhead.copyWith(
          color: AppColors.textSecondary(context),
        ),
      );
    }
    return Column(
      children: [
        for (var i = 0; i < sessions.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          _buildSessionItem(sessions[i]),
        ],
      ],
    );
  }

  String _formatDate(String? iso) {
    final d = DateTime.tryParse(iso ?? '')?.toLocal();
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
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
              color: AppColors.success.withValues(alpha: 0.12),
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
              color: AppColors.success.withValues(alpha: 0.12),
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

  Widget _buildSessionItem(Map<String, dynamic> session) {
    final isCurrent = session['isCurrent'] == true;
    final createdAt = _formatDate(session['createdAt']?.toString());

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary(context).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            CupertinoIcons.device_phone_portrait,
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
                    isCurrent ? 'Cet appareil' : 'Session',
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
                'Connectée le $createdAt',
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
              _revokeSession(session['id'].toString());
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
      color: AppColors.divider(context).withValues(alpha: 0.3),
      indent: 68,
    );
  }

  void _showChangePasswordSheet() {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();
    var saving = false;
    String? errorText;

    showCupertinoModalPopup(
      context: context,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          Future<void> submit() async {
            final current = currentController.text;
            final newPass = newController.text;
            final confirm = confirmController.text;

            if (current.isEmpty) {
              setSheetState(() => errorText = 'Entrez votre mot de passe actuel.');
              return;
            }
            if (newPass.length < 6) {
              setSheetState(() =>
                  errorText = 'Le nouveau mot de passe doit faire 6 caractères minimum.');
              return;
            }
            if (newPass != confirm) {
              setSheetState(() =>
                  errorText = 'Les mots de passe ne correspondent pas.');
              return;
            }

            setSheetState(() {
              saving = true;
              errorText = null;
            });
            try {
              await ref
                  .read(authRepositoryProvider)
                  .changePassword(current, newPass);
              if (!sheetContext.mounted) return;
              Navigator.pop(sheetContext);
              // La révocation des autres sessions est faite côté serveur
              _loadSessions();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Mot de passe changé'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } catch (e) {
              setSheetState(() {
                saving = false;
                errorText = e.toString().replaceFirst('Exception: ', '');
              });
            }
          }

          return Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface(context),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Changer le mot de passe',
                  style: AppleTheme.title2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 20),
                CupertinoTextField(
                  controller: currentController,
                  placeholder: 'Mot de passe actuel',
                  obscureText: true,
                  padding: const EdgeInsets.all(14),
                ),
                const SizedBox(height: 12),
                CupertinoTextField(
                  controller: newController,
                  placeholder: 'Nouveau mot de passe (6 caractères min.)',
                  obscureText: true,
                  padding: const EdgeInsets.all(14),
                ),
                const SizedBox(height: 12),
                CupertinoTextField(
                  controller: confirmController,
                  placeholder: 'Confirmer le mot de passe',
                  obscureText: true,
                  padding: const EdgeInsets.all(14),
                ),
                if (errorText != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    errorText!,
                    style: AppleTheme.footnote.copyWith(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 20),
                AppleButton(
                  text: saving ? 'Changement...' : 'Changer',
                  onPressed: submit,
                ),
              ],
            ),
          );
        },
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
}
