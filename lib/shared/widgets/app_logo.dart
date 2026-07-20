import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLogo({super.key, this.size = 100, this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _AppLogoPainter(color: color ?? const Color(0xFF5FB574)),
    );
  }
}

class _AppLogoPainter extends CustomPainter {
  final Color color;

  _AppLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw leaf only
    _drawLeaf(canvas, center, size.width * 0.4, color);
  }

  void _drawLeaf(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Simple leaf shape
    path.moveTo(center.dx, center.dy - size * 0.3);
    path.quadraticBezierTo(
      center.dx + size * 0.3,
      center.dy - size * 0.1,
      center.dx,
      center.dy + size * 0.4,
    );
    path.quadraticBezierTo(
      center.dx - size * 0.3,
      center.dy - size * 0.1,
      center.dx,
      center.dy - size * 0.3,
    );

    canvas.drawPath(path, paint);

    // Leaf vein
    final veinPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.08;

    canvas.drawLine(
      Offset(center.dx, center.dy - size * 0.2),
      Offset(center.dx, center.dy + size * 0.3),
      veinPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
