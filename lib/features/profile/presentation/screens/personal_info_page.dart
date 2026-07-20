import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/apple_theme.dart';
import '../../../../shared/widgets/apple_widgets.dart';
import '../../application/profile_provider.dart';

/// Édition des informations personnelles — branchée sur l'API
/// (mêmes valeurs que l'onboarding, sauvegarde via PUT /api/profile).
class PersonalInfoPage extends ConsumerStatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  ConsumerState<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends ConsumerState<PersonalInfoPage> {
  final _nameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _targetWeightController = TextEditingController();

  String? _gender;
  DateTime? _birthDate;
  String? _goal;
  String? _activityLevel;
  String? _dietType;
  bool _saving = false;

  static const _genderLabels = {
    'male': 'Homme',
    'female': 'Femme',
    'other': 'Autre',
  };
  static const _goalLabels = {
    'lose_weight': 'Perdre du poids',
    'gain_muscle': 'Prendre du muscle',
    'maintain': 'Maintenir mon poids',
    'eat_healthier': 'Manger plus sainement',
    'improve_fitness': 'Améliorer ma forme',
  };
  static const _activityLabels = {
    'sedentary': 'Sédentaire',
    'lightly_active': 'Légèrement actif',
    'moderately_active': 'Modérément actif',
    'active': 'Actif',
    'very_active': 'Très actif',
  };
  static const _dietLabels = {
    'omnivore': 'Omnivore',
    'vegetarian': 'Végétarien',
    'vegan': 'Vegan',
    'halal': 'Halal',
    'keto': 'Keto',
    'paleo': 'Paléo',
    'no_preference': 'Sans préférence',
  };

  @override
  void initState() {
    super.initState();
    _prefillFromProfile();
  }

  void _prefillFromProfile() {
    final state = ref.read(profileProvider);
    final profile =
        state.profileData?['profile'] as Map<String, dynamic>? ?? {};

    _nameController.text = state.name ?? '';
    _gender = profile['gender'] as String?;
    _goal = profile['goal'] as String?;
    _activityLevel = profile['activityLevel'] as String?;
    _dietType = profile['dietType'] as String?;
    _birthDate = DateTime.tryParse(profile['birthDate']?.toString() ?? '');

    double? parseNum(dynamic v) =>
        v == null ? null : double.tryParse(v.toString());
    final h = parseNum(profile['heightCm']);
    final w = parseNum(profile['weightKg']);
    final t = parseNum(profile['targetWeightKg']);
    if (h != null) _heightController.text = h.toStringAsFixed(0);
    if (w != null) _weightController.text = w.toStringAsFixed(1);
    if (t != null) _targetWeightController.text = t.toStringAsFixed(1);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_saving) return;
    HapticFeedback.mediumImpact();
    setState(() => _saving = true);

    double? parse(TextEditingController c) =>
        double.tryParse(c.text.trim().replaceAll(',', '.'));

    final data = <String, dynamic>{
      if (_nameController.text.trim().isNotEmpty)
        'name': _nameController.text.trim(),
      'gender': ?_gender,
      'goal': ?_goal,
      'activityLevel': ?_activityLevel,
      'dietType': ?_dietType,
      if (_birthDate != null)
        'birthDate': _birthDate!.toIso8601String().substring(0, 10),
      if (parse(_heightController) != null)
        'heightCm': parse(_heightController),
      if (parse(_weightController) != null)
        'weightKg': parse(_weightController),
      if (parse(_targetWeightController) != null)
        'targetWeightKg': parse(_targetWeightController),
    };

    await ref.read(profileProvider.notifier).updateProfile(data);
    if (!mounted) return;
    setState(() => _saving = false);

    final error = ref.read(profileProvider).error;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error == null
              ? '✅ Profil mis à jour'
              : 'Échec de la mise à jour, réessayez.',
        ),
        backgroundColor: error == null ? AppColors.success : AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
    if (error == null) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final avatarUrl = profileState.avatarUrl;
    final displayName =
        _nameController.text.isNotEmpty ? _nameController.text : 'U';

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
          'Informations personnelles',
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
            // Avatar (photo Google si disponible)
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary(context).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 56,
                  backgroundColor: AppColors.primary(context),
                  foregroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                      ? NetworkImage(avatarUrl)
                      : null,
                  child: Text(
                    displayName.substring(0, 1).toUpperCase(),
                    style: AppleTheme.largeTitle.copyWith(
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                profileState.email ?? '',
                style: AppleTheme.footnote.copyWith(
                  color: AppColors.textSecondary(context),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Informations de base
            AppleSectionHeader(title: 'Informations de base'),
            const SizedBox(height: 8),
            AppleCard(
              child: Column(
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Nom complet',
                    icon: CupertinoIcons.person,
                  ),
                  _buildDivider(),
                  _buildPickerRow(
                    label: 'Genre',
                    value: _genderLabels[_gender] ?? '--',
                    icon: CupertinoIcons.person_2,
                    onTap: () => _showOptionsPicker(
                      _genderLabels,
                      _gender,
                      (v) => setState(() => _gender = v),
                    ),
                  ),
                  _buildDivider(),
                  _buildPickerRow(
                    label: 'Date de naissance',
                    value: _birthDate != null
                        ? '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}'
                        : '--',
                    icon: CupertinoIcons.calendar,
                    onTap: _showDatePicker,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Mensurations
            AppleSectionHeader(title: 'Mensurations'),
            const SizedBox(height: 8),
            AppleCard(
              child: Column(
                children: [
                  _buildTextField(
                    controller: _heightController,
                    label: 'Taille (cm)',
                    icon: CupertinoIcons.resize_v,
                    keyboardType: TextInputType.number,
                  ),
                  _buildDivider(),
                  _buildTextField(
                    controller: _weightController,
                    label: 'Poids (kg)',
                    icon: CupertinoIcons.speedometer,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                  _buildDivider(),
                  _buildTextField(
                    controller: _targetWeightController,
                    label: 'Poids cible (kg)',
                    icon: CupertinoIcons.flag,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Préférences
            AppleSectionHeader(title: 'Objectif & préférences'),
            const SizedBox(height: 8),
            AppleCard(
              child: Column(
                children: [
                  _buildPickerRow(
                    label: 'Objectif',
                    value: _goalLabels[_goal] ?? '--',
                    icon: CupertinoIcons.scope,
                    onTap: () => _showOptionsPicker(
                      _goalLabels,
                      _goal,
                      (v) => setState(() => _goal = v),
                    ),
                  ),
                  _buildDivider(),
                  _buildPickerRow(
                    label: 'Niveau d\'activité',
                    value: _activityLabels[_activityLevel] ?? '--',
                    icon: CupertinoIcons.bolt,
                    onTap: () => _showOptionsPicker(
                      _activityLabels,
                      _activityLevel,
                      (v) => setState(() => _activityLevel = v),
                    ),
                  ),
                  _buildDivider(),
                  _buildPickerRow(
                    label: 'Type de régime',
                    value: _dietLabels[_dietType] ?? '--',
                    icon: CupertinoIcons.leaf_arrow_circlepath,
                    onTap: () => _showOptionsPicker(
                      _dietLabels,
                      _dietType,
                      (v) => setState(() => _dietType = v),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Bouton Enregistrer
            AppleButton(
              text: _saving
                  ? 'Enregistrement...'
                  : 'Enregistrer les modifications',
              onPressed: _saveChanges,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.primary(context)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppleTheme.caption1.copyWith(
                    color: AppColors.textSecondary(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                CupertinoTextField(
                  controller: controller,
                  style: AppleTheme.body.copyWith(
                    color: AppColors.textPrimary(context),
                  ),
                  decoration: const BoxDecoration(),
                  padding: EdgeInsets.zero,
                  keyboardType: keyboardType,
                ),
              ],
            ),
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
          Icon(icon, size: 22, color: AppColors.primary(context)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppleTheme.caption1.copyWith(
                    color: AppColors.textSecondary(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppleTheme.body.copyWith(
                    color: AppColors.textPrimary(context),
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

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: AppColors.divider(context).withValues(alpha: 0.3),
      indent: 50,
    );
  }

  void _showOptionsPicker(
    Map<String, String> options,
    String? current,
    ValueChanged<String> onSelected,
  ) {
    final keys = options.keys.toList();
    var selected = current != null && keys.contains(current)
        ? keys.indexOf(current)
        : 0;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 280,
        color: AppColors.surface(context),
        child: Column(
          children: [
            SizedBox(
              height: 44,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annuler'),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        onSelected(keys[selected]);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Terminé',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 44,
                scrollController:
                    FixedExtentScrollController(initialItem: selected),
                onSelectedItemChanged: (index) => selected = index,
                children: keys
                    .map((k) => Center(child: Text(options[k]!)))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250,
        color: AppColors.surface(context),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: _birthDate ?? DateTime(2000, 1, 1),
          maximumDate: DateTime.now(),
          onDateTimeChanged: (date) {
            setState(() => _birthDate = date);
          },
        ),
      ),
    );
  }
}
