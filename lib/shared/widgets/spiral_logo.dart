import 'package:flutter/material.dart';
import 'dart:math' as math;

class SpiralLogo extends StatelessWidget {
  final double size;

  const SpiralLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: _SpiralFoodPainter());
  }
}

class _SpiralFoodPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Defines colors from the reference image style
    final orangeColor = const Color(0xFFE87A3D);
    final darkRedColor = const Color(0xFF9A3B2B);
    final greenColor = const Color(0xFF7CA655);
    final yellowColor = const Color(0xFFF4B942);
    final beigeBg = const Color(0xFFFBF8F1);

    // 1. Draw Background Circle
    final bgPaint = Paint()..color = beigeBg;
    canvas.drawCircle(center, radius, bgPaint);

    // 2. Draw the swirly elements (abstract food shapes)

    // Bottom Orange Swirl
    _drawCurvedShape(
      canvas,
      center,
      radius,
      startAngle: math.pi * 0.2,
      sweepAngle: math.pi * 1.2,
      color: orangeColor,
      widthFactor: 0.15,
      radiusFactor: 0.85,
    );

    // Inner Red/Brown Swirl
    _drawCurvedShape(
      canvas,
      center,
      radius,
      startAngle: math.pi * 0.8,
      sweepAngle: math.pi * 1.0,
      color: darkRedColor,
      widthFactor: 0.18,
      radiusFactor: 0.60,
    );

    // Green Leafy Swirl
    _drawCurvedShape(
      canvas,
      center,
      radius,
      startAngle: math.pi * 0.6,
      sweepAngle: math.pi * 0.8,
      color: greenColor,
      widthFactor: 0.15,
      radiusFactor: 0.35,
    );

    // Center Yellow Swirl
    _drawCurvedShape(
      canvas,
      center,
      radius,
      startAngle: 0,
      sweepAngle: math.pi * 2,
      color: yellowColor,
      widthFactor: 0.2,
      radiusFactor: 0.1,
      isCenter: true,
    );

    // 3. Chef's Hat (Top)
    _drawChefHat(canvas, center, radius, darkRedColor);

    // 4. Cutlery (Left - Fork)
    _drawFork(canvas, center, radius, size.width * 0.15, greenColor);

    // 5. Details (Dots)
    _drawSpices(canvas, center, radius, orangeColor);
  }

  void _drawCurvedShape(
    Canvas canvas,
    Offset center,
    double radius, {
    required double startAngle,
    required double sweepAngle,
    required Color color,
    required double widthFactor,
    required double radiusFactor,
    bool isCenter = false,
  }) {
    final paint = Paint()
      ..color = color
      ..style = isCenter ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = radius * widthFactor
      ..strokeCap = StrokeCap.round;

    if (isCenter) {
      canvas.drawCircle(center, radius * radiusFactor, paint);
    } else {
      final path = Path();
      // Create a spiral-like arc
      final rect = Rect.fromCircle(
        center: center,
        radius: radius * radiusFactor,
      );
      path.addArc(rect, startAngle, sweepAngle);
      canvas.drawPath(path, paint);
    }
  }

  void _drawChefHat(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final hatWidth = radius * 0.5;
    final hatBottomY = center.dy - radius * 0.3;
    final hatCenterX = center.dx;

    final path = Path();
    // Hat brim
    path.moveTo(hatCenterX - hatWidth / 2, hatBottomY);
    path.quadraticBezierTo(
      hatCenterX,
      hatBottomY + 10,
      hatCenterX + hatWidth / 2,
      hatBottomY,
    );

    // Hat puffs
    path.moveTo(hatCenterX - hatWidth / 2, hatBottomY);
    path.quadraticBezierTo(
      hatCenterX - hatWidth / 1.5,
      hatBottomY - 30,
      hatCenterX - hatWidth / 3,
      hatBottomY - 40,
    );
    path.quadraticBezierTo(
      hatCenterX,
      hatBottomY - 60,
      hatCenterX + hatWidth / 3,
      hatBottomY - 40,
    );
    path.quadraticBezierTo(
      hatCenterX + hatWidth / 1.5,
      hatBottomY - 30,
      hatCenterX + hatWidth / 2,
      hatBottomY,
    );

    canvas.drawPath(path, paint);
  }

  void _drawFork(
    Canvas canvas,
    Offset center,
    double radius,
    double size,
    Color color,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final forkX = center.dx - radius * 0.5;
    final forkY = center.dy;

    final path = Path();
    // Handle
    path.moveTo(forkX, forkY + 20);
    path.lineTo(forkX, forkY - 10);

    // Tines base
    path.moveTo(forkX - 8, forkY - 10);
    path.quadraticBezierTo(forkX, forkY - 5, forkX + 8, forkY - 10);

    // Tines
    path.moveTo(forkX - 6, forkY - 10);
    path.lineTo(forkX - 6, forkY - 25);

    path.moveTo(forkX, forkY - 5);
    path.lineTo(forkX, forkY - 28);

    path.moveTo(forkX + 6, forkY - 10);
    path.lineTo(forkX + 6, forkY - 25);

    canvas.drawPath(path, paint);
  }

  void _drawSpices(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()..color = color;

    // Random dots around
    final points = [
      Offset(center.dx + radius * 0.6, center.dy - radius * 0.4),
      Offset(center.dx + radius * 0.7, center.dy - radius * 0.2),
      Offset(center.dx - radius * 0.6, center.dy + radius * 0.5),
    ];

    for (var point in points) {
      canvas.drawCircle(point, 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
