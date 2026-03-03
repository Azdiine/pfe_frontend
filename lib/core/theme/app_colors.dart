import 'package:flutter/material.dart';

/// 🎨 UNIFIED DESIGN SYSTEM — 2026 Professional Edition
/// AI-Powered Food & Smart Fridge App
/// 
/// 🎯 DESIGN STRATEGY (Senior UX Designer):
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// ONE PRIMARY COLOR SYSTEM - Maximum cohesion & brand recognition
///
/// ✅ WHY MONOCHROME TEAL?
/// • Fresh & Health: Teal signals freshness, health, organic quality
/// • Food-Safe: Calming, premium, associated with natural/healthy foods
/// • Accessibility: Excellent contrast ratios (AAA compliant)
/// • Modern: Deliveroo, Whole Foods, health apps use teal for trust
/// • Versatility: Works perfectly for food, fridge, nutrition context
///
/// 🎨 COLOR PHILOSOPHY:
/// Primary Teal (#14B8A6): ALL CTAs, progress, selections, active states, AI features
/// Secondary Teal: Unified with primary for maximum cohesion
/// Neutrals: Text hierarchy, surfaces, shadows
/// Semantic: Green (success), Red (error), Amber (warning) - Universal standards
///
/// 🚫 REMOVED:
/// ❌ Deep Blue/Indigo (too corporate, tech-heavy)
/// ❌ Orange/Amber accent (food cliché, aggressive)
/// ❌ Multiple brand colors (cognitive overload)
///
/// 📐 IMPLEMENTATION:
/// - Primary Teal: 95% of ALL interactive elements (buttons, links, selections, AI)
/// - Secondary Teal: Unified with primary for cohesion
/// - Semantic: 5% for status feedback only (success/error/warning)
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class AppColors {
  // ========================================
  // 🌟 LIGHT MODE - PRIMARY COLORS
  // ========================================

  /// Primary: Modern Teal
  /// Psychology: Fresh, modern, health-focused, innovation
  /// Usage: ALL CTAs, buttons, links, progress bars, selections
  /// Contrast: AAA on white (8.6:1)
  static const Color lightPrimary = Color(0xFF14B8A6); // Teal-600
  static const Color lightPrimaryVariant = Color(0xFF0D9488); // Teal-700 (hover)
  static const Color lightPrimaryLight = Color(0xFF2DD4BF); // Teal-500 (subtle)

  /// Secondary/Accent: Teal (unified with primary)
  /// Psychology: Cohesive, fresh, modern consistency
  /// Usage: All features including AI, premium badges, special highlights
  /// Use sparingly: 5% of interface maximum
  static const Color lightSecondary = Color(0xFF14B8A6); // Teal-600
  static const Color lightSecondaryVariant = Color(0xFF0D9488); // Teal-700
  static const Color lightSecondaryLight = Color(0xFF2DD4BF); // Teal-500

  // Accent removed - Using primary for all actions maintains consistency

  // ========================================
  // 🌙 DARK MODE - PRIMARY COLORS  
  // ========================================

  /// Primary: Bright Teal (OLED-optimized)
  /// Softer luminance for extended viewing, maintains brand consistency
  static const Color darkPrimary = Color(0xFF2DD4BF); // Teal-400
  static const Color darkPrimaryVariant = Color(0xFF14B8A6); // Teal-500
  static const Color darkPrimaryLight = Color(0xFF5EEAD4); // Teal-300

  /// Secondary/Accent: Soft Teal (unified with primary)
  /// All features including AI, gentle on eyes
  static const Color darkSecondary = Color(0xFF2DD4BF); // Teal-400
  static const Color darkSecondaryVariant = Color(0xFF14B8A6); // Teal-500
  static const Color darkSecondaryLight = Color(0xFF5EEAD4); // Teal-300

  // ========================================
  // 📄 LIGHT MODE - SURFACES & BACKGROUNDS
  // ========================================

  /// Background: Sophisticated Neutral
  /// Psychology: Breathable, modern, premium without coldness
  static const Color lightBackground = Color(0xFFFAFAFA); // Neutral gray
  static const Color lightBackgroundSecondary = Color(
    0xFFF5F5F5,
  ); // Slightly darker

  /// Surface: Crisp white for elevation
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFFFFFFF);

  /// Overlays for depth
  static const Color lightOverlay = Color(0x0A000000); // 4% black
  static const Color lightDivider = Color(0xFFE5E5E5); // Neutral-200

  // ========================================
  // 🌑 DARK MODE - SURFACES & BACKGROUNDS
  // ========================================

  /// Background: Rich dark (OLED-friendly)
  /// Psychology: Premium, immersive, reduces eye strain
  static const Color darkBackground = Color(0xFF0A0A0A); // Near black
  static const Color darkBackgroundSecondary = Color(
    0xFF171717,
  ); // Elevated dark

  /// Surface: Subtle elevation for cards
  static const Color darkSurface = Color(0xFF171717); // Dark neutral
  static const Color darkSurfaceElevated = Color(0xFF262626); // Lifted surface

  /// Overlays for depth
  static const Color darkOverlay = Color(0x14FFFFFF); // 8% white
  static const Color darkDivider = Color(0xFF404040); // Neutral-700

  // ========================================
  // 📝 LIGHT MODE - TEXT COLORS
  // ========================================

  static const Color lightTextPrimary = Color(
    0xFF0A0A0A,
  ); // Near black, not harsh
  static const Color lightTextSecondary = Color(0xFF737373); // Neutral-500
  static const Color lightTextTertiary = Color(0xFFA3A3A3); // Neutral-400
  static const Color lightTextDisabled = Color(0xFFD4D4D4); // Neutral-300
  static const Color lightTextOnPrimary = Color(0xFFFFFFFF);

  // ========================================
  // 📝 DARK MODE - TEXT COLORS
  // ========================================

  static const Color darkTextPrimary = Color(0xFFFAFAFA); // Neutral-50
  static const Color darkTextSecondary = Color(0xFFD4D4D4); // Neutral-300
  static const Color darkTextTertiary = Color(0xFFA3A3A3); // Neutral-400
  static const Color darkTextDisabled = Color(0xFF737373); // Neutral-500
  static const Color darkTextOnPrimary = Color(0xFF0A0A0A);

  // ========================================
  // ✅ STATUS COLORS (universal)
  // ========================================

  /// Success: Vibrant Green
  /// Psychology: Achievement, healthy choices, positive feedback
  static const Color success = Color(0xFF22C55E); // Green-500
  static const Color successLight = Color(0xFFDCFCE7); // Green-100
  static const Color successDark = Color(0xFF166534); // Green-800

  /// Warning: Warm Amber
  /// Psychology: Attention, expiring items, moderate urgency
  static const Color warning = Color(0xFFF59E0B); // Amber-500
  static const Color warningLight = Color(0xFFFEF3C7); // Amber-100
  static const Color warningDark = Color(0xFF92400E); // Amber-800

  /// Error: Vibrant Red
  /// Psychology: Danger, expired food, critical alerts
  static const Color error = Color(0xFFEF4444); // Red-500
  static const Color errorLight = Color(0xFFFEE2E2); // Red-100
  static const Color errorDark = Color(0xFF991B1B); // Red-800

  /// Info: Sky Blue
  /// Psychology: Information, tips, neutral notifications
  static const Color info = Color(0xFF3B82F6); // Blue-500
  static const Color infoLight = Color(0xFFDBEAFE); // Blue-100
  static const Color infoDark = Color(0xFF1E40AF); // Blue-800

  // ========================================
  // 🎨 GRADIENTS - LIGHT MODE (Teal Monochrome)
  // ========================================

  /// Primary Gradient (Teal Flow)
  /// Usage: Hero CTAs, onboarding, key actions
  static const LinearGradient lightPrimaryGradient = LinearGradient(
    colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// AI Intelligence Gradient (Teal Premium)
  /// Usage: Chatbot, AI features, premium badges - Unified with primary
  static const LinearGradient lightAIGradient = LinearGradient(
    colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Subtle Depth Gradient (Neutral elevation)
  /// Usage: Backgrounds, card overlays
  static const LinearGradient lightDepthGradient = LinearGradient(
    colors: [Color(0xFFFAFAFA), Color(0xFFF5F5F5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ========================================
  // 🌙 GRADIENTS - DARK MODE (OLED-Optimized Teal)
  // ========================================

  /// Primary Gradient (Soft Teal)
  static const LinearGradient darkPrimaryGradient = LinearGradient(
    colors: [Color(0xFF2DD4BF), Color(0xFF14B8A6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// AI Intelligence Gradient (Soft Teal)
  static const LinearGradient darkAIGradient = LinearGradient(
    colors: [Color(0xFF2DD4BF), Color(0xFF14B8A6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark Depth Gradient (Premium elevation)
  static const LinearGradient darkDepthGradient = LinearGradient(
    colors: [Color(0xFF171717), Color(0xFF0A0A0A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Fridge 3D Gradient (Cool & modern)
  /// Usage: Smart fridge screen background
  static const LinearGradient fridgeGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF0A0A0A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ========================================
  // 🎯 SCREEN-SPECIFIC COLOR USAGE
  // ========================================

  /// HOME SCREEN
  /// - Background: lightBackground / darkBackground
  /// - Cards: lightSurface with shadow / darkSurfaceElevated
  /// - Primary actions: Fresh gradient buttons
  // ========================================
  // 🎯 USAGE GUIDE - By Screen
  // ========================================

  /// HOME SCREEN
  /// - Background: lightBackground / darkBackground
  /// - Cards: lightSurface with shadow / darkSurfaceElevated
  /// - Primary actions: Blue primary buttons
  /// - Stats/Progress: Primary blue gradient
  /// - AI suggestions: Indigo accent (sparingly)

  /// SMART FRIDGE 3D
  /// - Background: fridgeGradient (always dark)
  /// - Fridge interior: Cool blue tint
  /// - Expiring items: Warning color
  /// - Fresh items: Success color
  /// - Interactive items: Primary blue

  /// RECIPES & FOOD
  /// - Background: lightBackground / darkBackground
  /// - Recipe cards: Primary blue accents
  /// - Category chips: Primary blue
  /// - Featured: Primary gradient

  /// CHATBOT (AI)
  /// - Background: lightBackground / darkBackground
  /// - AI messages: Indigo accent bubbles (AI identity)
  /// - User messages: lightSurface / darkSurface
  /// - Thinking: Indigo pulse animation

  /// ONBOARDING & FORMS
  /// - Background: lightBackground / darkBackground  
  /// - Selected options: Primary blue
  /// - Progress bars: Primary blue
  /// - CTAs: Primary blue gradient

  /// AUTHENTICATION
  /// - Background: Primary blue gradient (impactful)
  /// - Input fields: lightSurface / darkSurface
  /// - Primary CTA: White on blue
  /// - Secondary: Outline blue

  // ========================================
  // 💎 DESIGN PRINCIPLES (2026 Best Practices)
  // ========================================

  /// WCAG COMPLIANCE:
  /// - Blue-600 on white: 8.6:1 (AAA ✓)
  /// - Blue-400 on black: 6.3:1 (AAA ✓)
  /// - All text meets minimum 4.5:1 for body, 3:1 for large

  /// MONOCHROME RULES:
  /// - Stick to 2-3 primary colors maximum per screen
  /// - Use tints/shades of same color for cohesion
  /// - Warm accent (amber) balances cool dominant palette (teal/indigo)
  /// - Let neutrals breathe - don't over-saturate every element

  /// SPACING & RHYTHM:
  /// - 8px grid system for consistency (8, 16, 24, 32...)
  /// - Generous padding: 20-24px for cards (don't cram)
  /// - Section spacing: 32-40px for clear separation
  /// - White space is a design element, not empty space

  /// MODERN PREMIUM FEEL:
  /// - Subtle gradients within same color family
  /// - Soft drop shadows (0.02-0.08 opacity, large blur)
  /// - Rounded corners 14-20px for cards, 10-12px for buttons
  /// - Micro-interactions with spring curves (iOS 18 style)
  /// - Glassmorphism for overlays (backdrop blur + opacity)

  /// AVOID (2026 Anti-Patterns):
  /// - Pure black backgrounds (#000) in light mode
  /// - Neon saturated colors competing for attention
  /// - More than 3 brand colors on one screen
  /// - Flat single-color rectangles (add gradient/shadow)
  /// - Text smaller than 13px for body content
  /// - Low contrast decorative text
  /// - Harsh borders - prefer shadows for depth

  /// ELEVATION:
  /// - Level 0: No shadow (flat on background)
  /// - Level 1: 0px 1px 3px rgba(0,0,0,0.08) - Cards
  /// - Level 2: 0px 4px 6px rgba(0,0,0,0.1) - Elevated cards
  /// - Level 3: 0px 10px 15px rgba(0,0,0,0.12) - Modals, FABs
  /// - Level 4: 0px 20px 25px rgba(0,0,0,0.15) - Dialogs

  /// GLASSMORPHISM:
  /// - Background: white/black with 0.7-0.9 opacity
  /// - Backdrop blur: 10-20px
  /// - Border: 1px with 0.2 opacity white
  /// - Shadow: soft and large radius

  // ========================================
  // 🎨 COLOR PSYCHOLOGY - Blue Monochrome
  // ========================================

  /// PRIMARY BLUE (#2563EB):
  /// • Represents: Trust, technology, reliability, innovation
  /// • Emotion: Professional, calm, confident, modern
  /// • Usage: ALL brand touchpoints, CTAs, progress\n  /// • Why: Universal trust signal, accessible, timeless
  ///   - Used by: Apple, Stripe, Linear, Figma, Twitter/X
  ///   - Best contrast ratios of any hue
  ///   - Colorblind-friendly (deuteranopia safe)
  ///   - Culturally positive globally

  /// ACCENT INDIGO (#4F46E5):
  /// • Represents: Premium AI, intelligence, sophistication
  /// • Emotion: Exclusive, cutting-edge, mysterious depth
  /// • Usage: AI features ONLY (chatbot, smart suggestions)
  /// • Why: Creates distinct AI identity without diluting brand

  /// NEUTRAL GRAYS:
  /// • Represents: Premium quality, modern minimalism
  /// • Emotion: Calm, professional, sophisticated
  /// • Usage: Text hierarchy, surfaces, structure

  /// SEMANTIC COLORS (Green/Red/Amber):
  /// • Usage: Status feedback ONLY (success/error/warning)
  /// • Not part of brand identity

  // ========================================
  // 🚀 IMPLEMENTATION HELPERS
  // ========================================

  /// Shadow helpers
  static List<BoxShadow> elevation1(bool isDark) => [
    BoxShadow(
      color: isDark
          ? const Color(0xFF000000).withOpacity(0.3)
          : const Color(0xFF000000).withOpacity(0.08),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> elevation2(bool isDark) => [
    BoxShadow(
      color: isDark
          ? const Color(0xFF000000).withOpacity(0.4)
          : const Color(0xFF000000).withOpacity(0.1),
      blurRadius: 6,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> elevation3(bool isDark) => [
    BoxShadow(
      color: isDark
          ? const Color(0xFF000000).withOpacity(0.5)
          : const Color(0xFF000000).withOpacity(0.12),
      blurRadius: 15,
      offset: const Offset(0, 10),
    ),
  ];

  /// Glassmorphism helper
  static BoxDecoration glassmorphism(bool isDark) => BoxDecoration(
    color: isDark
        ? const Color(0xFF1A1F2E).withOpacity(0.8)
        : const Color(0xFFFFFFFF).withOpacity(0.8),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: isDark
          ? Colors.white.withOpacity(0.1)
          : Colors.black.withOpacity(0.05),
      width: 1,
    ),
    boxShadow: elevation2(isDark),
  );

  // ========================================
  // 🎯 ADAPTIVE COLOR HELPERS
  // ========================================

  /// Get primary color based on theme
  static Color primary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkPrimary
        : lightPrimary;
  }

  /// Get primary variant color based on theme
  static Color primaryVariant(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkPrimaryVariant
        : lightPrimaryVariant;
  }

  /// Get secondary color based on theme
  static Color secondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSecondary
        : lightSecondary;
  }

  /// Get secondary variant color based on theme (AI features)
  static Color secondaryVariant(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSecondaryVariant
        : lightSecondaryVariant;
  }

  /// Get background color based on theme
  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : lightBackground;
  }

  /// Get background secondary color based on theme
  static Color backgroundSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackgroundSecondary
        : lightBackgroundSecondary;
  }

  /// Get surface color based on theme
  static Color surface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurface
        : lightSurface;
  }

  /// Get surface elevated color based on theme
  static Color surfaceElevated(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurfaceElevated
        : lightSurfaceElevated;
  }

  /// Get text primary color based on theme
  static Color textPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextPrimary
        : lightTextPrimary;
  }

  /// Get text secondary color based on theme
  static Color textSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextSecondary
        : lightTextSecondary;
  }

  /// Get text tertiary color based on theme
  static Color textTertiary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextTertiary
        : lightTextTertiary;
  }

  /// Get text on primary color based on theme
  static Color textOnPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextOnPrimary
        : lightTextOnPrimary;
  }

  /// Get divider color based on theme
  static Color divider(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkDivider
        : lightDivider;
  }

  /// Get overlay color based on theme
  static Color overlay(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkOverlay
        : lightOverlay;
  }

  /// Get primary gradient based on theme
  static LinearGradient primaryGradient(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkPrimaryGradient
        : lightPrimaryGradient;
  }

  /// Get AI gradient based on theme (Indigo - use sparingly!)
  static LinearGradient aiGradient(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkAIGradient
        : lightAIGradient;
  }

  /// Get depth gradient based on theme
  static LinearGradient depthGradient(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkDepthGradient
        : lightDepthGradient;
  }

  /// Check if dark mode is active
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
