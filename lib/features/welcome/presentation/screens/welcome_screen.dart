import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/language_switcher.dart';
import '../../../../shared/widgets/theme_switcher.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Welcome Text at Top
                  Column(
                    children: [
                      const SizedBox(height: 60),
                      Text(
                        l10n.welcomeTitle,
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(
                            context,
                          ).textTheme.displayLarge?.color,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.welcomeSubtitle,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  // Logo in Center
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: ClipOval(
                      child: Image.asset(
                        'uploads/images/MEATAY LOGO.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // CTA Buttons at Bottom
                  Column(
                    children: [
                      _PrimaryButton(
                        text: l10n.getStarted,
                        onPressed: () => _showSignupOptions(context, l10n),
                      ),
                      const SizedBox(height: 16),
                      _SecondaryButton(
                        text: l10n.alreadyHaveAccount,
                        onPressed: () => _showLoginOptions(context, l10n),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ],
              ),
            ),

            // Theme Switcher - Top Left
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF2A2A2A)
                        : const Color(0xFFE0E0E0),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const ThemeSwitcher(
                  style: ThemeSwitcherStyle.iconButton,
                ),
              ),
            ),

            // Language Switcher - Top Right
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF2A2A2A)
                        : const Color(0xFFE0E0E0),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const LanguageSwitcher(
                  style: LanguageSwitcherStyle.iconButton,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignupOptions(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _AuthOptionsSheet(
        title: l10n.signUpNow,
        subtitle: l10n.createAccountSeconds,
        onEmailPressed: () {
          Navigator.pop(context);
          context.push('/register');
        },
        onGooglePressed: () {
          Navigator.pop(context);
          context.push('/onboarding');
        },
        onApplePressed: () {
          Navigator.pop(context);
          context.push('/onboarding');
        },
        termsText: l10n.termsAndPrivacy,
        emailText: l10n.continueWithEmail,
      ),
    );
  }

  void _showLoginOptions(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _AuthOptionsSheet(
        title: l10n.welcomeBack,
        subtitle: l10n.signInToAccount,
        onEmailPressed: () {
          Navigator.pop(context);
          context.push('/login');
        },
        onGooglePressed: () {
          Navigator.pop(context);
          context.push('/onboarding');
        },
        onApplePressed: () {
          Navigator.pop(context);
          context.push('/onboarding');
        },
        termsText: l10n.termsAndPrivacy,
        emailText: l10n.continueWithEmail,
      ),
    );
  }
}

// Primary Button Widget
class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _PrimaryButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? Colors.white : const Color(0xFF000000),
          foregroundColor: isDark ? Colors.black : Colors.white,
          elevation: 0,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}

// Secondary Button Widget
class _SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _SecondaryButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark
              ? const Color(0xFFE5E5E5)
              : const Color(0xFF111111),
          side: BorderSide(
            color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEAEAEA),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}

// Auth Options Bottom Sheet
class _AuthOptionsSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onEmailPressed;
  final VoidCallback onGooglePressed;
  final VoidCallback onApplePressed;
  final String termsText;
  final String emailText;

  const _AuthOptionsSheet({
    required this.title,
    required this.subtitle,
    required this.onEmailPressed,
    required this.onGooglePressed,
    required this.onApplePressed,
    required this.termsText,
    required this.emailText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: isDark
                    ? const Color(0xFF9A9A9A)
                    : const Color(0xFF7A7A7A),
              ),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 8),

          // Title
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.displayLarge?.color,
            ),
          ),
          const SizedBox(height: 12),

          // Subtitle
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // Social Login Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialIconButton(
                icon: FontAwesomeIcons.google,
                onPressed: onGooglePressed,
              ),
              const SizedBox(width: 20),
              _SocialIconButton(
                icon: FontAwesomeIcons.apple,
                onPressed: onApplePressed,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Email Login Button
          _EmailLoginButton(text: emailText, onPressed: onEmailPressed),
          const SizedBox(height: 24),

          // Terms and Privacy
          Text(
            termsText,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).textTheme.bodySmall?.color,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Social Icon Button Widget
class _SocialIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _SocialIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEAEAEA),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: FaIcon(
          icon,
          color: Theme.of(context).textTheme.displayLarge?.color,
          size: 28,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _EmailLoginButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _EmailLoginButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.email_outlined, size: 24),
        label: Text(
          text,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? Colors.white : const Color(0xFF000000),
          foregroundColor: isDark ? Colors.black : Colors.white,
          elevation: 0,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
