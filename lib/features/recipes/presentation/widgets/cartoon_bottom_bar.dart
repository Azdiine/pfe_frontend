import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/apple_theme.dart';

class CartoonBottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CartoonBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CartoonBottomBar> createState() => _CartoonBottomBarState();
}

class _CartoonBottomBarState extends State<CartoonBottomBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _bounceAnimations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      5,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 1.0,
        end: 1.2,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }).toList();

    _bounceAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: -10.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.elasticOut));
    }).toList();

    // Animate current selected item
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controllers[widget.currentIndex].forward();
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(CartoonBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _controllers[oldWidget.currentIndex].reverse();
      _controllers[widget.currentIndex].forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: AppleTheme.adaptiveBackground(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(
              0,
              CupertinoIcons.house_fill,
              'Accueil',
              AppColors.primary(context),
            ),
            _buildNavItem(
              1,
              CupertinoIcons.square_grid_2x2_fill,
              'Recettes',
              AppColors.secondary(context),
            ),
            const SizedBox(width: 60), // Espace pour le FAB central
            _buildNavItem(
              2,
              CupertinoIcons.cart_fill,
              'Frigo',
              AppColors.success,
            ),
            _buildNavItem(
              3,
              CupertinoIcons.person_fill,
              'Profil',
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, Color color) {
    final isSelected = widget.currentIndex == index;

    return GestureDetector(
      onTap: () {
        widget.onTap(index);
        // Animation de rebond
        _controllers[index].forward().then((_) {
          _controllers[index].reverse();
        });
      },
      child: AnimatedBuilder(
        animation: _controllers[index],
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _bounceAnimations[index].value),
            child: Transform.scale(
              scale: isSelected ? _scaleAnimations[index].value : 1.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            color.withOpacity(0.2),
                            color.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [color, color.withOpacity(0.7)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: isSelected
                            ? null
                            : AppleTheme.adaptiveSecondaryBackground(context),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        icon,
                        color: isSelected
                            ? Colors.white
                            : AppleTheme.adaptiveTertiaryLabel(context),
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: AppleTheme.caption2.copyWith(
                        color: isSelected
                            ? color
                            : AppleTheme.adaptiveTertiaryLabel(context),
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                      child: Text(label),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
