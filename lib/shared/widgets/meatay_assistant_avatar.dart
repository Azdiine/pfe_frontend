import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Avatar officiel de "Meatay Assistant".
/// Dessin vectoriel inspiré du logo Meatay : cercle aux couleurs chaudes
/// (rouge brique, orange, vert olive, doré) avec les arcs tourbillonnants
/// du logo, une toque de chef et un visage de robot souriant.
class MeatayAssistantAvatar extends StatelessWidget {
  final double size;

  const MeatayAssistantAvatar({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _MeatayAvatarPainter()),
    );
  }
}

class _MeatayAvatarPainter extends CustomPainter {
  // Palette extraite du logo Meatay
  static const Color _brickRed = Color(0xFF8C2F1B);
  static const Color _orange = Color(0xFFE0731D);
  static const Color _olive = Color(0xFF7D8A3C);
  static const Color _gold = Color(0xFFE9A83E);
  static const Color _cream = Color(0xFFFDF3E3);
  static const Color _face = Color(0xFF4A2A18);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final center = Offset(s / 2, s / 2);
    final radius = s / 2;

    // Fond crème
    canvas.drawCircle(center, radius, Paint()..color = _cream);

    // Arcs tourbillonnants (comme le cercle du logo)
    final arcRect = Rect.fromCircle(center: center, radius: radius * 0.86);
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.20
      ..strokeCap = StrokeCap.round;

    arcPaint.color = _brickRed;
    canvas.drawArc(arcRect, _deg(-150), _deg(105), false, arcPaint);

    arcPaint.color = _orange;
    canvas.drawArc(arcRect, _deg(-30), _deg(100), false, arcPaint);

    arcPaint.color = _olive;
    canvas.drawArc(arcRect, _deg(85), _deg(70), false, arcPaint);

    // Points dorés (accents du logo)
    canvas.drawCircle(
      Offset(s * 0.145, s * 0.38), s * 0.045, Paint()..color = _gold);
    canvas.drawCircle(
      Offset(s * 0.83, s * 0.72), s * 0.045, Paint()..color = _gold);

    // Toque de chef
    final hatPaint = Paint()..color = Colors.white;
    final hatOutline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.022
      ..color = _brickRed;

    final hatPath = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(s * 0.375, s * 0.40), radius: s * 0.095))
      ..addOval(Rect.fromCircle(
          center: Offset(s * 0.50, s * 0.355), radius: s * 0.115))
      ..addOval(Rect.fromCircle(
          center: Offset(s * 0.625, s * 0.40), radius: s * 0.095))
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTRB(s * 0.365, s * 0.42, s * 0.635, s * 0.535),
        Radius.circular(s * 0.02),
      ));
    canvas.drawPath(hatPath, hatPaint);
    canvas.drawPath(hatPath, hatOutline);

    // Bandeau de la toque
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(s * 0.365, s * 0.505, s * 0.635, s * 0.545),
        Radius.circular(s * 0.02),
      ),
      Paint()..color = _brickRed,
    );

    // Yeux
    final eyePaint = Paint()..color = _face;
    canvas.drawCircle(Offset(s * 0.425, s * 0.645), s * 0.038, eyePaint);
    canvas.drawCircle(Offset(s * 0.575, s * 0.645), s * 0.038, eyePaint);

    // Sourire
    final smilePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.028
      ..strokeCap = StrokeCap.round
      ..color = _face;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(s * 0.50, s * 0.665), radius: s * 0.085),
      _deg(25),
      _deg(130),
      false,
      smilePaint,
    );
  }

  double _deg(double degrees) => degrees * math.pi / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
