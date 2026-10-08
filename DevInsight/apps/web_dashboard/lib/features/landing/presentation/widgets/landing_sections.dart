import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';

// ---------------------------------------------------------------------------
// Features Section
// ---------------------------------------------------------------------------

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  static const _features = [
    (
      Icons.shield_outlined,
      'Risk Prediction',
      'Uses repository-derived information to identify potentially risky or defect-prone software files and changes.',
    ),
    (
      Icons.low_priority_rounded,
      'Project-Aware Prioritization',
      'Combines technical risk with requirements, severity, business impact, deadlines and delivery context.',
    ),
    (
      Icons.psychology_outlined,
      'Explainable AI',
      'Shows the important factors behind predictions so users can understand why a software risk was identified.',
    ),
    (
      Icons.auto_awesome_outlined,
      'AI Recommendations',
      'Transforms structured ML, project and explainability evidence into clear, grounded recommendations.',
    ),
    (
      Icons.track_changes_outlined,
      'Requirements & Context',
      'Connects software risks with important project requirements and delivery priorities.',
    ),
    (
      Icons.groups_outlined,
      'Workload & Capacity',
      'Supports team-capacity awareness when evaluating how important software risks should be handled.',
    ),
  ];

  static const _iconGradients = [
    [Color(0xFF0664F2), Color(0xFF4B8BFF)],
    [Color(0xFF7C3AED), Color(0xFFAB78FF)],
    [Color(0xFF0891B2), Color(0xFF38BDF8)],
    [Color(0xFF059669), Color(0xFF34D399)],
    [Color(0xFFD97706), Color(0xFFFBBF24)],
    [Color(0xFFDC2626), Color(0xFFF87171)],
  ];

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      background: Colors.transparent,
      child: Column(
        children: [
          const _SectionHeading(
            eyebrow: 'CAPABILITIES',
            title: 'Key Features',
            subtitle:
                'Intelligent tools that transform software development data into actionable project insights.',
          ),
          const SizedBox(height: 56),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1000
                  ? 3
                  : constraints.maxWidth >= 620
                  ? 2
                  : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _features.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  mainAxisExtent: columns == 1 ? 142 : 186,
                ),
                itemBuilder: (context, index) => _RevealCard(
                  delay: index * 60,
                  child: _FeatureCard(
                    icon: _features[index].$1,
                    title: _features[index].$2,
                    description: _features[index].$3,
                    gradientColors:
                        _iconGradients[index % _iconGradients.length],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// How It Works Section
// ---------------------------------------------------------------------------

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  static const _steps = [
    (
      Icons.code_rounded,
      'GitHub Data',
      'Commits, file changes, issues, pull requests, CI/CD results and development activity.',
    ),
    (
      Icons.tune_rounded,
      'Data Processing',
      'Repository information is cleaned, structured and transformed into usable features.',
    ),
    (
      Icons.analytics_outlined,
      'Risk Prediction',
      'Machine-learning models estimate software defect or risk likelihood.',
    ),
    (
      Icons.account_tree_outlined,
      'Project Context',
      'Requirements, severity, deadlines, business importance and workload context are added.',
    ),
    (
      Icons.lightbulb_outline_rounded,
      'Prioritization & XAI',
      'The system determines project-aware priority and explains important prediction factors.',
    ),
    (
      Icons.recommend_rounded,
      'AI Recommendation',
      'A grounded AI layer converts the evidence into understandable actions for users.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      background: Colors.transparent,
      child: Column(
        children: [
          const _SectionHeading(
            eyebrow: 'THE WORKFLOW',
            title: 'How DevInsight Works',
            subtitle:
                'From software-development evidence to project-aware decision support.',
          ),
          const SizedBox(height: 64),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 900;
              return Flex(
                direction: wide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: wide
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  for (var i = 0; i < _steps.length; i++) ...[
                    if (wide)
                      Expanded(
                        child: _WorkflowCard(step: i + 1, data: _steps[i]),
                      )
                    else
                      _WorkflowCard(step: i + 1, data: _steps[i]),
                    if (i < _steps.length - 1)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: wide ? 8 : 0,
                          vertical: wide ? 42 : 10,
                        ),
                        child: Icon(
                          wide
                              ? Icons.arrow_forward_rounded
                              : Icons.arrow_downward_rounded,
                          color: AppColors.primaryBlue,
                          size: 20,
                        ),
                      ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Research Section
// ---------------------------------------------------------------------------

class ResearchSection extends StatelessWidget {
  const ResearchSection({super.key, required this.onLearnMore});

  final VoidCallback onLearnMore;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      background: Colors.transparent,
      child: Column(
        children: [
          const _SectionHeading(
            eyebrow: 'RESEARCH ACCESS',
            title: 'Project Access',
            subtitle:
                'DevInsight is currently being developed and evaluated as an academic research prototype.',
          ),
          const SizedBox(height: 52),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE2EAF8)),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0C0A2563),
                    blurRadius: 40,
                    offset: Offset(0, 16),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const _Badge('RESEARCH PROTOTYPE'),
                  const SizedBox(height: 20),
                  const Text(
                    'DevInsight Research Edition',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0D1B38),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const _BulletList(
                    items: [
                      'GitHub repository analysis',
                      'Risk prediction',
                      'Project-aware prioritization',
                      'Explainable AI',
                      'AI recommendations',
                      'Web dashboard',
                      'Developer-focused mobile interface',
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFED7AA)),
                    ),
                    child: const Text(
                      'Not commercially available yet.',
                      style: TextStyle(
                        color: Color(0xFF92400E),
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _PrimaryOutlinedButton(
                    label: 'Learn About the Research',
                    onPressed: onLearnMore,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// About Section
// ---------------------------------------------------------------------------

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      background: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow('ABOUT DEVINSIGHT'),
              const SizedBox(height: 16),
              const Text(
                'About DevInsight',
                style: TextStyle(
                  color: Color(0xFF0D1B38),
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'DevInsight is an AI-powered software engineering intelligence platform designed to transform repository and project data into more useful software-project decision support.',
                style: TextStyle(
                  color: AppColors.slateText,
                  fontSize: 17,
                  height: 1.65,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'It combines machine-learning risk prediction with project context, explainable AI and grounded recommendations.',
                style: TextStyle(
                  color: AppColors.slateText,
                  fontSize: 17,
                  height: 1.65,
                ),
              ),
            ],
          );
          const details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoPoint(
                label: 'Research Domain',
                value: 'Software Engineering Intelligence',
              ),
              _InfoPoint(
                label: 'Core Idea',
                value: 'Technical Risk → Project Priority',
              ),
              _InfoPoint(
                label: 'Interfaces',
                value: 'Web Dashboard + Developer Mobile App',
              ),
              _InfoPoint(
                label: 'Research Focus',
                value:
                    'Prediction • Prioritization • Explainability • Human Decision Support',
              ),
            ],
          );
          return constraints.maxWidth >= 800
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: copy),
                    const SizedBox(width: 90),
                    const Expanded(child: details),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [copy, const SizedBox(height: 38), details],
                );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CTA Section
// ---------------------------------------------------------------------------

class CtaSection extends StatelessWidget {
  const CtaSection({
    super.key,
    required this.onGetStarted,
    required this.onSignIn,
  });

  final VoidCallback onGetStarted;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // CHANGED: was Color(0xCCFAF8F2) (beige). Now transparent so the
      // new blue/white background shows through.
      color: Colors.transparent,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 88),
            child: Column(
              children: [
                const Text(
                  'Build Smarter Software Decisions\nwith DevInsight',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF0D1B38),
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Explore how repository intelligence, project context and explainable AI\ncan support software project teams.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.slateText,
                    fontSize: 17,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 36),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _CtaButton(
                      label: 'Get Started  →',
                      onPressed: onGetStarted,
                    ),
                    _CtaGhostButton(label: 'Sign in', onPressed: onSignIn),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Footer
// ---------------------------------------------------------------------------

class LandingFooter extends StatelessWidget {
  const LandingFooter({
    super.key,
    required this.onFeatures,
    required this.onHowItWorks,
    required this.onResearch,
    required this.onAbout,
  });

  final VoidCallback onFeatures;
  final VoidCallback onHowItWorks;
  final VoidCallback onResearch;
  final VoidCallback onAbout;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        // CHANGED: was Color(0xD9FAF8F2) (beige). Now soft white.
        color: Color(0xB3FFFFFF),
        border: Border(top: BorderSide(color: Color(0xFFE2EAF5))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 22,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppAssets.devInsightLogo, width: 34, height: 34),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DevInsight',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          color: Color(0xFF0D1B38),
                        ),
                      ),
                      Text(
                        'AI-Powered Software Engineering Intelligence',
                        style: TextStyle(
                          color: AppColors.slateText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Wrap(
                spacing: 4,
                children: [
                  _FooterLink('Features', onFeatures),
                  _FooterLink('How It Works', onHowItWorks),
                  _FooterLink('Research', onResearch),
                  _FooterLink('About', onAbout),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared layout primitives
// ---------------------------------------------------------------------------

class _SectionShell extends StatelessWidget {
  const _SectionShell({
    required this.child,
    this.background = Colors.transparent,
  });

  final Widget child;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: background,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width > 600 ? 32 : 20,
        vertical: MediaQuery.sizeOf(context).width > 600 ? 108 : 72,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: child,
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _Eyebrow(eyebrow),
      const SizedBox(height: 14),
      Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF0D1B38),
          fontSize: 36,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 16),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.slateText,
            fontSize: 17,
            height: 1.55,
          ),
        ),
      ),
    ],
  );
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: AppColors.primaryBlue,
      fontSize: 11,
      fontWeight: FontWeight.w800,
      letterSpacing: 2.0,
    ),
  );
}

class _Badge extends StatelessWidget {
  const _Badge(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: const Color(0xFFEBF2FF),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.25)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.primaryBlue,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Feature card
// ---------------------------------------------------------------------------

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradientColors,
  });

  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    elevation: 0,
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      hoverColor: const Color(0xFFF5F8FF),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE8EFF8)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors.first.withValues(alpha: 0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15.5,
                      color: Color(0xFF0D1B38),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.slateText,
                      height: 1.45,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _RevealCard extends StatelessWidget {
  const _RevealCard({required this.child, required this.delay});

  final Widget child;
  final int delay;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: Duration(milliseconds: 500 + delay),
    curve: Curves.easeOutCubic,
    builder: (context, value, child) => Opacity(
      opacity: value,
      child: Transform.translate(
        offset: Offset(0, 16 * (1 - value)),
        child: child,
      ),
    ),
    child: child,
  );
}

// ---------------------------------------------------------------------------
// Workflow card
// ---------------------------------------------------------------------------

class _WorkflowCard extends StatelessWidget {
  const _WorkflowCard({required this.step, required this.data});

  final int step;
  final (IconData, String, String) data;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 205),
    child: Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0664F2), Color(0xFF4B8BFF)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            '$step',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Icon(data.$1, color: AppColors.primaryBlue, size: 28),
        const SizedBox(height: 10),
        Text(
          data.$2,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: Color(0xFF0D1B38),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.$3,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.slateText,
            fontSize: 12.5,
            height: 1.45,
          ),
        ),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// Bullet list
// ---------------------------------------------------------------------------

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (final item in items)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0664F2), Color(0xFF4B8BFF)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 13,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(
                    color: Color(0xFF3A4F70),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
    ],
  );
}

// ---------------------------------------------------------------------------
// Info point
// ---------------------------------------------------------------------------

class _InfoPoint extends StatelessWidget {
  const _InfoPoint({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          margin: const EdgeInsets.only(top: 1),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0664F2), Color(0xFF4B8BFF)],
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 14),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.slateText,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF0D1B38),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// CTA buttons
// ---------------------------------------------------------------------------

class _CtaButton extends StatelessWidget {
  const _CtaButton({required this.label, required this.onPressed});
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
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

class _CtaGhostButton extends StatelessWidget {
  const _CtaGhostButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryBlue,
      side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: Text(
      label,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );
}

// ---------------------------------------------------------------------------
// Outlined button for research section
// ---------------------------------------------------------------------------

class _PrimaryOutlinedButton extends StatelessWidget {
  const _PrimaryOutlinedButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryBlue,
      side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: Text(
      label,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
    ),
  );
}

// ---------------------------------------------------------------------------
// Footer link
// ---------------------------------------------------------------------------

class _FooterLink extends StatelessWidget {
  const _FooterLink(this.label, this.onTap);

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onTap,
    style: TextButton.styleFrom(foregroundColor: AppColors.slateText),
    child: Text(label),
  );
}
