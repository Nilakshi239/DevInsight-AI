import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/connectivity_service.dart';
// CHANGED: removed animated_aura_background import, added AppBackground
import '../../../landing/presentation/widgets/app_background.dart';
import '../widgets/splash_loader.dart';

enum _SplashConnectionState { checking, offline }

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  final ConnectivityService _connectivityService = const ConnectivityService();
  _SplashConnectionState _connectionState = _SplashConnectionState.checking;
  bool _checkInProgress = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeController.forward();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    if (_checkInProgress || _hasNavigated) {
      return;
    }

    _checkInProgress = true;
    if (mounted) {
      setState(() {
        _connectionState = _SplashConnectionState.checking;
      });
    }

    final minimumSplash = Future<void>.delayed(
      const Duration(milliseconds: 2500),
    );
    final isOnline = await _connectivityService.hasConnection();
    await minimumSplash;

    if (!mounted) {
      return;
    }

    if (isOnline) {
      _hasNavigated = true;
      Navigator.of(context).pushReplacementNamed('/landing');
    } else {
      setState(() {
        _connectionState = _SplashConnectionState.offline;
      });
      _checkInProgress = false;
    }
  }

  Widget _buildLoadingArea({required bool isCompact}) {
    if (_connectionState == _SplashConnectionState.offline) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Column(
          key: const ValueKey('offline'),
          children: [
            Text(
              'Check your internet connection',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.slateText,
                fontSize: isCompact ? 17 : 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No internet connection detected. Please reconnect and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF7A879D),
                fontSize: 13,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _checkInProgress ? null : _checkConnection,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Column(
        key: const ValueKey('checking'),
        children: [
          SplashLoader(
            size: isCompact ? 68.0 : 78.0,
            strokeWidth: isCompact ? 4.5 : 5,
          ),
          const SizedBox(height: 18),
          Text(
            'Checking connection...',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.slateText,
              fontSize: isCompact ? 17.0 : 20.0,
              fontWeight: FontWeight.w500,
              fontFamily: 'sans-serif',
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 700;
          final logoSize = isCompact ? 92.0 : 120.0;
          final titleSize = isCompact ? 50.0 : 68.0;
          final subtitleSize = isCompact ? 18.0 : 22.0;

          // CHANGED: AppBackground now paints the background and holds the
          // content. The old AnimatedAuraBackground layer was removed.
          return AppBackground(
            child: Center(
              child: FadeTransition(
                opacity: _fadeController,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isCompact ? 420 : 760),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Semantics(
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
                      const SizedBox(height: 18),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Dev',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: titleSize,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'sans-serif',
                                letterSpacing: -1.4,
                                height: 2,
                              ),
                            ),
                            TextSpan(
                              text: 'Insight',
                              style: TextStyle(
                                color: AppColors.primaryBlue,
                                fontSize: titleSize,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'sans-serif',
                                letterSpacing: -1.4,
                                height: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'AI-Powered intelligence for Smarter Software Projects',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.slateText,
                            fontSize: subtitleSize,
                            fontWeight: FontWeight.w500,
                            height: 1.35,
                            fontFamily: 'sans-serif',
                          ),
                        ),
                      ),
                      const SizedBox(height: 54),
                      _buildLoadingArea(isCompact: isCompact),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
