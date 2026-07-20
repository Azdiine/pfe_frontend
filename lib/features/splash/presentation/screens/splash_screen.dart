import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/application/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    // Start animation
    _animationController.forward();

    // Check auth status and navigate accordingly
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for splash animation to show
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    try {
      await ref.read(authProvider.notifier).checkAuthStatus();
      final state = ref.read(authProvider);

      if (!mounted) return;

      if (state.isAuthenticated) {
        if (state.user?.onboardingDone == true) {
          context.go('/home');
        } else {
          context.go('/onboarding');
        }
      } else {
        context.go('/login');
      }
    } catch (_) {
      if (mounted) context.go('/login');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A0A0A)
          : const Color(0xFF5B4C6B), // Purple background like the image
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // MY Logo text
                    Text(
                      'MY',
                      style: TextStyle(
                        fontSize: 120,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? const Color(0xFFE5E5E5)
                            : const Color(0xFFF5EFE0), // Cream/beige color
                        letterSpacing: -8,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                            color: Colors.black.withValues(alpha: 0.3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // App name subtitle
                    Text(
                      'Meatay',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        color: isDark
                            ? const Color(0xFFE5E5E5).withValues(alpha: 0.8)
                            : const Color(0xFFF5EFE0).withValues(alpha: 0.8),
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
