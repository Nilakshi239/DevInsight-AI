import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';

/// Clean, high-contrast Splash reveal:
/// ONLY the Logo and Name ("DevInsight") are visible on a pure white background.
/// Features snappy, elastic spring physics for the logo and high-contrast typography
/// (deep obsidian "Dev" and radiant blue "Insight" that stay completely visible).
class LogoRevealView extends StatelessWidget {
  final AnimationController revealController;
  final bool isCompact;
  final Widget loadingArea;

  const LogoRevealView({
    super.key,
    required this.revealController,
    required this.isCompact,
    required this.loadingArea,
  });

  @override
  Widget build(BuildContext context) {
    final logoSize = isCompact ? 104.0 : 132.0;
    final titleSize = isCompact ? 50.0 : 68.0;

    return AnimatedBuilder(
      animation: revealController,
      builder: (context, _) {
        final val = revealController.value;

        // 1. Concentric Ripple Animation: 0.0 -> 0.45
        final rippleProgress = (val / 0.45).clamp(0.0, 1.0);

        // 2. Elastic Spring Scale & Rotation (Slack-inspired snappy overshoot): 0.08 -> 0.58
        final logoEnterVal = ((val - 0.08) / 0.50).clamp(0.0, 1.0);
        final logoScale = 0.25 + 0.75 * Curves.easeOutBack.transform(logoEnterVal);
        final logoRotation = (1.0 - Curves.easeOutBack.transform(logoEnterVal)) * -0.10;
        final logoOpacity = Curves.easeOutCubic.transform(logoEnterVal);

        // 3. Specular Light Sweep Sheen on Logo: 0.42 -> 0.85
        final shimmerVal = ((val - 0.42) / 0.43).clamp(0.0, 1.0);
        final shimmerProgress =
            -1.0 + 3.0 * Curves.easeInOutCubic.transform(shimmerVal);

        // 4. Kinetic Typography Reveal ("DevInsight"): 0.38 -> 0.80
        final textEnterVal = ((val - 0.38) / 0.42).clamp(0.0, 1.0);
        final textOpacity = Curves.easeOutQuad.transform(textEnterVal);
        final textSlide =
            (1.0 - Curves.easeOutCubic.transform(textEnterVal)) * 26.0;
        final letterSpacing =
            1.8 - (3.2 * Curves.easeOutCubic.transform(textEnterVal));

        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isCompact ? 420 : 780),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ==================== LOGO STAGE ====================
              SizedBox(
                width: logoSize * 1.7,
                height: logoSize * 1.7,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Concentric expanding shockwave ripples
                    if (rippleProgress > 0.0 && rippleProgress < 1.0)
                      CustomPaint(
                        size: Size.square(logoSize * 1.7),
                        painter: _RippleWavePainter(progress: rippleProgress),
                      ),

                    // Elastic Spring Logo with Specular Sheen
                    Opacity(
                      opacity: logoOpacity,
                      child: Transform.rotate(
                        angle: logoRotation,
                        child: Transform.scale(
                          scale: logoScale,
                          child: Semantics(
                            label: 'DevInsight logo',
                            image: true,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  AppAssets.devInsightLogo,
                                  width: logoSize,
                                  height: logoSize,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                  semanticLabel: 'DevInsight logo',
                                ),

                                // Specular light sweep sheen overlay on logo
                                if (shimmerVal > 0.0 && shimmerVal < 1.0)
                                  SizedBox(
                                    width: logoSize,
                                    height: logoSize,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(logoSize / 2),
                                      child: CustomPaint(
                                        painter: _LightSweepPainter(
                                          progress: shimmerProgress,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ==================== HIGH-CONTRAST BRAND NAME ("DevInsight") ====================
              Opacity(
                opacity: textOpacity,
                child: Transform.translate(
                  offset: Offset(0, textSlide),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Dev',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF0F172A), // Deep obsidian black
                            fontSize: titleSize,
                            fontWeight: FontWeight.w800,
                            letterSpacing: letterSpacing,
                            height: 1.15,
                          ),
                        ),
                        TextSpan(
                          text: 'Insight',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.primaryBlue, // Radiant Electric Blue
                            fontSize: titleSize,
                            fontWeight: FontWeight.w800,
                            letterSpacing: letterSpacing,
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ==================== ERROR / OFFLINE AREA ONLY (EMPTY WHEN ONLINE) ====================
              loadingArea,
            ],
          ),
        );
      },
    );
  }
}

/// Paints radiant concentric shockwave ripples expanding from behind the logo.
class _RippleWavePainter extends CustomPainter {
  final double progress; // 0.0 to 1.0

  const _RippleWavePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0 || progress >= 1.0) return;
    final center = size.center(Offset.zero);
    final maxRadius = size.width * 0.50;

    // Primary ripple
    final r1 = maxRadius * (0.25 + 0.75 * progress);
    final alpha1 = (1.0 - progress) * 0.40;
    final paint1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2 * (1.0 - progress * 0.45)
      ..color = const Color(0xFF38BDF8).withValues(alpha: alpha1);
    canvas.drawCircle(center, r1, paint1);

    // Echo ripple
    if (progress > 0.18) {
      final p2 = ((progress - 0.18) / 0.82).clamp(0.0, 1.0);
      final r2 = maxRadius * (0.20 + 0.80 * p2);
      final alpha2 = (1.0 - p2) * 0.28;
      final paint2 = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6 * (1.0 - p2 * 0.4)
        ..color = const Color(0xFF0664F2).withValues(alpha: alpha2);
      canvas.drawCircle(center, r2, paint2);
    }
  }

  @override
  bool shouldRepaint(covariant _RippleWavePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Paints a cinematic diagonal specular light sweep across the logo.
class _LightSweepPainter extends CustomPainter {
  final double progress;

  const _LightSweepPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final sweepWidth = size.width * 0.40;
    final startX = (size.width + sweepWidth * 2) * progress - sweepWidth;

    final paint = Paint()
      ..blendMode = BlendMode.screen
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.65),
          const Color(0xFF93C5FD).withValues(alpha: 0.85),
          Colors.white.withValues(alpha: 0.65),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.35, 0.50, 0.65, 1.0],
      ).createShader(Rect.fromLTWH(startX, 0, sweepWidth, size.height));

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _LightSweepPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
