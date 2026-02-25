import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A reusable dotted divider widget
class DottedDivider extends StatelessWidget {
  const DottedDivider({
    super.key,
    this.color,
    this.height = 1.0,
    this.dashWidth = 4.0,
    this.dashSpace = 3.0,
  });

  final Color? color;
  final double height;
  final double dashWidth;
  final double dashSpace;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dividerColor = color ?? colorScheme.primary.withValues(alpha: 0.3);

    return CustomPaint(
      painter: _DottedDividerPainter(
        color: dividerColor,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
      ),
      child: SizedBox(
        height: height.h,
        width: double.infinity,
      ),
    );
  }
}

/// Custom painter for dotted divider
class _DottedDividerPainter extends CustomPainter {
  _DottedDividerPainter({
    required this.color,
    required this.dashWidth,
    required this.dashSpace,
  });

  final Color color;
  final double dashWidth;
  final double dashSpace;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

