import 'package:flutter/material.dart';
import 'dart:math' as math;

class LotusIcon extends StatelessWidget {
  final double size;
  final Color color;
  const LotusIcon({super.key, this.size = 24, this.color = const Color(0xFF4F8A8B)});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LotusPainter(color),
      ),
    );
  }
}

class _LotusPainter extends CustomPainter {
  final Color color;
  _LotusPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final petals = 6;
    final radius = size.width / 2.2;
    for (int i = 0; i < petals; i++) {
      final angle = (i / petals) * 2 * math.pi;
      final petalCenter = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..quadraticBezierTo(
          (center.dx + petalCenter.dx) / 2,
          (center.dy + petalCenter.dy) / 2 - size.height / 4,
          petalCenter.dx,
          petalCenter.dy,
        )
        ..quadraticBezierTo(
          (center.dx + petalCenter.dx) / 2,
          (center.dy + petalCenter.dy) / 2 + size.height / 4,
          center.dx,
          center.dy,
        );
      canvas.drawPath(path, paint);
    }
  canvas.drawCircle(center, size.width / 7, paint..color = color.withValues(alpha: 0.7));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}