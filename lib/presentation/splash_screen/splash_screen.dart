import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';

/// Splash Screen - Branded app launch with authentication initialization
/// Displays app logo with gradient background while preparing spiritual content
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _initializationComplete = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  /// Setup logo animations - gentle scale and fade effect
  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  /// Initialize app services and check authentication
  Future<void> _initializeApp() async {
    try {
      // Simulate initialization tasks
      await Future.wait([
        _checkAuthenticationStatus(),
        _loadUserPreferences(),
        _prepareAudioFiles(),
        _syncOfflineData(),
        Future.delayed(const Duration(seconds: 2)), // Minimum splash duration
      ]);

      if (mounted) {
        setState(() => _initializationComplete = true);
        _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _initializationComplete = true;
        });
      }
    }
  }

  /// Check if user is authenticated
  Future<void> _checkAuthenticationStatus() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Implement actual Google Sign-in check
  }

  /// Load user preferences from storage
  Future<void> _loadUserPreferences() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // TODO: Load preferences from shared_preferences
  }

  /// Prepare audio files for Radha sound
  Future<void> _prepareAudioFiles() async {
    await Future.delayed(const Duration(milliseconds: 400));
    // TODO: Initialize audio player and load Radha sound
  }

  /// Sync offline japa data with server
  Future<void> _syncOfflineData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: Sync offline data if network available
  }

  /// Navigate to appropriate screen based on auth status
  void _navigateToNextScreen() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      // TODO: Check actual authentication status
      final bool isAuthenticated = false; // Replace with actual check

      if (isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/home-screen');
      } else {
        Navigator.pushReplacementNamed(context, '/login-screen');
      }
    });
  }

  /// Retry initialization on error
  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _initializationComplete = false;
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.primaryOrange,
                AppTheme.secondaryOrange,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                _buildAnimatedLogo(theme),
                const SizedBox(height: 24),
                _buildSubtitle(theme),
                const Spacer(flex: 2),
                _buildLoadingIndicator(theme),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build animated app logo with meditation figure
  Widget _buildAnimatedLogo(ThemeData theme) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.cardWhite,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'self_improvement',
                  size: 64,
                  color: AppTheme.primaryOrange,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build Divine Counter subtitle
  Widget _buildSubtitle(ThemeData theme) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Text(
            'Divine Counter',
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppTheme.cardWhite,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        );
      },
    );
  }

  /// Build loading indicator or error retry button
  Widget _buildLoadingIndicator(ThemeData theme) {
    if (_hasError) {
      return Column(
        children: [
          Text(
            'Unable to connect',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.cardWhite.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _retryInitialization,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.cardWhite,
              foregroundColor: AppTheme.primaryOrange,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              'Retry',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppTheme.primaryOrange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: 32,
      height: 32,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          AppTheme.cardWhite.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}
