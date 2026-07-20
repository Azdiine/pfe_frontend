import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/utils/validators.dart';
import '../../application/auth_provider.dart';

/// Mot de passe oublié : envoi d'un code par email, puis saisie du code
/// et du nouveau mot de passe.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _codeSent = false;
  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.inter()),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _sendCode() async {
    final email = _emailController.text.trim();
    if (Validators.validateEmail(email) != null) {
      _showSnack('Entrez une adresse email valide.', isError: true);
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).forgotPassword(email);
      if (!mounted) return;
      setState(() {
        _codeSent = true;
        _loading = false;
      });
      _showSnack('Si ce compte existe, un code a été envoyé par email.');
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _showSnack(e.toString().replaceFirst('Exception: ', ''), isError: true);
    }
  }

  Future<void> _resetPassword() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).resetPassword(
            _emailController.text.trim(),
            _codeController.text.trim(),
            _passwordController.text,
          );
      if (!mounted) return;
      setState(() => _loading = false);
      _showSnack('Mot de passe réinitialisé ! Connectez-vous.');
      context.go('/login');
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _showSnack(e.toString().replaceFirst('Exception: ', ''), isError: true);
    }
  }

  InputDecoration _decoration(String label, IconData icon,
      {Widget? suffixIcon}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.inter(fontSize: 14),
      prefixIcon: Icon(icon, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () =>
                      context.canPop() ? context.pop() : context.go('/login'),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkDivider
                            : AppColors.lightDivider,
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: Theme.of(context).textTheme.displayLarge?.color,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(Icons.lock_reset_rounded,
                              size: 56, color: primaryColor),
                          const SizedBox(height: 16),
                          Text(
                            'Mot de passe oublié',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.color,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _codeSent
                                ? 'Entrez le code reçu par email et votre nouveau mot de passe'
                                : 'Entrez votre email pour recevoir un code de réinitialisation',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          TextFormField(
                            controller: _emailController,
                            enabled: !_codeSent,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.inter(fontSize: 15),
                            decoration:
                                _decoration('Email', Icons.mail_outline),
                            validator: Validators.validateEmail,
                          ),

                          if (_codeSent) ...[
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _codeController,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              style: GoogleFonts.inter(
                                  fontSize: 18, letterSpacing: 6),
                              decoration: _decoration(
                                      'Code à 6 chiffres', Icons.pin_outlined)
                                  .copyWith(counterText: ''),
                              validator: (v) =>
                                  (v == null || v.trim().length != 6)
                                      ? 'Entrez le code à 6 chiffres'
                                      : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: GoogleFonts.inter(fontSize: 15),
                              decoration: _decoration(
                                'Nouveau mot de passe',
                                Icons.lock_outline,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(() =>
                                      _obscurePassword = !_obscurePassword),
                                ),
                              ),
                              validator: Validators.validatePassword,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _confirmController,
                              obscureText: _obscurePassword,
                              style: GoogleFonts.inter(fontSize: 15),
                              decoration: _decoration(
                                  'Confirmer le mot de passe',
                                  Icons.lock_outline),
                              validator: (v) => v != _passwordController.text
                                  ? 'Les mots de passe ne correspondent pas'
                                  : null,
                            ),
                          ],

                          const SizedBox(height: 20),
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _loading
                                  ? null
                                  : (_codeSent ? _resetPassword : _sendCode),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      _codeSent
                                          ? 'Réinitialiser le mot de passe'
                                          : 'Envoyer le code',
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          if (_codeSent) ...[
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: _loading ? null : _sendCode,
                              child: Text(
                                'Renvoyer le code',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
