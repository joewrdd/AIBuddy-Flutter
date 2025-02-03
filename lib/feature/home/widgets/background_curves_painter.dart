import 'package:flutter/material.dart';

class BackgroundCurvesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Draw multiple concentric curves with a more subtle, retro pattern
    for (double i = 0; i < size.height * 1.2; i += 40) {
      final path = Path()
        ..moveTo(0, i)
        ..quadraticBezierTo(
          size.width / 3,
          i - 15,
          size.width / 2,
          i,
        )
        ..quadraticBezierTo(
          size.width * 2 / 3,
          i + 15,
          size.width,
          i,
        );
      canvas.drawPath(path, paint);

      // Add crossing lines for a grid effect
      if (i % 80 == 0) {
        final horizontalPath = Path()
          ..moveTo(0, i)
          ..lineTo(size.width, i);
        canvas.drawPath(horizontalPath, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
