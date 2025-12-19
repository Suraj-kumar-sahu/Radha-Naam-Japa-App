import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_export.dart';

/// Login Screen for Radha Naam Japa devotional application
/// Implements Google Sign-in with Sacred Warmth design aesthetic
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
  serverClientId: '306534060670-39kiko3rcf8hogq3rfbbne6g666p7ejq.apps.googleusercontent.com', // Paste your actual web client ID here
);

  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 8.h),

                // App Logo with meditation icon
                _buildAppLogo(theme),

                SizedBox(height: 4.h),

                // Welcome text
                _buildWelcomeText(theme),

                SizedBox(height: 2.h),

                // Subtitle
                _buildSubtitle(theme),

                SizedBox(height: 8.h),

                // Google Sign-in button
                _buildGoogleSignInButton(theme),

                SizedBox(height: 2.h),

                // Trust signal text
                _buildTrustSignal(theme),

                // Error message
                if (_errorMessage != null) ...[
                  SizedBox(height: 2.h),
                  _buildErrorMessage(theme),
                ],

                SizedBox(height: 4.h),

                // Background illustration
                _buildBackgroundIllustration(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppLogo(ThemeData theme) {
    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            blurRadius: 16.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'self_improvement',
          color: theme.colorScheme.onPrimary,
          size: 15.w,
        ),
      ),
    );
  }

  Widget _buildWelcomeText(ThemeData theme) {
    return Text(
      'Begin Your Spiritual Journey',
      textAlign: TextAlign.center,
      style: theme.textTheme.headlineSmall?.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildSubtitle(ThemeData theme) {
    return Text(
      'Connect with divine practice through\nRadha Naam Japa',
      textAlign: TextAlign.center,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        height: 1.5,
      ),
    );
  }

  Widget _buildGoogleSignInButton(ThemeData theme) {
    return Container(
      width: 85.w,
      constraints: BoxConstraints(
        maxWidth: 400,
        minHeight: 6.h,
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleGoogleSignIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          elevation: 4.0,
          shadowColor: theme.colorScheme.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                height: 3.h,
                width: 3.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.onPrimary,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomImageWidget(
                    imageUrl:
                        'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                    width: 3.h,
                    height: 3.h,
                    fit: BoxFit.contain,
                    semanticLabel:
                        'Google logo icon with multicolored G letter',
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Sign in with Google',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTrustSignal(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomIconWidget(
          iconName: 'lock',
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          size: 14.sp,
        ),
        SizedBox(width: 1.w),
        Text(
          'Secure sign-in with Google',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(ThemeData theme) {
    return Container(
      width: 85.w,
      constraints: const BoxConstraints(maxWidth: 400),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'error_outline',
            color: theme.colorScheme.error,
            size: 18.sp,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              _errorMessage!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundIllustration() {
    return Opacity(
      opacity: 0.15,
      child: CustomImageWidget(
        imageUrl:
            'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800&q=80',
        width: 80.w,
        height: 25.h,
        fit: BoxFit.contain,
        semanticLabel:
            'Peaceful meditation illustration with lotus flower and spiritual symbols in soft orange tones',
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser != null) {
        // Get authentication details
        final GoogleSignInAuthentication googleAuth = 
            await googleUser.authentication;

        // Create Firebase credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the credential
        await FirebaseAuth.instance.signInWithCredential(credential);
        
        if (mounted) {
          _showSuccessFeedback();
          await Future.delayed(const Duration(milliseconds: 300));
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
      } else {
        // User cancelled sign-in
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = null;
          });
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = _getErrorMessage(error);
        });
      }
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('network')) {
      return 'Please check your internet connection and try again';
    } else if (error.toString().contains('cancelled')) {
      return 'Sign-in was cancelled';
    } else {
      return 'Unable to sign in. Please try again later';
    }
  }

  void _showSuccessFeedback() {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 20.sp,
            ),
            SizedBox(width: 2.w),
            const Text('Successfully signed in'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}