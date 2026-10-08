import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
// CHANGED: removed animated_aura_background import, added AppBackground
import '../widgets/app_background.dart';
import '../widgets/dashboard_preview.dart';
import '../widgets/landing_sections.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late final GlobalKey featuresSectionKey;
  late final GlobalKey howItWorksSectionKey;
  late final GlobalKey researchSectionKey;
  late final GlobalKey aboutSectionKey;
  late final GlobalKey ctaSectionKey;
  late final List<GlobalKey> _sectionKeys;

  final ScrollController _scrollController = ScrollController();
  int _activeSection = 0;

  @override
  void initState() {
    super.initState();
    featuresSectionKey = GlobalKey();
    howItWorksSectionKey = GlobalKey();
    researchSectionKey = GlobalKey();
    aboutSectionKey = GlobalKey();
    ctaSectionKey = GlobalKey();
    _sectionKeys = <GlobalKey>[
      GlobalKey(),
      featuresSectionKey,
      howItWorksSectionKey,
      researchSectionKey,
      aboutSectionKey,
    ];
    _scrollController.addListener(_updateActiveSection);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_updateActiveSection)
      ..dispose();
    super.dispose();
  }

  void _updateActiveSection() {
    for (var i = _sectionKeys.length - 1; i >= 1; i--) {
      final context = _sectionKeys[i].currentContext;
      final renderObject = context?.findRenderObject();
      if (renderObject is RenderBox &&
          renderObject.localToGlobal(Offset.zero).dy <= 120) {
        if (_activeSection != i) setState(() => _activeSection = i);
        return;
      }
    }
    if (_activeSection != 0) setState(() => _activeSection = 0);
  }

  Future<void> _scrollTo(GlobalKey key) async {
    final context = key.currentContext;
    if (context == null) return;
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
      alignment: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // CHANGED: AppBackground replaces the old Stack + AnimatedAuraBackground.
      // The background stays fixed while the CustomScrollView scrolls on top.
      body: AppBackground(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _NavbarDelegate(
                activeSection: _activeSection,
                onNavigate: (index) => _scrollTo(_sectionKeys[index]),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _HeroSection(),
                  FeaturesSection(key: featuresSectionKey),
                  HowItWorksSection(key: howItWorksSectionKey),
                  ResearchSection(
                    key: researchSectionKey,
                    onLearnMore: () => _scrollTo(aboutSectionKey),
                  ),
                  AboutSection(key: aboutSectionKey),
                  CtaSection(
                    key: ctaSectionKey,
                    onGetStarted: () => _scrollTo(featuresSectionKey),
                    onSignIn: () {},
                  ),
                  LandingFooter(
                    onFeatures: () => _scrollTo(featuresSectionKey),
                    onHowItWorks: () => _scrollTo(howItWorksSectionKey),
                    onResearch: () => _scrollTo(researchSectionKey),
                    onAbout: () => _scrollTo(aboutSectionKey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Navbar
// ---------------------------------------------------------------------------

class _NavbarDelegate extends SliverPersistentHeaderDelegate {
  const _NavbarDelegate({
    required this.activeSection,
    required this.onNavigate,
  });

  final int activeSection;
  final ValueChanged<int> onNavigate;

  @override
  double get minExtent => 72;

  @override
  double get maxExtent => 72;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            // CHANGED: transparent at the top (like the Figma), frosted white
            // once the page is scrolled under the navbar.
            color: Colors.white.withValues(alpha: overlapsContent ? 0.85 : 0.0),
            border: overlapsContent
                ? const Border(
                    bottom: BorderSide(color: Color(0xFFEAEEF5), width: 1),
                  )
                : null,
            boxShadow: overlapsContent
                ? [
                    const BoxShadow(
                      color: Color(0x10000000),
                      blurRadius: 12,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: SizedBox(
            height: 72,
            child: SafeArea(
              bottom: false,
              child: _LandingNav(
                activeSection: activeSection,
                onNavigate: onNavigate,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_NavbarDelegate oldDelegate) =>
      oldDelegate.activeSection != activeSection;
}

class _LandingNav extends StatelessWidget {
  const _LandingNav({required this.activeSection, required this.onNavigate});

  final int activeSection;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 900;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width > 1400 ? 64 : 32,
            ),
            child: Row(
              children: [
                _Wordmark(),
                const Spacer(),
                if (!isMobile) ...[
                  _NavText('Features', 1, activeSection, () => onNavigate(1)),
                  _NavText(
                    'How It Works',
                    2,
                    activeSection,
                    () => onNavigate(2),
                  ),
                  _NavText('Research', 3, activeSection, () => onNavigate(3)),
                  _NavText('About Us', 4, activeSection, () => onNavigate(4)),
                  const SizedBox(width: 42),
                  _NavText('Sign in', -1, activeSection, () {}),
                  const SizedBox(width: 18),
                ] else
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.menu_rounded,
                      color: AppColors.slateText,
                    ),
                  ),
                _ActionButton(
                  label: 'Get Started',
                  onPressed: () => onNavigate(1),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Wordmark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(AppAssets.devInsightLogo, width: 42, height: 42),
        const SizedBox(width: 9),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Dev',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                text: 'Insight',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NavText extends StatelessWidget {
  const _NavText(this.text, this.index, this.active, this.onPressed);
  final String text;
  final int index;
  final int active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: index == active ? AppColors.primaryBlue : AppColors.slateText,
          fontSize: 15,
          fontWeight: index == active ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Hero section
// ---------------------------------------------------------------------------

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 1000;
    final horizontal = MediaQuery.sizeOf(context).width > 1400 ? 64.0 : 32.0;
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.fromLTRB(horizontal, 60, horizontal, 100),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: isMobile
                ? Column(
                    children: [
                      const _HeroCopy(),
                      const SizedBox(height: 44),
                      const _PreviewArea(),
                    ],
                  )
                : const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 10, child: _HeroCopy()),
                      SizedBox(width: 40),
                      Expanded(flex: 10, child: _PreviewArea()),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final headingSize = width < 1100 ? 45.0 : 58.0;
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Eyebrow pill badge
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FF),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.primaryBlue.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'AI-POWERED PLATFORM',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 38),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: headingSize,
                height: 1.08,
                fontWeight: FontWeight.w800,
                color: AppColors.black,
              ),
              children: [
                const TextSpan(text: 'AI-Powered Intelligence\nfor '),
                TextSpan(
                  text: 'Smarter Software\nProjects',
                  style: TextStyle(
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [Color(0xFF0664F2), Color(0xFF5E4FE8)],
                      ).createShader(const Rect.fromLTWH(0, 0, 700, 0)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 610),
            child: const Text(
              'DevInsight helps development teams predict risks, prioritize issues, and deliver successful software projects.',
              style: TextStyle(
                color: AppColors.slateText,
                fontSize: 18,
                height: 1.6,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _ActionButton(label: 'Get Started  →', onPressed: () {}),
              _GhostButton(label: 'Sign in', onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewArea extends StatelessWidget {
  const _PreviewArea();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: const AspectRatio(aspectRatio: 1.7, child: DashboardPreview()),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Buttons
// ---------------------------------------------------------------------------

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF0664F2), Color(0xFF4B7FFF)],
      ),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryBlue.withValues(alpha: 0.28),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

class _GhostButton extends StatelessWidget {
  const _GhostButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryBlue,
      side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: Text(
      label,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );
}
