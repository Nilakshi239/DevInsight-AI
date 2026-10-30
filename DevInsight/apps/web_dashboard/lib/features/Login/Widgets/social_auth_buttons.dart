import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

class SocialAuthButtons extends StatelessWidget {
  final VoidCallback? onGithub;
  final VoidCallback? onGoogle;
  final VoidCallback? onMicrosoft;

  const SocialAuthButtons({
    super.key,
    this.onGithub,
    this.onGoogle,
    this.onMicrosoft,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SocialButton(
            icon: const _GithubIcon(size: 20),
            label: 'GitHub',
            onPressed: onGithub,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _SocialButton(
            icon: const _GoogleIcon(size: 20),
            label: 'Google',
            onPressed: onGoogle,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _SocialButton(
            icon: const _MicrosoftIcon(size: 19),
            label: 'Microsoft',
            onPressed: onMicrosoft,
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatefulWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onPressed;

  const _SocialButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: _isHovered ? const Color(0xFFF8FAFC) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered ? AppColors.primaryBlue : const Color(0xFFE2E8F0),
              width: _isHovered ? 1.6 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.primaryBlue.withValues(alpha: 0.12)
                    : const Color(0xFF0F172A).withValues(alpha: 0.03),
                blurRadius: _isHovered ? 12 : 4,
                offset: Offset(0, _isHovered ? 4 : 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.icon,
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF1E293B),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Custom Vector Icons
// ---------------------------------------------------------------------------

class _MicrosoftIcon extends StatelessWidget {
  final double size;
  const _MicrosoftIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    final s = (size - 2.5) / 2;
    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: s,
                height: s,
                decoration: const BoxDecoration(
                  color: Color(0xFFF25022),
                  borderRadius: BorderRadius.all(Radius.circular(1)),
                ),
              ),
              Container(
                width: s,
                height: s,
                decoration: const BoxDecoration(
                  color: Color(0xFF7FBA00),
                  borderRadius: BorderRadius.all(Radius.circular(1)),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: s,
                height: s,
                decoration: const BoxDecoration(
                  color: Color(0xFF00A4EF),
                  borderRadius: BorderRadius.all(Radius.circular(1)),
                ),
              ),
              Container(
                width: s,
                height: s,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFB900),
                  borderRadius: BorderRadius.all(Radius.circular(1)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  final double size;
  const _GoogleIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w / 2;
    final strokeWidth = radius * 0.38;
    final arcRadius = radius - strokeWidth / 2;
    final arcRect = Rect.fromCircle(center: center, radius: arcRadius);

    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Draw Google 4 arc segments
    canvas.drawArc(arcRect, -0.65, 1.25, false, bluePaint);
    canvas.drawArc(arcRect, 0.60, 1.55, false, greenPaint);
    canvas.drawArc(arcRect, 2.15, 1.25, false, yellowPaint);
    canvas.drawArc(arcRect, 3.40, 1.75, false, redPaint);

    // Blue horizontal bar
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    final barRect = Rect.fromLTRB(
      center.dx,
      center.dy - strokeWidth / 2,
      w,
      center.dy + strokeWidth / 2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(barRect, Radius.circular(strokeWidth / 4)),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GithubIcon extends StatelessWidget {
  final double size;
  const _GithubIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GithubLogoPainter(),
    );
  }
}

class _GithubLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    final paint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.scale(scale, scale);

    final path = Path()
      ..moveTo(12, 0)
      ..cubicTo(5.37, 0, 0, 5.37, 0, 12)
      ..cubicTo(0, 17.31, 3.435, 21.795, 8.205, 23.385)
      ..cubicTo(8.805, 23.49, 9.03, 23.13, 9.03, 22.815)
      ..cubicTo(9.03, 22.53, 9.015, 21.585, 9.015, 20.58)
      ..cubicTo(6, 21.135, 5.22, 19.845, 4.98, 19.17)
      ..cubicTo(4.845, 18.825, 4.26, 17.76, 3.75, 17.475)
      ..cubicTo(3.33, 17.25, 2.73, 16.695, 3.735, 16.68)
      ..cubicTo(4.68, 16.665, 5.355, 17.55, 5.58, 17.91)
      ..cubicTo(6.66, 19.725, 8.385, 19.215, 9.075, 18.9)
      ..cubicTo(9.18, 18.12, 9.495, 17.595, 9.84, 17.295)
      ..cubicTo(7.17, 16.995, 4.38, 15.96, 4.38, 11.37)
      ..cubicTo(4.38, 10.065, 4.845, 8.985, 5.61, 8.145)
      ..cubicTo(5.49, 7.845, 5.07, 6.615, 5.73, 4.965)
      ..cubicTo(5.73, 4.965, 6.735, 4.65, 9.03, 6.195)
      ..cubicTo(9.99, 5.925, 11.01, 5.79, 12.03, 5.79)
      ..cubicTo(13.05, 5.79, 14.07, 5.925, 15.03, 6.195)
      ..cubicTo(17.325, 4.635, 18.33, 4.965, 18.33, 4.965)
      ..cubicTo(18.99, 6.615, 18.57, 7.845, 18.45, 8.145)
      ..cubicTo(19.215, 8.985, 19.68, 10.05, 19.68, 11.37)
      ..cubicTo(19.68, 15.975, 16.875, 16.995, 14.205, 17.295)
      ..cubicTo(14.64, 17.67, 15.015, 18.39, 15.015, 19.515)
      ..cubicTo(15.015, 21.12, 15, 22.41, 15, 22.815)
      ..cubicTo(15, 23.13, 15.225, 23.505, 15.825, 23.385)
      ..cubicTo(20.595, 21.795, 24.03, 17.31, 24.03, 12)
      ..cubicTo(24.03, 5.37, 18.66, 0, 12, 0)
      ..close();

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
