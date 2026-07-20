import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/theme/app_colors.dart';

/// 🌍 Sélecteur de Langue - Bouton Toggle French/English
///
/// Widget moderne avec animation fluide pour changer de langue
/// Affiche le drapeau et le code de langue actuel
class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final notifier = ref.read(localeProvider.notifier);

    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: AppColors.lightSurface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary(context).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary(context).withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            notifier.toggleLanguage();
            // Haptic feedback
            HapticFeedback.lightImpact();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drapeau
                Text(
                  notifier.currentLanguageFlag,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 6),
                // Code langue
                Text(
                  locale.languageCode.toUpperCase(),
                  style: TextStyle(
                    color: AppColors.primary(context),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 4),
                // Icône de changement
                Icon(
                  Icons.swap_horiz_rounded,
                  color: AppColors.secondary(context),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 🌍 Version compacte: seulement drapeau + code langue
class CompactLanguageSelector extends ConsumerWidget {
  const CompactLanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(localeProvider.notifier);
    final locale = ref.watch(localeProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 4),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          notifier.toggleLanguage();
          HapticFeedback.lightImpact();
        }, minimumSize: Size(0, 0),
        child: Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated(context).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.divider(context).withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                notifier.currentLanguageFlag,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 5),
              Text(
                locale.languageCode.toUpperCase(),
                style: TextStyle(
                  color: AppColors.primary(context),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
