import 'package:flutter/material.dart';

/// Wrap any page (splash, landing, app...) with this to get the Figma light background.
///
/// Scaffold(
///   backgroundColor: Colors.transparent,
///   body: AppBackground(child: YourContent()),
/// )
class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(painter: _BackgroundPainter()),
          ),
        ),
        child,
      ],
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  const _BackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Offset.zero & size;

    // 1. Base light gradient canvas background (soft off-white to icy blue)
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFEFF5FF),
            Color(0xFFF7FAFD),
            Color(0xFFEBF3FE),
            Color(0xFFF3F8FE),
          ],
          stops: [0.0, 0.35, 0.70, 1.0],
        ).createShader(rect),
    );

    final fill = Paint()..style = PaintingStyle.fill;
    final stroke = Paint()..style = PaintingStyle.stroke;

    // 2. Top-Left Wavy Gradient Layers & Curves
    final topLeft1 = Path()
      ..moveTo(0, 0)
      ..lineTo(w * 0.46, 0)
      ..cubicTo(w * 0.40, h * 0.22, w * 0.22, h * 0.42, 0, h * 0.52)
      ..close();
    canvas.drawPath(
      topLeft1,
      fill
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFC7DEFE).withValues(alpha: 0.55),
            const Color(0xFFE3EFFF).withValues(alpha: 0.15),
          ],
        ).createShader(rect),
    );

    final topLeft2 = Path()
      ..moveTo(0, 0)
      ..lineTo(w * 0.30, 0)
      ..cubicTo(w * 0.25, h * 0.16, w * 0.12, h * 0.30, 0, h * 0.38)
      ..close();
    canvas.drawPath(
      topLeft2,
      fill
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF9EC7FE).withValues(alpha: 0.45),
            const Color(0xFFCBE0FE).withValues(alpha: 0.10),
          ],
        ).createShader(rect),
    );

    // Top-Left concentric outline stroke curves
    for (var i = 0; i < 3; i++) {
      final offsetFrac = i * 0.04;
      final linePath = Path()
        ..moveTo(w * (0.34 + offsetFrac), 0)
        ..cubicTo(
          w * (0.29 + offsetFrac),
          h * 0.18,
          w * (0.15 + offsetFrac),
          h * 0.34,
          0,
          h * (0.44 + offsetFrac),
        );
      canvas.drawPath(
        linePath,
        stroke
          ..strokeWidth = 1.3
          ..color = const Color(0xFF60A5FA).withValues(alpha: 0.32 - i * 0.08),
      );
    }

    // 3. Top-Right Wave Shape & Accents
    final topRightWave = Path()
      ..moveTo(w * 0.62, 0)
      ..cubicTo(w * 0.74, h * 0.14, w * 0.88, h * 0.10, w, h * 0.26)
      ..lineTo(w, 0)
      ..close();
    canvas.drawPath(
      topRightWave,
      fill
        ..shader = LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            const Color(0xFFC7DEFE).withValues(alpha: 0.45),
            const Color(0xFFEDF5FF).withValues(alpha: 0.10),
          ],
        ).createShader(rect),
    );

    final topRightLine = Path()
      ..moveTo(w * 0.58, 0)
      ..cubicTo(w * 0.70, h * 0.16, w * 0.86, h * 0.12, w, h * 0.30);
    canvas.drawPath(
      topRightLine,
      stroke
        ..strokeWidth = 1.2
        ..color = const Color(0xFF93C5FD).withValues(alpha: 0.30),
    );

    // 4. Center Soft Ambient Glow
    final centerGlow = Path()
      ..moveTo(w * 0.30, h * 0.15)
      ..cubicTo(w * 0.60, h * 0.05, w * 0.90, h * 0.25, w * 0.85, h * 0.50)
      ..cubicTo(w * 0.80, h * 0.80, w * 0.50, h * 0.92, w * 0.25, h * 0.75)
      ..cubicTo(w * 0.12, h * 0.65, w * 0.10, h * 0.25, w * 0.30, h * 0.15)
      ..close();
    canvas.drawPath(
      centerGlow,
      fill
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFDCEBFF).withValues(alpha: 0.35),
            const Color(0xFFEFF5FF).withValues(alpha: 0.0),
          ],
        ).createShader(rect),
    );

    // 5. Bottom-Left Liquid Wave
    final bottomLeftWave = Path()
      ..moveTo(0, h * 0.58)
      ..cubicTo(w * 0.18, h * 0.60, w * 0.32, h * 0.78, w * 0.24, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      bottomLeftWave,
      fill
        ..shader = LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            const Color(0xFFB0D3FE).withValues(alpha: 0.45),
            const Color(0xFFE3EFFF).withValues(alpha: 0.15),
          ],
        ).createShader(rect),
    );



    // 6. Bottom-Right Layered Liquid Waves
    final bottomRightOuter = Path()
      ..moveTo(w * 0.40, h)
      ..cubicTo(w * 0.54, h * 0.74, w * 0.78, h * 0.58, w, h * 0.46)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(
      bottomRightOuter,
      fill
        ..shader = LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            const Color(0xFF9EC7FE).withValues(alpha: 0.45),
            const Color(0xFFDBEAFE).withValues(alpha: 0.12),
          ],
        ).createShader(rect),
    );

    final bottomRightInner = Path()
      ..moveTo(w * 0.56, h)
      ..cubicTo(w * 0.66, h * 0.80, w * 0.84, h * 0.68, w, h * 0.60)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(
      bottomRightInner,
      fill
        ..shader = LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            const Color(0xFF70A8FF).withValues(alpha: 0.35),
            const Color(0xFFC7DEFE).withValues(alpha: 0.10),
          ],
        ).createShader(rect),
    );

    // Bottom-Right concentric outline stroke curves
    for (var i = 0; i < 4; i++) {
      final d = i * 0.05;
      final waveStroke = Path()
        ..moveTo(w * (0.36 + d), h)
        ..cubicTo(
          w * (0.50 + d),
          h * 0.72,
          w * (0.76 + d),
          h * 0.55,
          w,
          h * (0.42 + d),
        );
      canvas.drawPath(
        waveStroke,
        stroke
          ..strokeWidth = 1.2
          ..color = const Color(0xFF3B82F6).withValues(alpha: 0.28 - i * 0.06),
      );
    }

    // 7. Dot Grid Pattern Accents (Figma Dot Matrix)
    _dots(canvas, Offset(w * 0.46, h * 0.88), 7, 3, 12, 1.2);
    _dots(canvas, Offset(w * 0.88, h * 0.14), 3, 7, 10, 1.2);
    _dots(canvas, Offset(w * 0.03, h * 0.38), 2, 6, 10, 1.2);
  }

  void _dots(
    Canvas c,
    Offset origin,
    int cols,
    int rows,
    double gap,
    double r,
  ) {
    final p = Paint()
      ..color = const Color(0xFF60A5FA).withValues(alpha: 0.25);
    for (var x = 0; x < cols; x++) {
      for (var y = 0; y < rows; y++) {
        c.drawCircle(origin + Offset(x * gap, y * gap), r, p);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
