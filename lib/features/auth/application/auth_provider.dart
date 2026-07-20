import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../data/auth_repository.dart';
import '../data/auth_model.dart';

// Auth State
class AuthState {
  final AuthUser? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  bool get hasError => error != null;

  AuthState copyWith({
    AuthUser? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// Auth Provider
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState());

  // Login method
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await _repository.login(email, password);
      state = AuthState(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Register method (account not verified yet → NOT authenticated)
  Future<void> register(String email, String password, String? name) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _repository.register(email, password, name ?? '');
      state = AuthState(
        isAuthenticated: false,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Verify OTP method
  Future<void> verifyOtp(String email, String code) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _repository.verifyOtp(email, code);
      state = AuthState(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Resend OTP method
  Future<void> resendOtp(String email) async {
    try {
      await _repository.resendOtp(email);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Google OAuth 2.0
  static const _webClientId = '930335568114-78mc2g1opp0c06lc6l59f8jgvtkbobgg.apps.googleusercontent.com';
  bool _googleInitialized = false;

  Future<void> googleSignIn() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final gsi = GoogleSignIn.instance;

      if (!_googleInitialized) {
        await gsi.initialize(serverClientId: _webClientId);
        _googleInitialized = true;
      }

      final account = await gsi.authenticate();
      final idToken = account.authentication.idToken;

      if (idToken == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'idToken Google null — vérifie le client OAuth Android (SHA-1 + package name).',
        );
        return;
      }

      final user = await _repository.googleAuth(idToken);
      state = AuthState(user: user, isAuthenticated: true, isLoading: false);
    } on GoogleSignInException catch (e) {
      debugPrint('❌ GoogleSignInException — code: ${e.code}, '
          'description: ${e.description}, details: ${e.details}');
      if (e.code == GoogleSignInExceptionCode.canceled) {
        state = state.copyWith(isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Google Sign-In [${e.code.name}] : '
              '${e.description ?? 'erreur inconnue'}',
        );
      }
    } catch (e) {
      debugPrint('❌ Google Sign-In erreur inattendue: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Logout method — l'état local est TOUJOURS réinitialisé, même si la
  // révocation serveur échoue (sinon l'utilisateur reste "connecté" hors ligne)
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _repository.logout();
    } catch (e) {
      debugPrint('Logout serveur échoué (session locale effacée): $e');
    }
    state = AuthState();
  }

  // Check if user is logged in
  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        state = AuthState(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        state = AuthState(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

// Provider instances
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
