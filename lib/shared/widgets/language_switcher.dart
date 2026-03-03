import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/locale_provider.dart';
import '../../l10n/generated/app_localizations.dart';

/// A widget that displays language options and allows switching between them
/// Can be used in settings page, app bar, or any other location
class LanguageSwitcher extends ConsumerWidget {
  /// Style of the language switcher
  final LanguageSwitcherStyle style;

  /// Whether to show as a dialog instead of bottom sheet
  final bool useDialog;

  const LanguageSwitcher({
    super.key,
    this.style = LanguageSwitcherStyle.button,
    this.useDialog = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context);

    switch (style) {
      case LanguageSwitcherStyle.button:
        return _buildButton(context, ref, currentLocale, l10n);
      case LanguageSwitcherStyle.tile:
        return _buildListTile(context, ref, currentLocale, l10n);
      case LanguageSwitcherStyle.iconButton:
        return _buildIconButton(context, ref, currentLocale, l10n);
      case LanguageSwitcherStyle.chip:
        return _buildChip(context, ref, currentLocale);
    }
  }

  /// Build as elevated button
  Widget _buildButton(
      BuildContext context, WidgetRef ref, Locale locale, AppLocalizations l10n) {
    return ElevatedButton.icon(
      onPressed: () => _showLanguageSelector(context, ref),
      icon: Text(
        SupportedLocales.getFlagEmoji(locale),
        style: const TextStyle(fontSize: 20),
      ),
      label: Text(SupportedLocales.getLanguageName(locale)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  /// Build as list tile for settings page
  Widget _buildListTile(
      BuildContext context, WidgetRef ref, Locale locale, AppLocalizations l10n) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n.language),
      subtitle: Text(SupportedLocales.getLanguageName(locale)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            SupportedLocales.getFlagEmoji(locale),
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
      onTap: () => _showLanguageSelector(context, ref),
    );
  }

  /// Build as icon button for app bar
  Widget _buildIconButton(
      BuildContext context, WidgetRef ref, Locale locale, AppLocalizations l10n) {
    return IconButton(
      onPressed: () => _showLanguageSelector(context, ref),
      icon: Text(
        SupportedLocales.getFlagEmoji(locale),
        style: const TextStyle(fontSize: 28),
      ),
      tooltip: l10n.language,
    );
  }

  /// Build as chip
  Widget _buildChip(BuildContext context, WidgetRef ref, Locale locale) {
    return ActionChip(
      avatar: Text(
        SupportedLocales.getFlagEmoji(locale),
        style: const TextStyle(fontSize: 18),
      ),
      label: Text(locale.languageCode.toUpperCase()),
      onPressed: () => _showLanguageSelector(context, ref),
    );
  }

  /// Show language selector bottom sheet or dialog
  void _showLanguageSelector(BuildContext context, WidgetRef ref) {
    if (useDialog) {
      _showLanguageDialog(context, ref);
    } else {
      _showLanguageBottomSheet(context, ref);
    }
  }

  /// Show language selector as bottom sheet
  void _showLanguageBottomSheet(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final currentLocale = ref.watch(localeProvider);

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.selectLanguage,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                ...SupportedLocales.all.map((locale) {
                  final isSelected = currentLocale.languageCode == locale.languageCode;
                  return _LanguageOption(
                    locale: locale,
                    isSelected: isSelected,
                    onTap: () async {
                      await ref.read(localeProvider.notifier).setLocale(locale);
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.languageChanged),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Show language selector as dialog
  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final currentLocale = ref.watch(localeProvider);

          return AlertDialog(
            title: Text(l10n.selectLanguage),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: SupportedLocales.all.map((locale) {
                final isSelected = currentLocale.languageCode == locale.languageCode;
                return _LanguageOption(
                  locale: locale,
                  isSelected: isSelected,
                  onTap: () async {
                    await ref.read(localeProvider.notifier).setLocale(locale);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.languageChanged),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

/// Language switcher display styles
enum LanguageSwitcherStyle {
  /// Elevated button with flag and language name
  button,

  /// List tile for settings page
  tile,

  /// Icon button with flag emoji
  iconButton,

  /// Chip with flag and language code
  chip,
}

/// Individual language option widget
class _LanguageOption extends StatelessWidget {
  final Locale locale;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.locale,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              SupportedLocales.getFlagEmoji(locale),
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    SupportedLocales.getLanguageName(locale),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                  ),
                  Text(
                    locale.languageCode.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

/// Quick toggle button that switches between EN/FR instantly
class QuickLanguageToggle extends ConsumerWidget {
  const QuickLanguageToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageButton(
            context,
            ref,
            SupportedLocales.french,
            currentLocale.languageCode == 'fr',
          ),
          _buildLanguageButton(
            context,
            ref,
            SupportedLocales.english,
            currentLocale.languageCode == 'en',
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(
    BuildContext context,
    WidgetRef ref,
    Locale locale,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () => ref.read(localeProvider.notifier).setLocale(locale),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              SupportedLocales.getFlagEmoji(locale),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 4),
            Text(
              locale.languageCode.toUpperCase(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
