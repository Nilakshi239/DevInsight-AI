import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class CharmingAuthBackground extends StatefulWidget {
  final Widget child;

  const CharmingAuthBackground({
    super.key,
    required this.child,
  });

  @override
  State<CharmingAuthBackground> createState() => _CharmingAuthBackgroundState();
}

class _CharmingAuthBackgroundState extends State<CharmingAuthBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Base Gradient Canvas
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF6F9FE),
                Color(0xFFEEF5FF),
                Color(0xFFF3F7FE),
                Color(0xFFF8FAFD),
              ],
              stops: [0.0, 0.35, 0.70, 1.0],
            ),
          ),
        ),

        // 2. Animated Ambient Glowing Blobs
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final t = Curves.easeInOutSine.transform(_controller.value);
            return CustomPaint(
              painter: _CharmingAuraPainter(progress: t),
              size: Size.infinite,
            );
          },
        ),

        // 3. Subtle Technical Grid Pattern for Depth
        const Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(painter: _SubtleGridPainter()),
          ),
        ),

        // 4. Foreground Content
        widget.child,
      ],
    );
  }
}

class _CharmingAuraPainter extends CustomPainter {
  final double progress;

  _CharmingAuraPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Orb 1: Top-Left Cyan & Sky Bloom
    final orb1Center = Offset(
      w * 0.18 + 25 * (progress - 0.5),
      h * 0.25 + 20 * (0.5 - progress),
    );
    _drawGlow(
      canvas,
      center: orb1Center,
      radius: w * 0.28,
      colors: [
        const Color(0xFF60A5FA).withValues(alpha: 0.30),
        const Color(0xFF38BDF8).withValues(alpha: 0.15),
        const Color(0x00000000),
      ],
      blur: 90,
    );

    // Orb 2: Center-Right Halo behind Login Card
    final orb2Center = Offset(
      w * 0.72 + 30 * (0.5 - progress),
      h * 0.50 + 25 * (progress - 0.5),
    );
    _drawGlow(
      canvas,
      center: orb2Center,
      radius: w * 0.32,
      colors: [
        const Color(0xFF818CF8).withValues(alpha: 0.25),
        const Color(0xFF93C5FD).withValues(alpha: 0.14),
        const Color(0x00000000),
      ],
      blur: 110,
    );

    // Orb 3: Bottom-Left Glow underneath the 3D Laptop
    final orb3Center = Offset(
      w * 0.30 + 20 * (progress - 0.5),
      h * 0.75 + 15 * (progress - 0.5),
    );
    _drawGlow(
      canvas,
      center: orb3Center,
      radius: w * 0.24,
      colors: [
        const Color(0xFF3B82F6).withValues(alpha: 0.22),
        const Color(0xFF0664F2).withValues(alpha: 0.08),
        const Color(0x00000000),
      ],
      blur: 85,
    );

    // Dot Matrix Accents
    _drawDotGrid(canvas, Offset(w * 0.04, h * 0.40), 3, 6, 14, 1.3);
    _drawDotGrid(canvas, Offset(w * 0.48, h * 0.86), 7, 3, 14, 1.3);
    _drawDotGrid(canvas, Offset(w * 0.90, h * 0.16), 3, 6, 14, 1.3);
  }

  void _drawGlow(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required List<Color> colors,
    required double blur,
  }) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: colors,
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..imageFilter = ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur);

    canvas.drawCircle(center, radius, paint);
  }

  void _drawDotGrid(
    Canvas canvas,
    Offset origin,
    int cols,
    int rows,
    double gap,
    double r,
  ) {
    final p = Paint()
      ..color = const Color(0xFF60A5FA).withValues(alpha: 0.35);
    for (var x = 0; x < cols; x++) {
      for (var y = 0; y < rows; y++) {
        canvas.drawCircle(origin + Offset(x * gap, y * gap), r, p);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CharmingAuraPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _SubtleGridPainter extends CustomPainter {
  const _SubtleGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x0A0664F2)
      ..strokeWidth = 1.0;

    const spacing = 52.0;
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SubtleGridPainter oldDelegate) => false;
}
