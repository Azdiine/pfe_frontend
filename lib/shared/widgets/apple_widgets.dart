import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme/apple_theme.dart';
import '../../core/theme/app_colors.dart';

/// 🍎 iOS 18 Style Widgets (2024-2025)
/// Composants modernes avec spacing généreux et radius plus ronds

/// 🍎 iOS 18 Style Card (Radius 14pt, Shadows ultra-subtiles)
class AppleCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool isGrouped;

  const AppleCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.onTap,
    this.isGrouped = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding ?? const EdgeInsets.all(AppleTheme.spacing20), // iOS 18: 20pt
      decoration: BoxDecoration(
        color: backgroundColor ?? AppleTheme.backgroundLight,
        borderRadius: BorderRadius.circular(AppleTheme.radiusCard), // iOS 18: 14pt
        border: Border.all(
          color: AppleTheme.separator.withOpacity(0.2), // iOS 18: Plus subtil
          width: 0.5,
        ),
        boxShadow: AppleTheme.cardShadow, // iOS 18: Ultra-subtle
      ),
      child: child,
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
}

/// 🍎 iOS 18 Style Button (Plus de padding, radius 12pt)
class AppleButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLarge;
  final bool isDestructive;
  final IconData? icon;
  final bool isLoading;

  const AppleButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isLarge = false,
    this.isDestructive = false,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = backgroundColor ?? AppColors.lightPrimary;
    if (isDestructive) {
      bgColor = AppleTheme.systemRed;
    }

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: AppleTheme.iosQuickAnimation,
        curve: AppleTheme.iosSpringCurve, // iOS 18 spring
        height: isLarge ? 54 : 50, // iOS 18: Plus de hauteur
        decoration: BoxDecoration(
          color: onPressed == null ? bgColor.withOpacity(0.5) : bgColor,
          borderRadius: BorderRadius.circular(AppleTheme.radiusButton), // iOS 18: 12pt
          boxShadow: onPressed != null ? AppleTheme.cardShadow : null,
        ),
        child: Center(
          child: isLoading
              ? const CupertinoActivityIndicator(color: Colors.white)
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: textColor ?? Colors.white, size: 20),
                      const SizedBox(width: AppleTheme.spacing8),
                    ],
                    Text(
                      text,
                      style: AppleTheme.headline.copyWith(
                        color: textColor ?? Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// 🍎 iOS 18 Style Section Header (Spacing 24pt)
class AppleSectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;
  final VoidCallback? onTrailingTap;

  const AppleSectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppleTheme.spacing20, // iOS 18: 20pt
        AppleTheme.spacing28, // iOS 18: 28pt large gap
        AppleTheme.spacing20,
        AppleTheme.spacing8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: AppleTheme.caption1.copyWith( // iOS 18: Caption1 (12pt)
              color: AppleTheme.secondaryLabel,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6, // iOS 18: Plus espacé
            ),
          ),
          if (trailing != null)
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onTrailingTap,
              child: Text(
                trailing!,
                style: AppleTheme.subhead.copyWith(
                  color: AppColors.lightPrimary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 🍎 iOS 18 Style List Tile (Plus de padding)
class AppleListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;

  const AppleListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppleTheme.spacing20, // iOS 18: 20pt
          vertical: AppleTheme.spacing16, // iOS 18: 16pt (plus généreux)
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: AppleTheme.spacing16), // iOS 18: 16pt
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppleTheme.body.copyWith(color: AppleTheme.label),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: AppleTheme.footnote.copyWith(
                        color: AppleTheme.secondaryLabel,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
            if (showChevron)
              const Icon(
                CupertinoIcons.chevron_right,
                color: AppleTheme.tertiaryLabel,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}

/// 🍎 iOS 18 Style Badge (Radius 8pt)
class AppleBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;

  const AppleBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppleTheme.spacing12, // iOS 18: 12pt
        vertical: 6, // iOS 18: Plus de hauteur
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.lightPrimary.withOpacity(0.12), // iOS 18: Plus subtil
        borderRadius: BorderRadius.circular(8), // iOS 18: 8pt
      ),
      child: Text(
        text,
        style: AppleTheme.caption1.copyWith(
          color: textColor ?? AppColors.lightPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// 🍎 iOS Style Navigation Bar
class AppleNavigationBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool isLargeTitle;

  const AppleNavigationBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions,
    this.isLargeTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      backgroundColor: AppleTheme.backgroundLight.withOpacity(0.9),
      border: Border(
        bottom: BorderSide(
          color: AppleTheme.separator.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      leading: onBack != null
          ? CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onBack,
              child: const Icon(
                CupertinoIcons.back,
                color: AppColors.lightPrimary,
              ),
            )
          : null,
      middle: Text(
        title,
        style: (isLargeTitle ? AppleTheme.largeTitle : AppleTheme.headline)
            .copyWith(color: AppleTheme.label),
      ),
      trailing: actions != null
          ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44);
}

/// 🍎 iOS 18 Style Quick Action Card (Radius 14pt, shadows)
class AppleQuickActionCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback? onTap;

  const AppleQuickActionCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppleTheme.spacing20), // iOS 18: 20pt
        decoration: BoxDecoration(
          color: AppleTheme.backgroundLight,
          borderRadius: BorderRadius.circular(AppleTheme.radiusCard), // iOS 18: 14pt
          border: Border.all(
            color: accentColor.withOpacity(0.15), // iOS 18: Plus subtil
            width: 1,
          ),
          boxShadow: AppleTheme.cardShadow, // iOS 18: Ultra-subtle
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 52, // iOS 18: Plus grand
              height: 52,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12), // iOS 18: Plus subtil
                borderRadius: BorderRadius.circular(14), // iOS 18: 14pt
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 26)), // iOS 18: Plus grand
              ),
            ),
            const SizedBox(height: AppleTheme.spacing16),
            Text(
              title,
              style: AppleTheme.calloutEmphasized.copyWith( // iOS 18: CalloutEmphasized
                color: AppleTheme.label,
              ),
            ),
            Text(
              subtitle,
              style: AppleTheme.caption1.copyWith(
                color: AppleTheme.secondaryLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
