import 'package:go_router/go_router.dart';
import '../features/welcome/presentation/screens/welcome_screen.dart';
import '../features/splash/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/otp_verification_screen.dart';
import '../features/subscriptions/presentation/screens/subscriptions_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/home/presentation/screens/home_page.dart';
import '../features/recipes/presentation/screens/recettes_page.dart';
import '../features/tracking/presentation/screens/suivi_page.dart';
import '../features/fridge/presentation/screens/frigo_page.dart';
import 'navigation/shell_navigation.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Routes sans navigation bar (auth, onboarding, etc.)
    GoRoute(
      path: '/',
      name: 'welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/otp-verification',
      name: 'otp-verification',
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return OtpVerificationScreen(email: email);
      },
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/subscriptions',
      name: 'subscriptions',
      builder: (context, state) => const SubscriptionsScreen(),
    ),

    // 🎯 StatefulShellRoute - Navigation avec préservation d'état
    // Chaque branche garde son état et sa navigation stack (comme App Store)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Branche 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),

        // Branche 1: Recettes
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/recettes',
              name: 'recettes',
              builder: (context, state) => const RecettesPage(),
            ),
          ],
        ),

        // Branche 2: Frigo
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/frigo',
              name: 'frigo',
              builder: (context, state) => const FrigoPage(),
            ),
          ],
        ),

        // Branche 3: Suivi
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/suivi',
              name: 'suivi',
              builder: (context, state) => const SuiviPage(),
            ),
          ],
        ),

        // Branche 4: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
