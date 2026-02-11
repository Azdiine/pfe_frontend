import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
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
                    'Welcome to MEATAY',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111111),
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Premium nutrition delivered\nto your doorstep',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF7A7A7A),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              // Logo in Center
              Container(
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
                  _buildPrimaryButton(
                    context: context,
                    text: 'Get Started',
                    onPressed: () => _showSignupOptions(context),
                  ),
                  const SizedBox(height: 16),
                  _buildSecondaryButton(
                    context: context,
                    text: 'I already have an account',
                    onPressed: () => _showLoginOptions(context),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF000000),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF111111),
                letterSpacing: -0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSignupOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF7A7A7A)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              'Commencez Maintenant',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 12),

            // Subtitle
            Text(
              'Créez votre compte en quelques secondes',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF7A7A7A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Google and Apple icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIconButton(
                  context: context,
                  icon: FontAwesomeIcons.google,
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/onboarding');
                  },
                ),
                const SizedBox(width: 20),
                _buildSocialIconButton(
                  context: context,
                  icon: FontAwesomeIcons.apple,
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/onboarding');
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Email button
            _buildLoginOptionButton(
              context: context,
              icon: Icons.email_outlined,
              text: 'Continuer avec Email',
              onPressed: () {
                Navigator.pop(context);
                context.push('/register');
              },
            ),
            const SizedBox(height: 24),

            // Terms text
            Text(
              'En continuant, vous acceptez nos Conditions de Service\net Politique de Confidentialité',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF7A7A7A),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showLoginOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF7A7A7A)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              'Bon Retour',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 12),

            // Subtitle
            Text(
              'Connectez-vous pour continuer votre voyage',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF7A7A7A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Google and Apple icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIconButton(
                  context: context,
                  icon: FontAwesomeIcons.google,
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/onboarding');
                  },
                ),
                const SizedBox(width: 20),
                _buildSocialIconButton(
                  context: context,
                  icon: FontAwesomeIcons.apple,
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/onboarding');
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Email button
            _buildLoginOptionButton(
              context: context,
              icon: Icons.email_outlined,
              text: 'Continuer avec Email',
              onPressed: () {
                Navigator.pop(context);
                context.push('/login');
              },
            ),
            const SizedBox(height: 24),

            // Terms text
            Text(
              'En continuant, vous acceptez nos Conditions de Service\net Politique de Confidentialité',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF7A7A7A),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIconButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(32),
          child: Center(
            child: FaIcon(icon, color: const Color(0xFF111111), size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginOptionButton({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF000000),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


