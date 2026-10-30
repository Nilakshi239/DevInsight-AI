import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';

enum AuthMode { signUp, logIn }

class ModernAuthCard extends StatefulWidget {
  final AuthMode initialMode;
  final ValueChanged<AuthMode>? onModeChanged;
  final void Function(
    String firstName,
    String lastName,
    String email,
    String password,
  )? onSignUp;
  final void Function(String email, String password)? onLogIn;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onGoogleAuth;
  final VoidCallback? onFacebookAuth;
  final VoidCallback? onAppleAuth;
  final VoidCallback? onGithubAuth;

  const ModernAuthCard({
    super.key,
    this.initialMode = AuthMode.logIn,
    this.onModeChanged,
    this.onSignUp,
    this.onLogIn,
    this.onForgotPassword,
    this.onGoogleAuth,
    this.onFacebookAuth,
    this.onAppleAuth,
    this.onGithubAuth,
  });

  @override
  State<ModernAuthCard> createState() => _ModernAuthCardState();
}

class _ModernAuthCardState extends State<ModernAuthCard> {
  late AuthMode _currentMode;

  final _signUpFormKey = GlobalKey<FormState>();
  final _logInFormKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _signUpConfirmPasswordController = TextEditingController();

  final _logInEmailController = TextEditingController();
  final _logInPasswordController = TextEditingController();

  bool _obscureSignUpPassword = true;
  bool _obscureSignUpConfirm = true;
  bool _obscureLogInPassword = true;

  bool _isButtonHovered = false;
  bool _isForgotHovered = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.initialMode;
  }

  @override
  void didUpdateWidget(covariant ModernAuthCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialMode != widget.initialMode) {
      _currentMode = widget.initialMode;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _signUpConfirmPasswordController.dispose();
    _logInEmailController.dispose();
    _logInPasswordController.dispose();
    super.dispose();
  }

  void _switchMode(AuthMode mode) {
    if (_currentMode != mode) {
      setState(() => _currentMode = mode);
      widget.onModeChanged?.call(mode);
    }
  }

  Future<void> _handleSignUpSubmit() async {
    if (_signUpFormKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      widget.onSignUp?.call(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _signUpEmailController.text.trim(),
        _signUpPasswordController.text,
      );
      await Future<void>.delayed(const Duration(milliseconds: 600));
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogInSubmit() async {
    if (_logInFormKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      widget.onLogIn?.call(
        _logInEmailController.text.trim(),
        _logInPasswordController.text,
      );
      await Future<void>.delayed(const Duration(milliseconds: 600));
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 960;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1040),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF10131A), // Deep sleek charcoal slate
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: const Color(0xFF1E2738),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 45,
              spreadRadius: 2,
              offset: const Offset(0, 18),
            ),
            BoxShadow(
              color: AppColors.primaryBlue.withValues(alpha: 0.12),
              blurRadius: 36,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Desktop Layout: 2 Columns Side by Side
  // ---------------------------------------------------------------------------
  Widget _buildDesktopLayout() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Column: The Showcase Poster Box with DevInsight Logo & Blue Cubes
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildShowcaseBox(isCompact: false),
            ),
          ),

          // Right Column: Interactive Dark Form with DevInsight signature colors
          Expanded(
            flex: 11,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 32, 44, 36),
              child: _buildFormContent(isCompact: false),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Mobile / Tablet Layout: Stacked
  // ---------------------------------------------------------------------------
  Widget _buildMobileLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Compact Showcase Header
        Padding(
          padding: const EdgeInsets.all(14),
          child: SizedBox(
            height: 240,
            child: _buildShowcaseBox(isCompact: true),
          ),
        ),

        // Form Content
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: _buildFormContent(isCompact: true),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Showcase Box (Left Poster)
  // ---------------------------------------------------------------------------
  Widget _buildShowcaseBox({required bool isCompact}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF222B3D),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Full-bleed background image covering the entire box edge-to-edge
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                layoutBuilder: (currentChild, previousChildren) => Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    ...previousChildren,
                    ?currentChild,
                  ],
                ),
                child: SizedBox.expand(
                  key: ValueKey<AuthMode>(_currentMode),
                  child: Image.asset(
                    _currentMode == AuthMode.signUp
                        ? AppAssets.signupShowcase
                        : AppAssets.authShowcase,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (context, error, stackTrace) => Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF0F1E36),
                            Color(0xFF0A3063),
                            Color(0xFF0664F2),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 2. Subtle translucent gradient overlay to ensure readability without hiding the image
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.55),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.25),
                      Colors.black.withValues(alpha: 0.82),
                    ],
                    stops: const [0.0, 0.25, 0.60, 1.0],
                  ),
                ),
              ),
            ),

            // 4. Content Overlay
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 20 : 28,
                vertical: isCompact ? 18 : 28,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top: DevInsight Logo & Name placed "into the in box"
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        padding: const EdgeInsets.all(5.5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(11),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryBlue
                                  .withValues(alpha: 0.40),
                              blurRadius: 14,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          AppAssets.devInsightLogo,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.auto_awesome,
                            color: AppColors.primaryBlue,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'DevInsight',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),

                  // Bottom: DevInsight Slogan + Subtitle (dashes removed)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Column(
                      key: ValueKey<AuthMode>(_currentMode),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Project Headline
                        Text(
                          _currentMode == AuthMode.signUp
                              ? 'Engineering Intelligence'
                              : 'Software Risk Intelligence',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: isCompact ? 22 : 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.7,
                            height: 1.15,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Project Subtitle
                        Text(
                          _currentMode == AuthMode.signUp
                              ? 'Predict software risks, prioritize critical issues, and elevate engineering decisions with AI.'
                              : 'Empowering engineering teams with predictive risk insights and AI recommendations.',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFFCBD5E1),
                            fontSize: isCompact ? 12.5 : 13.8,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Right Column: Form Header, Inputs, Primary Action, and Social Login
  // ---------------------------------------------------------------------------
  Widget _buildFormContent({required bool isCompact}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Top Segmented Pill Switcher: [ Sign Up ] [ Log In ]
        Center(
          child: _buildSegmentedSwitcher(),
        ),

        const SizedBox(height: 28),

        // 2. Title & Dynamic Header
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: Text(
            _currentMode == AuthMode.signUp
                ? 'Create An Account'
                : 'Welcome Back',
            key: ValueKey(_currentMode),
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // 3. Form Inputs (Sign Up vs Log In)
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          child: _currentMode == AuthMode.signUp
              ? _buildSignUpFields(isCompact: isCompact)
              : _buildLogInFields(isCompact: isCompact),
        ),

        const SizedBox(height: 22),

        // 4. Primary Button with DevInsight signature electric blue glow
        _buildPrimaryButton(),

        const SizedBox(height: 24),

        // 5. Divider with "Or"
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFF222B3B),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                'Or',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF64748B),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFF222B3B),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // 6. Social Auth Buttons: Google, Facebook, Apple
        _buildSocialButtons(),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Segmented Pill Switcher: [ Sign Up ]  [ Log In ]
  // ---------------------------------------------------------------------------
  Widget _buildSegmentedSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF181F2B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF283447),
          width: 1.1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPillTab(
            label: 'Sign Up',
            isActive: _currentMode == AuthMode.signUp,
            onTap: () => _switchMode(AuthMode.signUp),
          ),
          _buildPillTab(
            label: 'Log In',
            isActive: _currentMode == AuthMode.logIn,
            onTap: () => _switchMode(AuthMode.logIn),
          ),
        ],
      ),
    );
  }

  Widget _buildPillTab({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8.5),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryBlue : Colors.transparent,
            gradient: isActive
                ? const LinearGradient(
                    colors: [
                      Color(0xFF0664F2),
                      Color(0xFF0EA5E9),
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.40),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: isActive ? Colors.white : const Color(0xFF8898AA),
              fontSize: 13.5,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Sign Up Form Fields
  // ---------------------------------------------------------------------------
  Widget _buildSignUpFields({required bool isCompact}) {
    return Form(
      key: _signUpFormKey,
      child: Column(
        key: const ValueKey('signUpFields'),
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: First Name & Last Name (Side by side on wide, stacked on compact)
          if (isCompact) ...[
            _buildDarkTextField(
              controller: _firstNameController,
              hintText: 'First Name',
              icon: Icons.person_outline_rounded,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Enter first name'
                  : null,
            ),
            const SizedBox(height: 12),
            _buildDarkTextField(
              controller: _lastNameController,
              hintText: 'Last Name',
              icon: Icons.person_outline_rounded,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter last name' : null,
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: _buildDarkTextField(
                    controller: _firstNameController,
                    hintText: 'First Name',
                    icon: Icons.person_outline_rounded,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Enter first name'
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDarkTextField(
                    controller: _lastNameController,
                    hintText: 'Last Name',
                    icon: Icons.person_outline_rounded,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Enter last name'
                        : null,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 12),

          // Row 2: Email
          _buildDarkTextField(
            controller: _signUpEmailController,
            hintText: 'Enter Your Email',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Enter email address';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),

          const SizedBox(height: 12),

          // Row 3: Password
          _buildDarkTextField(
            controller: _signUpPasswordController,
            hintText: 'Password',
            icon: Icons.lock_outline_rounded,
            obscureText: _obscureSignUpPassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureSignUpPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFF64748B),
                size: 19,
              ),
              onPressed: () => setState(
                () => _obscureSignUpPassword = !_obscureSignUpPassword,
              ),
            ),
            validator: (v) =>
                (v == null || v.length < 6) ? 'Min 6 characters' : null,
          ),

          const SizedBox(height: 12),

          // Row 4: Confirm Password
          _buildDarkTextField(
            controller: _signUpConfirmPasswordController,
            hintText: 'Confirm Password',
            icon: Icons.shield_outlined,
            obscureText: _obscureSignUpConfirm,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureSignUpConfirm
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFF64748B),
                size: 19,
              ),
              onPressed: () => setState(
                () => _obscureSignUpConfirm = !_obscureSignUpConfirm,
              ),
            ),
            validator: (v) => v != _signUpPasswordController.text
                ? 'Passwords do not match'
                : null,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Log In Form Fields
  // ---------------------------------------------------------------------------
  Widget _buildLogInFields({required bool isCompact}) {
    return Form(
      key: _logInFormKey,
      child: Column(
        key: const ValueKey('logInFields'),
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Email
          _buildDarkTextField(
            controller: _logInEmailController,
            hintText: 'Enter Your Email',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Enter email address';
              return null;
            },
          ),

          const SizedBox(height: 14),

          // Row 2: Password
          _buildDarkTextField(
            controller: _logInPasswordController,
            hintText: 'Password',
            icon: Icons.lock_outline_rounded,
            obscureText: _obscureLogInPassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureLogInPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFF64748B),
                size: 19,
              ),
              onPressed: () => setState(
                () => _obscureLogInPassword = !_obscureLogInPassword,
              ),
            ),
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Enter password' : null,
          ),

          const SizedBox(height: 10),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _isForgotHovered = true),
              onExit: (_) => setState(() => _isForgotHovered = false),
              child: GestureDetector(
                onTap: widget.onForgotPassword,
                child: Text(
                  'Forgot Password ?',
                  style: GoogleFonts.plusJakartaSans(
                    color: _isForgotHovered
                        ? const Color(0xFF38BDF8)
                        : AppColors.primaryBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    decoration: _isForgotHovered
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    decorationColor: const Color(0xFF38BDF8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Dark Text Field Widget with DevInsight Signature Focused Glow
  // ---------------------------------------------------------------------------
  Widget _buildDarkTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.plusJakartaSans(
        color: const Color(0xFFF1F5F9),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: AppColors.primaryBlue,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF171E2B),
        hintText: hintText,
        hintStyle: GoogleFonts.plusJakartaSans(
          color: const Color(0xFF6B7B91),
          fontSize: 13.5,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF6B7B91),
          size: 19,
        ),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF263246),
            width: 1.2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF263246),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryBlue,
            width: 1.8,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFEF4444),
            width: 1.2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFEF4444),
            width: 1.8,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Primary Action Button (Sign In / Create Account)
  // ---------------------------------------------------------------------------
  Widget _buildPrimaryButton() {
    final label = _currentMode == AuthMode.signUp
        ? 'Create an Account'
        : 'Sign In';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isButtonHovered = true),
      onExit: (_) => setState(() => _isButtonHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0664F2),
              Color(0xFF0EA5E9),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withValues(
                alpha: _isButtonHovered ? 0.50 : 0.35,
              ),
              blurRadius: _isButtonHovered ? 22 : 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: _isLoading
                ? null
                : (_currentMode == AuthMode.signUp
                    ? _handleSignUpSubmit
                    : _handleLogInSubmit),
            child: Center(
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      label,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Social Auth Buttons (Google, Facebook, Apple) matching Photo 1
  // ---------------------------------------------------------------------------
  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: _DarkSocialButton(
            icon: const _GoogleIcon(size: 19),
            onTap: widget.onGoogleAuth,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _DarkSocialButton(
            icon: const _FacebookIcon(size: 20),
            onTap: widget.onFacebookAuth,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _DarkSocialButton(
            icon: const _AppleIcon(size: 19),
            onTap: widget.onAppleAuth,
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Sleek Dark Social Button Pill
// -----------------------------------------------------------------------------
class _DarkSocialButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback? onTap;

  const _DarkSocialButton({
    required this.icon,
    this.onTap,
  });

  @override
  State<_DarkSocialButton> createState() => _DarkSocialButtonState();
}

class _DarkSocialButtonState extends State<_DarkSocialButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 44,
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color(0xFF222B3B)
                : const Color(0xFF181F2B),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primaryBlue
                  : const Color(0xFF273347),
              width: 1.2,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: widget.icon,
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Vector Icons for Social Providers
// -----------------------------------------------------------------------------

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

    canvas.drawArc(arcRect, -0.65, 1.25, false, bluePaint);
    canvas.drawArc(arcRect, 0.60, 1.55, false, greenPaint);
    canvas.drawArc(arcRect, 2.15, 1.25, false, yellowPaint);
    canvas.drawArc(arcRect, 3.40, 1.75, false, redPaint);

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

class _FacebookIcon extends StatelessWidget {
  final double size;
  const _FacebookIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF1877F2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          'f',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: size * 0.72,
            fontWeight: FontWeight.bold,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}

class _AppleIcon extends StatelessWidget {
  final double size;
  const _AppleIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _AppleLogoPainter(),
    );
  }
}

class _AppleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.scale(scale, scale);

    final path = Path();
    // Leaf
    path.moveTo(15.22, 6.27);
    path.cubicTo(16.03, 5.28, 16.57, 3.89, 16.42, 2.5);
    path.cubicTo(15.23, 2.55, 13.78, 3.3, 12.92, 4.3);
    path.cubicTo(12.18, 5.16, 11.53, 6.57, 11.71, 7.94);
    path.cubicTo(13.04, 8.04, 14.41, 7.25, 15.22, 6.27);
    path.close();

    // Body
    path.moveTo(18.71, 14.04);
    path.cubicTo(18.74, 17.06, 21.36, 18.06, 21.43, 18.1);
    path.cubicTo(21.4, 18.23, 20.98, 19.67, 19.98, 21.13);
    path.cubicTo(19.11, 22.4, 18.21, 23.66, 16.78, 23.69);
    path.cubicTo(15.38, 23.71, 14.93, 22.86, 13.33, 22.86);
    path.cubicTo(11.73, 22.86, 11.23, 23.66, 9.9, 23.71);
    path.cubicTo(8.52, 23.76, 7.48, 22.36, 6.6, 21.09);
    path.cubicTo(4.81, 18.5, 3.44, 13.78, 5.28, 10.59);
    path.cubicTo(6.19, 9.01, 7.82, 8.01, 9.58, 7.98);
    path.cubicTo(10.93, 7.96, 12.21, 8.89, 13.04, 8.89);
    path.cubicTo(13.86, 8.89, 15.39, 7.78, 17.0, 7.95);
    path.cubicTo(17.68, 7.98, 19.57, 8.23, 20.78, 10.0);
    path.cubicTo(20.68, 10.06, 18.69, 11.22, 18.71, 14.04);
    path.close();

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
