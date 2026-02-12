import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// ⚠️ DEPRECATED - Utiliser directement StatelessWidget ou StatefulWidget
/// La navigation est maintenant gérée par StatefulShellRoute dans routes.dart
///
/// Cette classe est conservée temporairement pour compatibilité
/// mais ne devrait plus être utilisée pour les nouvelles pages
@Deprecated(
  'Use StatelessWidget or StatefulWidget directly. Navigation is handled by StatefulShellRoute',
)
abstract class BasePage extends StatefulWidget {
  final int currentNavIndex;

  const BasePage({super.key, required this.currentNavIndex});
}

@Deprecated('Use State<StatefulWidget> directly')
abstract class BasePageState<T extends BasePage> extends State<T> {
  int get currentNavIndex => widget.currentNavIndex;

  // Méthode abstraite que chaque page doit implémenter pour fournir son contenu
  Widget buildPageContent(BuildContext context);

  // Méthode optionnelle pour l'AppBar (peut être overridée)
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  // Méthode optionnelle pour le FAB (peut être overridée)
  Widget? buildFloatingActionButton(BuildContext context) => null;

  // Méthode pour définir si la page utilise un thème dark (peut être overridée)
  bool get useDarkTheme => false;

  @override
  Widget build(BuildContext context) {
    // Plus de bottom navigation - elle est gérée par le shell
    return Scaffold(
      backgroundColor: useDarkTheme
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: buildAppBar(context),
      body: buildPageContent(context),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }
}
