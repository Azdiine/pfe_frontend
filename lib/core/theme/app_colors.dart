import 'package:flutter/material.dart';

/// 🎨 COMPLETE DESIGN SYSTEM — 2026 Edition
/// AI-Powered Food & Smart Fridge App
/// Premium • Modern • Sophisticated • Harmonious
///
/// Design Philosophy (Refined by 20yr UI/UX Expert):
/// - Teal: Modern tech, fresh without being medical, sophisticated
/// - Indigo: Premium AI, elegant, trustworthy, innovation
/// - Soft Amber: Food warmth, appetite, gentle energy
/// - Warm Neutrals: Luxury, breathable, contemporary
///
/// Style: Linear + Stripe + Apple Design Awards 2026
/// Color Harmony: Analogous cool tones + warm accent

class AppColors {
  // ========================================
  // 🌟 LIGHT MODE - PRIMARY COLORS
  // ========================================

  /// Primary: Modern Teal
  /// Psychology: Fresh, innovative, clean, technological sophistication
  /// Usage: Main CTAs, active states, primary actions
  /// Why: Contemporary without being medical, works with food context
  static const Color lightPrimary = Color(0xFF14B8A6); // Teal-500
  static const Color lightPrimaryVariant = Color(0xFF0D9488); // Teal-600
  static const Color lightPrimaryLight = Color(0xFF2DD4BF); // Teal-400

  /// Secondary: Premium Indigo
  /// Psychology: Intelligence, premium, trust, sophisticated AI
  /// Usage: Secondary actions, AI features, premium cards
  /// Why: Complements teal perfectly, signals technology & quality
  static const Color lightSecondary = Color(0xFF6366F1); // Indigo-500
  static const Color lightSecondaryVariant = Color(0xFF4F46E5); // Indigo-600
  static const Color lightSecondaryLight = Color(0xFF818CF8); // Indigo-400

  /// Accent: Warm Amber (Food Focus)
  /// Psychology: Gentle warmth, appetite, comfort without aggression
  /// Usage: Food highlights, recipe cards, notifications
  /// Why: Softer than orange, still stimulates appetite, harmonious
  static const Color lightAccent = Color(0xFFF59E0B); // Amber-500
  static const Color lightAccentVariant = Color(0xFFFBBF24); // Amber-400
  static const Color lightAccentLight = Color(0xFFFCD34D); // Amber-300

  // ========================================
  // 🌙 DARK MODE - PRIMARY COLORS
  // ========================================

  /// Primary: Soft Teal (dark mode optimized)
  /// Gentle on eyes, maintains vibrancy without harshness
  static const Color darkPrimary = Color(0xFF5EEAD4); // Teal-300
  static const Color darkPrimaryVariant = Color(0xFF2DD4BF); // Teal-400
  static const Color darkPrimaryLight = Color(0xFF99F6E4); // Teal-200

  /// Secondary: Soft Indigo
  /// Premium feel, comfortable for extended viewing
  static const Color darkSecondary = Color(0xFF818CF8); // Indigo-400
  static const Color darkSecondaryVariant = Color(0xFFA5B4FC); // Indigo-300
  static const Color darkSecondaryLight = Color(0xFFC7D2FE); // Indigo-200

  /// Accent: Gentle Amber
  /// Warm without burning eyes, food-friendly
  static const Color darkAccent = Color(0xFFFBBF24); // Amber-400
  static const Color darkAccentVariant = Color(0xFFFCD34D); // Amber-300
  static const Color darkAccentLight = Color(0xFFFDE68A); // Amber-200

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
  // 🎨 GRADIENTS - LIGHT MODE (Harmonious & Subtle)
  // ========================================

  /// Primary Gradient (Teal Flow)
  /// Usage: Main CTAs, hero sections, key actions
  static const LinearGradient lightFreshGradient = LinearGradient(
    colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Food Energy Gradient (Warm Amber)
  /// Usage: Recipe cards, food highlights, appetizing elements
  static const LinearGradient lightFoodGradient = LinearGradient(
    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// AI Intelligence Gradient (Premium Indigo)
  /// Usage: Chatbot, AI features, smart suggestions
  static const LinearGradient lightAIGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Premium Glow Gradient (Teal to Indigo)
  /// Usage: Premium badges, special features, highlights
  static const LinearGradient lightPremiumGradient = LinearGradient(
    colors: [Color(0xFF14B8A6), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Neutral Depth Gradient (Subtle elevation)
  /// Usage: Backgrounds, card overlays, subtle depth
  static const LinearGradient lightDepthGradient = LinearGradient(
    colors: [Color(0xFFFAFAFA), Color(0xFFF5F5F5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ========================================
  // 🌙 GRADIENTS - DARK MODE (Eye-Friendly)
  // ========================================

  /// Primary Gradient (Soft Teal)
  static const LinearGradient darkFreshGradient = LinearGradient(
    colors: [Color(0xFF5EEAD4), Color(0xFF2DD4BF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Food Energy Gradient (Gentle Amber)
  static const LinearGradient darkFoodGradient = LinearGradient(
    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// AI Intelligence Gradient (Soft Indigo)
  static const LinearGradient darkAIGradient = LinearGradient(
    colors: [Color(0xFF818CF8), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark Depth Gradient (Premium elevation)
  /// Usage: Card backgrounds, elevated surfaces
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
  /// - Nutrition stats: Food gradient
  /// - AI suggestions: AI gradient

  /// SMART FRIDGE 3D
  /// - Background: Dark always (fridgeGradient)
  /// - Fridge interior: Cool blue tint (0xFFE1F5FE with opacity)
  /// - Expiring items: warning color
  /// - Fresh items: success color
  /// - Interactive elements: lightAccent / darkAccent (purple)

  /// RECIPES LIST
  /// - Background: lightBackground / darkBackground
  /// - Recipe cards: Food gradient overlays
  /// - Category chips: Primary colors
  /// - Featured recipes: Premium gradient

  /// CHATBOT
  /// - Background: lightBackground / darkBackground
  /// - AI messages: AI gradient bubbles
  /// - User messages: lightSurface / darkSurface
  /// - Thinking animation: AI accent colors

  /// TRACKING DASHBOARD
  /// - Background: lightBackground / darkBackground
  /// - Progress bars: Fresh gradient
  /// - Exceeded limits: Warning colors
  /// - Achievements: Success colors with glow

  /// SCAN CAMERA
  /// - Overlay: Pure dark (0xFF000000 with 0.8 opacity)
  /// - Scan frame: Food secondary (orange)
  /// - Success feedback: Success gradient
  /// - Flash button: Accent purple

  /// PROFILE
  /// - Background: lightBackground / darkBackground
  /// - Avatar border: Fresh gradient
  /// - Stats cards: Depth gradient
  /// - Premium badge: Premium gradient

  // ========================================
  // 💎 PREMIUM UI TIPS (Updated 2026)
  // ========================================

  /// CONTRAST RULES:
  /// - Maintain WCAG AA minimum (4.5:1 for body text, 3:1 for large text)
  /// - Use secondary text colors for hierarchy, not just sizing
  /// - Avoid pure black text (#000) - use near-black (#0A0A0A)
  /// - Prefer soft shadows over hard borders for depth

  /// COLOR HARMONY:
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
  // 🎨 COLOR PSYCHOLOGY SUMMARY
  // ========================================

  /// MODERN TEAL (#14B8A6):
  /// - Represents: Fresh innovation, clean technology, sophisticated health
  /// - Emotion: Trust, calm, contemporary, premium without medical feel
  /// - Usage: Primary actions promoting smart healthy living
  /// - Why: Balances warm & cool, modern tech aesthetic, 2026 trending

  /// PREMIUM INDIGO (#6366F1):
  /// - Represents: Intelligence, sophistication, trustworthy AI, quality
  /// - Emotion: Confidence, premium, innovation, reliability
  /// - Usage: Secondary actions, AI features, premium elements
  /// - Why: Complements teal perfectly, signals cutting edge technology

  /// WARM AMBER (#F59E0B):
  /// - Represents: Gentle food warmth, comfort, subtle appetite stimulation
  /// - Emotion: Welcoming, friendly, optimistic, approachable
  /// - Usage: Food content, highlights, warm accents
  /// - Why: Softer than orange, harmonizes with cool palette, versatile

  /// SOPHISTICATED NEUTRALS:
  /// - Represents: Premium quality, breathable space, modernity
  /// - Emotion: Calm, professional, luxurious, timeless
  /// - Usage: Backgrounds, text, structural foundation
  /// - Why: Warm-neutral base allows colors to shine, premium feel

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
}
