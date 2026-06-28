import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/utils/validators.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final Future<void> Function(String email, String password, String? name)
      onSubmit;
  final Future<void> Function()? onGoogleSignIn;

  const AuthForm({
    super.key,
    required this.isLogin,
    required this.onSubmit,
    this.onGoogleSignIn,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        await widget.onSubmit(
          _emailController.text.trim(),
          _passwordController.text,
          widget.isLogin ? null : _nameController.text.trim(),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).textTheme.bodySmall?.color,
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 14,
        color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
      ),
      prefixIcon: Icon(icon, color: primaryColor, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name field (only for registration)
          if (!widget.isLogin) ...[
            TextFormField(
              controller: _nameController,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: Theme.of(context).textTheme.displayLarge?.color,
              ),
              decoration: _inputDecoration(
                label: 'Nom complet',
                hint: 'Entrez votre nom',
                icon: Icons.person_outline_rounded,
              ),
              validator: Validators.validateName,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
          ],

          // Email field
          TextFormField(
            controller: _emailController,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: Theme.of(context).textTheme.displayLarge?.color,
            ),
            decoration: _inputDecoration(
              label: 'Email',
              hint: 'exemple@email.com',
              icon: Icons.email_outlined,
            ),
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),

          // Password field
          TextFormField(
            controller: _passwordController,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: Theme.of(context).textTheme.displayLarge?.color,
            ),
            decoration: _inputDecoration(
              label: 'Mot de passe',
              hint: '••••••••',
              icon: Icons.lock_outline_rounded,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                  size: 20,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
            obscureText: _obscurePassword,
            validator: Validators.validatePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleSubmit(),
          ),

          if (widget.isLogin) ...[
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Forgot password
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: Text(
                  'Mot de passe oublié ?',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 16),
          ],

          // Submit button
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: isDark
                    ? AppColors.darkTextOnPrimary
                    : AppColors.lightTextOnPrimary,
                disabledBackgroundColor: primaryColor.withOpacity(0.5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      widget.isLogin ? 'Se connecter' : 'S\'inscrire',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 16),

          // Divider "ou"
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                  thickness: 0.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'ou',
                  style: GoogleFonts.inter(
                    color: isDark
                        ? AppColors.darkTextTertiary
                        : AppColors.lightTextTertiary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                  thickness: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Social login buttons
          Row(
            children: [
              // Google
              Expanded(
                child: _SocialButton(
                  icon: Icons.g_mobiledata,
                  label: 'Google',
                  isLoading: _isLoading,
                  onTap: _isLoading
                      ? null
                      : () async {
                          setState(() => _isLoading = true);
                          try {
                            await widget.onGoogleSignIn?.call();
                          } finally {
                            if (mounted) {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                ),
              ),
              const SizedBox(width: 12),
              // Apple
              Expanded(
                child: _SocialButton(
                  icon: Icons.apple,
                  label: 'Apple',
                  isApple: true,
                  onTap: () {
                    // TODO: Apple Sign In
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback? onTap;
  final bool isApple;
  final bool isLoading;

  const _SocialButton({
    this.icon,
    required this.label,
    required this.onTap,
    this.isApple = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Opacity(
          opacity: onTap == null ? 0.6 : 1,
          child: Container(
            height: 50,
          decoration: BoxDecoration(
            color: isApple
                ? (isDark ? Colors.white : Colors.black)
                : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
            borderRadius: BorderRadius.circular(14),
            border: isApple
                ? null
                : Border.all(
                    color: isDark
                        ? AppColors.darkDivider
                        : AppColors.lightDivider,
                  ),
          ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isApple
                            ? (isDark ? Colors.black : Colors.white)
                            : (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary),
                      ),
                    ),
                  )
                else if (isApple)
                  Icon(
                    Icons.apple,
                    size: 22,
                    color: isDark ? Colors.black : Colors.white,
                  )
                else
                  FaIcon(
                    FontAwesomeIcons.google,
                    size: 22,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                const SizedBox(width: 8),
                Text(
                  isLoading ? 'Connexion...' : label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isApple
                        ? (isDark ? Colors.black : Colors.white)
                        : (isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
