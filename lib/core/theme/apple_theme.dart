import 'package:flutter/material.dart';

/// 🍎 Apple iOS 18 Design System (2024-2025)
/// Style officiel iOS 18 avec animations modernes, couleurs saturées et spacing généreux

class AppleTheme {
  // ========================================
  // 📱 TYPOGRAPHY - SF Pro Display (iOS 18)
  // Plus de variants, hiérarchie renforcée
  // ========================================

  /// Large Title (iOS Navigation Bar) - Plus imposant
  static const TextStyle largeTitle = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.41,
    height: 1.18,
  );

  /// Large Title Emphasized (iOS 18)
  static const TextStyle largeTitleEmphasized = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.41,
    height: 1.18,
  );

  /// Title 1 - Headers principaux
  static const TextStyle title1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.36,
    height: 1.25,
  );

  /// Title 2 - Sections
  static const TextStyle title2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.35,
    height: 1.28,
  );

  /// Title 3 - Sous-sections
  static const TextStyle title3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.38,
    height: 1.25,
  );

  /// Headline - Important text
  static const TextStyle headline = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.41,
    height: 1.29,
  );

  /// Body - Texte principal
  static const TextStyle body = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.41,
    height: 1.41,
  );

  /// Body Emphasized (iOS 18)
  static const TextStyle bodyEmphasized = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.41,
    height: 1.41,
  );

  /// Callout - Descriptif important
  static const TextStyle callout = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.32,
    height: 1.31,
  );

  /// Callout Emphasized (iOS 18)
  static const TextStyle calloutEmphasized = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.32,
    height: 1.31,
  );

  /// Subhead - Labels secondaires
  static const TextStyle subhead = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.24,
    height: 1.33,
  );

  /// Subhead Emphasized (iOS 18)
  static const TextStyle subheadEmphasized = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.24,
    height: 1.33,
  );

  /// Footnote - Infos helper
  static const TextStyle footnote = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.08,
    height: 1.38,
  );

  /// Caption 1 - Petits textes
  static const TextStyle caption1 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.33,
  );

  /// Caption 2 - Timestamp, metadata
  static const TextStyle caption2 = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.07,
    height: 1.36,
  );

  // ========================================
  // 🎨 SPACING - iOS 18 Generous Grid (20-24pt par défaut)
  // ========================================

  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0; // iOS 18 default
  static const double spacing24 = 24.0; // iOS 18 sections
  static const double spacing28 = 28.0; // iOS 18 large gaps
  static const double spacing32 = 32.0;
  static const double spacing44 = 44.0; // iOS tap target minimum
  static const double spacing60 = 60.0;

  // ========================================
  // 🔘 BORDER RADIUS - iOS 18 (Plus ronds: 14-16pt)
  // ========================================

  static const double radiusSmall = 10.0; // iOS 18: 10pt min
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 14.0; // iOS 18: 14pt cards
  static const double radiusXLarge = 16.0; // iOS 18: 16pt prominent
  static const double radiusCard = 14.0; // iOS 18 default card
  static const double radiusButton = 12.0; // iOS 18 buttons plus ronds

  // ========================================
  // 🎯 SHADOWS - iOS 18 Ultra-Subtle (2-3% opacity)
  // ========================================

  /// Ultra-subtle shadow pour les cards iOS 18
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.02),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.01),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  /// Shadow douce pour les éléments flottants iOS 18
  static List<BoxShadow> get floatingShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.02),
      blurRadius: 40,
      offset: const Offset(0, 8),
    ),
  ];

  /// Shadow prononcée pour modals iOS 18
  static List<BoxShadow> get modalShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 40,
      offset: const Offset(0, 16),
    ),
  ];

  // ========================================
  // 🎬 ANIMATIONS - iOS 18 Spring Curves
  // ========================================

  /// Spring curve iOS 18 (rebond naturel)
  static const Curve iosSpringCurve = Curves.easeOutCubic;

  /// Curve standard iOS
  static const Curve iosCurve = Curves.easeInOut;

  /// Smooth curve iOS 18 (ultra fluide)
  static const Curve iosSmoothCurve = Curves.easeInOutCubic;

  static const Duration iosAnimationDuration = Duration(
    milliseconds: 350,
  ); // iOS 18: 350ms
  static const Duration iosQuickAnimation = Duration(milliseconds: 200);
  static const Duration iosSpringAnimation = Duration(
    milliseconds: 400,
  ); // iOS 18 spring

  // ========================================
  // 🔲 DIVIDERS - iOS 18 Ultra-Thin (0.33pt)
  // ========================================

  /// Divider ultra-fin iOS 18
  static Widget divider({bool isDark = false}) {
    return Container(
      height: 0.33, // iOS 18: 0.33pt
      color: isDark
          ? Colors.white.withOpacity(0.12)
          : Colors.black.withOpacity(0.08),
    );
  }

  /// Vertical divider ultra-fin iOS 18
  static Widget verticalDivider({bool isDark = false}) {
    return Container(
      width: 0.33, // iOS 18: 0.33pt
      color: isDark
          ? Colors.white.withOpacity(0.12)
          : Colors.black.withOpacity(0.08),
    );
  }

  // ========================================
  // 🎨 COLORS - iOS 18 System Colors (Plus saturées)
  // ========================================

  /// iOS System Blue - Plus vibrant iOS 18
  static const Color systemBlue = Color(0xFF007AFF);

  /// iOS System Teal (Nouveau iOS 18)
  static const Color systemTeal = Color(0xFF30D158);

  /// iOS System Cyan (Nouveau iOS 18)
  static const Color systemCyan = Color(0xFF32ADE6);

  /// iOS System Green - Plus saturé iOS 18
  static const Color systemGreen = Color(0xFF32D74B);

  /// iOS System Orange
  static const Color systemOrange = Color(0xFFFF9500);

  /// iOS System Red
  static const Color systemRed = Color(0xFFFF3B30);

  /// iOS System Purple - Plus vibrant iOS 18
  static const Color systemPurple = Color(0xFFBF5AF2);

  /// iOS System Pink (iOS 18)
  static const Color systemPink = Color(0xFFFF2D55);

  /// iOS System Gray
  static const Color systemGray = Color(0xFF8E8E93);

  /// iOS System Gray 2
  static const Color systemGray2 = Color(0xFFAEAEB2);

  /// iOS System Gray 3
  static const Color systemGray3 = Color(0xFFC7C7CC);

  /// iOS System Gray 4
  static const Color systemGray4 = Color(0xFFD1D1D6);

  /// iOS System Gray 5
  static const Color systemGray5 = Color(0xFFE5E5EA);

  /// iOS System Gray 6
  static const Color systemGray6 = Color(0xFFF2F2F7);

  /// iOS Label (Primary text)
  static const Color label = Color(0xFF000000);

  /// iOS Secondary Label
  static const Color secondaryLabel = Color(0x99000000); // 60% opacity

  /// iOS Tertiary Label
  static const Color tertiaryLabel = Color(0x4D000000); // 30% opacity

  /// iOS Quaternary Label
  static const Color quaternaryLabel = Color(0x33000000); // 18% opacity

  /// iOS Separator (iOS 18: Plus subtil)
  static const Color separator = Color(0x3D000000); // 24% opacity

  /// iOS Opaque Separator
  static const Color opaqueSeparator = Color(0xFFC6C6C8);

  // Dark Mode equivalents
  static const Color labelDark = Color(0xFFFFFFFF);
  static const Color secondaryLabelDark = Color(0x99FFFFFF);
  static const Color tertiaryLabelDark = Color(0x4DFFFFFF);
  static const Color quaternaryLabelDark = Color(0x33FFFFFF);
  static const Color separatorDark = Color(0x54FFFFFF);
  static const Color opaqueSeparatorDark = Color(0xFF38383A);

  // ========================================
  // 🎨 BACKGROUNDS - iOS System Backgrounds
  // ========================================

  /// iOS Primary Background (Light)
  static const Color backgroundLight = Color(0xFFFFFFFF);

  /// iOS Secondary Background (Light)
  static const Color secondaryBackgroundLight = Color(0xFFF2F2F7);

  /// iOS Tertiary Background (Light)
  static const Color tertiaryBackgroundLight = Color(0xFFFFFFFF);

  /// iOS Grouped Background (Light)
  static const Color groupedBackgroundLight = Color(0xFFF2F2F7);

  /// iOS Secondary Grouped Background (Light)
  static const Color secondaryGroupedBackgroundLight = Color(0xFFFFFFFF);

  // Dark Mode
  static const Color backgroundDark = Color(0xFF000000);
  static const Color secondaryBackgroundDark = Color(0xFF1C1C1E);
  static const Color tertiaryBackgroundDark = Color(0xFF2C2C2E);
  static const Color groupedBackgroundDark = Color(0xFF000000);
  static const Color secondaryGroupedBackgroundDark = Color(0xFF1C1C1E);

  // ========================================
  // 🎯 ADAPTIVE HELPERS - Auto light/dark
  // ========================================

  /// Adaptive label (primary text) — black in light, white in dark
  static Color adaptiveLabel(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? labelDark
        : label;
  }

  /// Adaptive secondary label
  static Color adaptiveSecondaryLabel(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? secondaryLabelDark
        : secondaryLabel;
  }

  /// Adaptive tertiary label
  static Color adaptiveTertiaryLabel(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? tertiaryLabelDark
        : tertiaryLabel;
  }

  /// Adaptive quaternary label
  static Color adaptiveQuaternaryLabel(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? quaternaryLabelDark
        : quaternaryLabel;
  }

  /// Adaptive separator
  static Color adaptiveSeparator(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? separatorDark
        : separator;
  }

  /// Adaptive background
  static Color adaptiveBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? backgroundDark
        : backgroundLight;
  }

  /// Adaptive secondary background
  static Color adaptiveSecondaryBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? secondaryBackgroundDark
        : secondaryBackgroundLight;
  }

  /// Adaptive grouped background
  static Color adaptiveGroupedBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? groupedBackgroundDark
        : groupedBackgroundLight;
  }
}
