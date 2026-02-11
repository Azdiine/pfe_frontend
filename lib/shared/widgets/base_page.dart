import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class BasePage extends StatefulWidget {
  final int currentNavIndex;

  const BasePage({super.key, required this.currentNavIndex});
}

abstract class BasePageState<T extends BasePage> extends State<T> {
  int get currentNavIndex => widget.currentNavIndex;

  // Méthode abstraite que chaque page doit implémenter pour fournir son contenu
  Widget buildPageContent(BuildContext context);

  // Méthode optionnelle pour l'AppBar (peut être overridée)
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  // Méthode optionnelle pour le FAB (peut être overridée)
  Widget? buildFloatingActionButton(BuildContext context) => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: buildAppBar(context),
      body: buildPageContent(context),
      floatingActionButton: buildFloatingActionButton(context),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.home_rounded, 'Home', 0, '/home'),
            _buildNavItem(Icons.restaurant_menu, 'Recettes', 1, '/recettes'),
            _buildNavItem(Icons.bar_chart_rounded, 'Suivi', 2, '/suivi'),
            _buildNavItem(Icons.kitchen, 'Frigo', 3, '/frigo'),
            _buildNavItem(Icons.person, 'Profil', 4, '/profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, String route) {
    final isSelected = currentNavIndex == index;
    return GestureDetector(
      onTap: () {
        if (index != currentNavIndex) {
          context.push(route);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF6B35) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
