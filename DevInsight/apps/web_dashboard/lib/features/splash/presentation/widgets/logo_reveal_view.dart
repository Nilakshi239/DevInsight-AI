import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';

/// Clean, high-contrast Splash reveal:
/// Features a crisp DevInsight logo, tight distance to the brand name,
/// a snappy kinetic letter cascade, and a professional AI project caption.
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

  static const String _brandName = 'DevInsight';
  static const String _caption = 'AI-Powered Software Intelligence';

  @override
  Widget build(BuildContext context) {
    final logoSize = isCompact ? 96.0 : 120.0;
    final titleSize = isCompact ? 44.0 : 58.0;
    final captionSize = isCompact ? 13.5 : 15.5;

    return AnimatedBuilder(
      animation: revealController,
      builder: (context, _) {
        final val = revealController.value;

        // 1. Clean Logo Elastic Spring Entrance: 0.05 -> 0.50
        final logoEnterVal = ((val - 0.05) / 0.45).clamp(0.0, 1.0);
        final logoScale =
            0.40 + 0.60 * Curves.easeOutBack.transform(logoEnterVal);
        final logoOpacity = Curves.easeOutCubic.transform(logoEnterVal);

        // 2. Caption Reveal: 0.58 -> 0.88
        final captionVal = ((val - 0.58) / 0.30).clamp(0.0, 1.0);
        final captionOpacity = Curves.easeOutQuad.transform(captionVal);
        final captionSlideY =
            (1.0 - Curves.easeOutCubic.transform(captionVal)) * 14.0;

        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isCompact ? 420 : 780),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ==================== CLEAN CRISP LOGO ====================
              Opacity(
                opacity: logoOpacity,
                child: Transform.scale(
                  scale: logoScale,
                  child: Semantics(
                    label: 'DevInsight logo',
                    image: true,
                    child: Image.asset(
                      AppAssets.devInsightLogo,
                      width: logoSize,
                      height: logoSize,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      semanticLabel: 'DevInsight logo',
                    ),
                  ),
                ),
              ),

              // Proportional, tight spacing between logo and name
              const SizedBox(height: 10),

              // ==================== LETTER-BY-LETTER KINETIC CASCADE ====================
              Semantics(
                label: 'DevInsight',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_brandName.length, (index) {
                    final isDev = index < 3; // "Dev" in obsidian, "Insight" in blue
                    final letterColor = isDev
                        ? const Color(0xFF0F172A)
                        : AppColors.primaryBlue;

                    // Staggered timing for each letter (cascade wave)
                    final letterStart = 0.32 + index * 0.030;
                    const letterDuration = 0.24;
                    final letterVal =
                        ((val - letterStart) / letterDuration).clamp(0.0, 1.0);

                    // Spring pop & slide for each individual letter
                    final easeSpring =
                        Curves.easeOutBack.transform(letterVal);
                    final letterOpacity =
                        Curves.easeOutQuad.transform(letterVal);
                    final letterSlideY = (1.0 - easeSpring) * 24.0;
                    final letterScale = 0.70 + 0.30 * easeSpring;

                    return Transform.translate(
                      offset: Offset(0, letterSlideY),
                      child: Transform.scale(
                        scale: letterScale,
                        child: Opacity(
                          opacity: letterOpacity,
                          child: Text(
                            _brandName[index],
                            style: GoogleFonts.plusJakartaSans(
                              color: letterColor,
                              fontSize: titleSize,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 10),

              // ==================== SUITABLE PROJECT CAPTION ====================
              Opacity(
                opacity: captionOpacity,
                child: Transform.translate(
                  offset: Offset(0, captionSlideY),
                  child: Text(
                    _caption,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF64748B),
                      fontSize: captionSize,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                      height: 1.3,
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
