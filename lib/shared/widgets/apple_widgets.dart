import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // HapticFeedback
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final content = Container(
      padding: padding ?? const EdgeInsets.all(AppleTheme.spacing20),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface(context),
        borderRadius: BorderRadius.circular(AppleTheme.radiusXLarge),
        border: Border.all(
          color: AppColors.divider(context).withOpacity(0.3),
          width: 0.5,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
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
    Color bgColor = backgroundColor ?? AppColors.primary(context);
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
          borderRadius: BorderRadius.circular(
            AppleTheme.radiusButton,
          ), // iOS 18: 12pt
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
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: AppleTheme.caption1.copyWith(
                color: AppleTheme.adaptiveSecondaryLabel(context),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (trailing != null)
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onTrailingTap,
              child: Text(
                trailing!,
                style: AppleTheme.subhead.copyWith(
                  color: AppColors.primary(context),
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
                    style: AppleTheme.body.copyWith(
                      color: AppleTheme.adaptiveLabel(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: AppleTheme.footnote.copyWith(
                        color: AppleTheme.adaptiveSecondaryLabel(context),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            ?trailing,
            if (showChevron)
              Icon(
                CupertinoIcons.chevron_right,
                color: AppleTheme.adaptiveTertiaryLabel(context),
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
        color:
            backgroundColor ??
            AppColors.primary(context).withOpacity(0.12), // iOS 18: Plus subtil
        borderRadius: BorderRadius.circular(8), // iOS 18: 8pt
      ),
      child: Text(
        text,
        style: AppleTheme.caption1.copyWith(
          color: textColor ?? AppColors.primary(context),
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
      backgroundColor: AppleTheme.adaptiveBackground(context).withOpacity(0.9),
      border: Border(
        bottom: BorderSide(
          color: AppleTheme.adaptiveSeparator(context).withOpacity(0.3),
          width: 0.5,
        ),
      ),
      leading: onBack != null
          ? CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onBack,
              child: Icon(
                CupertinoIcons.back,
                color: AppColors.primary(context),
              ),
            )
          : null,
      middle: Text(
        title,
        style: (isLargeTitle ? AppleTheme.largeTitle : AppleTheme.headline)
            .copyWith(color: AppleTheme.adaptiveLabel(context)),
      ),
      trailing: actions != null
          ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44);
}

/// 🍎 iOS 18 2026 Style Quick Action Card - Modern & Professional
class AppleQuickActionCard extends StatefulWidget {
  final IconData icon; // Icons modernes au lieu d'emojis
  final String title;
  final String subtitle;
  final bool isPrimary; // Hiérarchie visuelle
  final bool isHero; // Mode Hero (full width, extra large)
  final VoidCallback? onTap;

  const AppleQuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isPrimary = false, // Secondaire par défaut
    this.isHero = false, // Hero désactivé par défaut
    this.onTap,
  });

  @override
  State<AppleQuickActionCard> createState() => _AppleQuickActionCardState();
}

class _AppleQuickActionCardState extends State<AppleQuickActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = AppColors.primary(context); // Couleur unifiée teal
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final isLarge = widget.isPrimary || widget.isHero;
    
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: EdgeInsets.all(widget.isHero ? 24 : (widget.isPrimary ? 22 : 18)),
          decoration: BoxDecoration(
            gradient: isLarge
                ? LinearGradient(
                    colors: [
                      accentColor.withOpacity(isDark ? 0.15 : 0.08),
                      accentColor.withOpacity(isDark ? 0.08 : 0.04),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isLarge ? null : AppColors.surface(context),
            borderRadius: BorderRadius.circular(widget.isHero ? 22 : 20),
            border: Border.all(
              color: accentColor.withOpacity(isLarge ? 0.25 : 0.12),
              width: widget.isHero ? 2.0 : (widget.isPrimary ? 1.5 : 0.5),
            ),
            boxShadow: isLarge
                ? [
                    BoxShadow(
                      color: accentColor.withOpacity(widget.isHero ? 0.2 : 0.15),
                      blurRadius: widget.isHero ? 16 : 12,
                      offset: Offset(0, widget.isHero ? 6 : 4),
                    ),
                  ]
                : null,
          ),
          child: widget.isHero
              ? Row(
                  children: [
                    // Hero Icon Container
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            accentColor.withOpacity(0.25),
                            accentColor.withOpacity(0.15),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        widget.icon,
                        size: 32,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Hero Text Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: AppleTheme.title3.copyWith(
                              color: AppleTheme.adaptiveLabel(context),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle,
                            style: AppleTheme.callout.copyWith(
                              color: AppleTheme.adaptiveSecondaryLabel(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Hero Chevron
                    Icon(
                      CupertinoIcons.chevron_right,
                      color: accentColor,
                      size: 20,
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Standard Icon Container
                    Container(
                      width: widget.isPrimary ? 56 : 48,
                      height: widget.isPrimary ? 56 : 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            accentColor.withOpacity(0.2),
                            accentColor.withOpacity(0.12),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        widget.icon,
                        size: widget.isPrimary ? 28 : 24,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Standard Text
                    Text(
                      widget.title,
                      style: (widget.isPrimary
                              ? AppleTheme.calloutEmphasized
                              : AppleTheme.callout)
                          .copyWith(
                        color: AppleTheme.adaptiveLabel(context),
                        fontWeight:
                            widget.isPrimary ? FontWeight.w700 : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style: AppleTheme.caption1.copyWith(
                        color: AppleTheme.adaptiveSecondaryLabel(context),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
