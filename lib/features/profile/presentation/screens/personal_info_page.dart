import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/apple_theme.dart';
import '../../../../shared/widgets/apple_widgets.dart';

class PersonalInfoPage extends ConsumerStatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  ConsumerState<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends ConsumerState<PersonalInfoPage> {
  final _nameController = TextEditingController(text: 'Ezedine');
  final _emailController = TextEditingController(text: 'ezedine@example.com');
  final _phoneController = TextEditingController(text: '+33 6 12 34 56 78');
  String _selectedGender = 'Homme';
  DateTime _selectedDate = DateTime(1995, 6, 15);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
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
            // Avatar Section
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient(context),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary(context).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'E',
                        style: AppleTheme.largeTitle.copyWith(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        // TODO: Change photo
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary(context),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.background(context),
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          CupertinoIcons.camera_fill,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Basic Info Section
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
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: CupertinoIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _buildDivider(),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Téléphone',
                    icon: CupertinoIcons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Personal Details Section
            AppleSectionHeader(title: 'Détails personnels'),
            const SizedBox(height: 8),
            AppleCard(
              child: Column(
                children: [
                  _buildPickerRow(
                    label: 'Genre',
                    value: _selectedGender,
                    icon: CupertinoIcons.person_2,
                    onTap: () => _showGenderPicker(),
                  ),
                  _buildDivider(),
                  _buildPickerRow(
                    label: 'Date de naissance',
                    value:
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    icon: CupertinoIcons.calendar,
                    onTap: () => _showDatePicker(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Save Button
            AppleButton(
              text: 'Enregistrer les modifications',
              onPressed: () {
                HapticFeedback.mediumImpact();
                _saveChanges();
              },
            ),
            const SizedBox(height: 16),

            // Delete Account Button
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                HapticFeedback.lightImpact();
                _showDeleteAccountDialog();
              },
              child: Text(
                'Supprimer le compte',
                style: AppleTheme.body.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
      color: AppColors.divider(context).withOpacity(0.3),
      indent: 50,
    );
  }

  void _showGenderPicker() {
    final options = ['Homme', 'Femme', 'Autre'];

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250,
        color: AppColors.surface(context),
        child: Column(
          children: [
            Container(
              height: 44,
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
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: const Text(
                      'Terminé',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 44,
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedGender = options[index];
                  });
                },
                children: options
                    .map((option) => Center(child: Text(option)))
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
          initialDateTime: _selectedDate,
          maximumDate: DateTime.now(),
          onDateTimeChanged: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
        ),
      ),
    );
  }

  void _saveChanges() {
    // TODO: Save to backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Modifications enregistrées'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Supprimer le compte'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.',
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              // TODO: Delete account
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
