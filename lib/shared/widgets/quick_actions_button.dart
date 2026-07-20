import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math' as math;
import '../../core/theme/app_colors.dart';
import '../../core/theme/apple_theme.dart';

class QuickActionsButton extends StatefulWidget {
  const QuickActionsButton({super.key});

  @override
  State<QuickActionsButton> createState() => _QuickActionsButtonState();
}

class _QuickActionsButtonState extends State<QuickActionsButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotationAnimation;
  bool _isExpanded = false;

  List<Map<String, dynamic>> _getActions(BuildContext context) => [
    {
      'icon': CupertinoIcons.add,
      'label': 'Recette',
      'color': AppColors.primary(context),
      'gradient': AppColors.primaryGradient(context),
      'isPrimary': true, // Action principale
    },
    {
      'icon': CupertinoIcons.camera_fill,
      'label': 'Scanner',
      'color': AppColors.primary(context),
      'gradient': AppColors.primaryGradient(context),
      'isPrimary': false,
    },
    {
      'icon': CupertinoIcons.cart_fill,
      'label': 'Courses',
      'color': AppColors.primary(context),
      'gradient': AppColors.primaryGradient(context),
      'isPrimary': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300), // Plus rapide = plus réactif
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    _rotationAnimation =
        Tween<double>(
          begin: 0,
          end: math.pi / 4, // 45 degrés
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Background overlay
        if (_isExpanded)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleMenu,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isExpanded ? 1.0 : 0.0,
                child: Container(color: Colors.black.withValues(alpha: 0.2)), // Overlay plus léger
              ),
            ),
          ),

        // Action buttons
        ..._buildActionButtons(context),

        // Main FAB
        Positioned(
          bottom: 16,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return GestureDetector(
                onTap: _toggleMenu,
                child: Container(
                  width: 56, // Taille iOS standard
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient(context),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary(context).withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: Icon(
                      _isExpanded ? CupertinoIcons.xmark : CupertinoIcons.add,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActionButtons(BuildContext context) {
    final List<Widget> buttons = [];
    final actions = _getActions(context);
    const double radius = 100; // Rayon réduit pour meilleure ergonomie
    const double startAngle = math.pi; // Commence à gauche
    final double angleStep =
        math.pi / (actions.length + 1); // Répartition en arc

    for (int i = 0; i < actions.length; i++) {
      final action = actions[i];
      final angle = startAngle + (angleStep * (i + 1));

      buttons.add(
        AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            final x = radius * math.cos(angle) * _expandAnimation.value;
            final y = -radius * math.sin(angle) * _expandAnimation.value;

            return Positioned(
              bottom: 51 + y, // 51 = 16 (bottom) + 35 (half of FAB)
              left: MediaQuery.of(context).size.width / 2 + x - 35,
              child: Opacity(
                opacity: _expandAnimation.value,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _toggleMenu();
                        _handleAction(action['label']);
                      },
                      child: Container(
                        width: action['isPrimary'] == true ? 64 : 52, // Hiérarchie visuelle
                        height: action['isPrimary'] == true ? 64 : 52,
                        decoration: BoxDecoration(
                          gradient: action['gradient'],
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (action['color'] as Color).withValues(alpha: 
                                0.4,
                              ),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          action['icon'],
                          color: Colors.white,
                          size: action['isPrimary'] == true ? 28 : 24, // Icons plus grandes pour primaire
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppleTheme.adaptiveBackground(context),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        action['label'],
                        style: AppleTheme.caption1.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppleTheme.adaptiveLabel(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    return buttons;
  }

  void _handleAction(String action) {
    // Gestionnaire d'actions
    debugPrint('Action selected: $action');
    // Ici vous pouvez ajouter la navigation ou la logique pour chaque action
  }
}
