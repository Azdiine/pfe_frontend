import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/theme_provider.dart';

/// Style options for the theme switcher widget
enum ThemeSwitcherStyle {
  /// Icon button with sun/moon icons
  iconButton,

  /// Switch toggle
  toggle,

  /// Full button with text
  button,
}

/// A widget that allows users to switch between light and dark themes
///
/// Usage:
/// ```dart
/// // Icon button (default)
/// ThemeSwitcher()
///
/// // Toggle switch
/// ThemeSwitcher(style: ThemeSwitcherStyle.toggle)
///
/// // Full button
/// ThemeSwitcher(style: ThemeSwitcherStyle.button)
/// ```
class ThemeSwitcher extends ConsumerWidget {
  final ThemeSwitcherStyle style;
  final double? iconSize;

  const ThemeSwitcher({
    super.key,
    this.style = ThemeSwitcherStyle.iconButton,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    switch (style) {
      case ThemeSwitcherStyle.iconButton:
        return _IconButtonStyle(
          isDark: isDark,
          onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
          iconSize: iconSize ?? 24,
        );
      case ThemeSwitcherStyle.toggle:
        return _ToggleStyle(
          isDark: isDark,
          onChanged: (value) =>
              ref.read(themeModeProvider.notifier).toggleTheme(),
        );
      case ThemeSwitcherStyle.button:
        return _ButtonStyle(
          isDark: isDark,
          onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
        );
    }
  }
}

/// Icon button style implementation
class _IconButtonStyle extends StatelessWidget {
  final bool isDark;
  final VoidCallback onPressed;
  final double iconSize;

  const _IconButtonStyle({
    required this.isDark,
    required this.onPressed,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return RotationTransition(
            turns: animation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: Icon(
          isDark ? Icons.light_mode : Icons.dark_mode,
          key: ValueKey(isDark),
          size: iconSize,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.amber
              : Colors.grey[700],
        ),
      ),
      tooltip: isDark ? 'Mode clair' : 'Mode sombre',
    );
  }
}

/// Toggle switch style implementation
class _ToggleStyle extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const _ToggleStyle({required this.isDark, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.light_mode,
          size: 20,
          color: !isDark ? Colors.amber : Colors.grey,
        ),
        const SizedBox(width: 8),
        Switch(value: isDark, onChanged: onChanged, activeColor: Colors.amber),
        const SizedBox(width: 8),
        Icon(
          Icons.dark_mode,
          size: 20,
          color: isDark ? Colors.amber : Colors.grey,
        ),
      ],
    );
  }
}

/// Full button style implementation
class _ButtonStyle extends StatelessWidget {
  final bool isDark;
  final VoidCallback onPressed;

  const _ButtonStyle({required this.isDark, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, size: 20),
      label: Text(
        isDark ? 'Mode clair' : 'Mode sombre',
        style: const TextStyle(fontSize: 14),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
