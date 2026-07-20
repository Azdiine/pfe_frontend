import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// 🎨 Premium UI Components
/// Ready-to-use widgets following the design system

class PremiumButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final ButtonStyle style;
  final bool isLoading;

  const PremiumButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.style = ButtonStyle.primary,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = _getGradient(context);

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.elevation2(false),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null && !isLoading) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
            ],
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            if (isLoading) const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _getGradient(BuildContext context) {
    switch (style) {
      case ButtonStyle.primary:
        return AppColors.primaryGradient(context);
      case ButtonStyle.secondary:
        return AppColors.primaryGradient(context);
      case ButtonStyle.ai:
        return AppColors.aiGradient(context);
      case ButtonStyle.premium:
        return AppColors.lightPrimaryGradient;
    }
  }
}

enum ButtonStyle { primary, secondary, ai, premium }

/// 🎴 Premium Card Widget
class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final LinearGradient? gradient;
  final bool elevated;
  final VoidCallback? onTap;

  const PremiumCard({
    super.key,
    required this.child,
    this.padding,
    this.gradient,
    this.elevated = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? AppColors.lightSurface : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: elevated ? AppColors.elevation1(false) : null,
        ),
        child: child,
      ),
    );
  }
}

/// 📊 Stat Card with Icon
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary(context);
    final effectiveBg = backgroundColor ?? effectiveColor.withValues(alpha: 0.1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.elevation1(false),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: effectiveBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: effectiveColor, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🏷️ Premium Badge
class PremiumBadge extends StatelessWidget {
  final String text;
  final BadgeStyle style;

  const PremiumBadge({
    super.key,
    required this.text,
    this.style = BadgeStyle.success,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: config.gradient,
        color: config.color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: (config.color ?? Colors.black).withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  _BadgeConfig _getConfig(BuildContext context) {
    switch (style) {
      case BadgeStyle.success:
        return _BadgeConfig(color: AppColors.success);
      case BadgeStyle.warning:
        return _BadgeConfig(color: AppColors.warning);
      case BadgeStyle.error:
        return _BadgeConfig(color: AppColors.error);
      case BadgeStyle.premium:
        return _BadgeConfig(gradient: AppColors.aiGradient(context));
      case BadgeStyle.ai:
        return _BadgeConfig(gradient: AppColors.aiGradient(context));
    }
  }
}

class _BadgeConfig {
  final Color? color;
  final LinearGradient? gradient;

  _BadgeConfig({this.color, this.gradient});
}

enum BadgeStyle { success, warning, error, premium, ai }

/// 🍔 Recipe Card Example
class RecipeCard extends StatelessWidget {
  final String emoji;
  final String name;
  final String time;
  final int calories;
  final VoidCallback onTap;
  final bool isFavorite;

  const RecipeCard({
    super.key,
    required this.emoji,
    required this.name,
    required this.time,
    required this.calories,
    required this.onTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.elevation2(false),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 48)),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.local_fire_department,
                        size: 16,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$calories kcal',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 💬 AI Chat Bubble
class AIChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const AIChatBubble({super.key, required this.message, this.isUser = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isUser ? null : AppColors.aiGradient(context),
          color: isUser ? AppColors.lightSurface : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.elevation1(false),
        ),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isUser ? AppColors.textPrimary(context) : Colors.white,
          ),
        ),
      ),
    );
  }
}

/// 📈 Progress Bar with Gradient
class PremiumProgressBar extends StatelessWidget {
  final double value;
  final String? label;
  final LinearGradient? gradient;

  const PremiumProgressBar({
    super.key,
    required this.value,
    this.label,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary(context),
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.lightTextDisabled,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            widthFactor: value.clamp(0.0, 1.0),
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                gradient: gradient ?? AppColors.primaryGradient(context),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary(context).withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
