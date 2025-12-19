import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../services/japa_storage_service.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../theme/app_theme.dart';
import './widgets/profile_card_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isVibrationEnabled = true;
  bool _isLoading = true;

  // User data from Firebase Auth
  String _userName = "";
  String _userEmail = "";
  String _userInitial = "";

  // Use the same GoogleSignIn instance as login screen
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: '306534060670-39kiko3rcf8hogq3rfbbne6g666p7ejq.apps.googleusercontent.com',
  );

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Load user data from Firebase Auth
  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        setState(() {
          _userName = user.displayName ?? "User";
          _userEmail = user.email ?? "";
          _userInitial =
              _userName.isNotEmpty ? _userName[0].toUpperCase() : "U";
          _isLoading = false;
        });
      } else {
        // User not logged in - redirect to login
        if (mounted) {
          setState(() => _isLoading = false);
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login-screen',
            (route) => false,
          );
        }
      }
    } catch (e) {
      // Firebase not initialized or error occurred
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.goldRadiance,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Card
                ProfileCardWidget(
                  userName: _userName,
                  userEmail: _userEmail,
                  userInitial: _userInitial,
                  onTap: () => Navigator.pushNamed(context, '/profile-screen'),
                ),

                SizedBox(height: 3.h),

                // Devotional Settings Section
                SettingsSectionWidget(
                  title: 'Devotional Settings',
                  children: [
                    SettingsItemWidget(
                      icon: Icons.vibration,
                      iconColor: AppTheme.goldRadiance,
                      title: 'Vibration',
                      subtitle: 'Haptic feedback on count',
                      trailing: Switch(
                        value: _isVibrationEnabled,
                        onChanged: (value) {
                          HapticFeedback.lightImpact();
                          setState(() => _isVibrationEnabled = value);
                        },
                        activeColor: AppTheme.goldRadiance,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // App Settings Section
                SettingsSectionWidget(
                  title: 'App Settings',
                  children: [
                    SettingsItemWidget(
                      icon: Icons.settings,
                      iconColor: AppTheme.goldRadiance,
                      title: 'App Settings',
                      onTap: () =>
                          Navigator.pushNamed(context, '/app-settings-screen'),
                    ),
                    SettingsItemWidget(
                      icon: Icons.notifications,
                      iconColor: AppTheme.goldRadiance,
                      title: 'Notification',
                      onTap: () =>
                          Navigator.pushNamed(context, '/notification-screen'),
                    ),
                    SettingsItemWidget(
                      icon: Icons.help_outline,
                      iconColor: AppTheme.goldRadiance,
                      title: 'Help & Support',
                      onTap: () => _showHelpSupportModal(),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Community Section
                SettingsSectionWidget(
                  title: 'Community',
                  children: [
                    SettingsItemWidget(
                      icon: Icons.feedback_outlined,
                      iconColor: AppTheme.goldRadiance,
                      title: 'Send Feedback',
                      onTap: () => _showFeedbackModal(),
                    ),
                    SettingsItemWidget(
                      icon: Icons.lightbulb_outline,
                      iconColor: AppTheme.glowGold,
                      title: 'Feature Suggestion',
                      onTap: () =>
                          _showFeedbackModal(isFeatureSuggestion: true),
                    ),
                    SettingsItemWidget(
                      icon: Icons.star,
                      iconColor: AppTheme.glowGold,
                      title: 'Write a Review',
                      onTap: () => _handleWriteReview(),
                    ),
                    SettingsItemWidget(
                      icon: Icons.share,
                      iconColor: AppTheme.goldRadiance,
                      title: 'Share App',
                      onTap: () => _handleShareApp(),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Social & Info Section
                SettingsSectionWidget(
                  title: 'Connect',
                  children: [
                    SettingsItemWidget(
                      icon: Icons.camera_alt,
                      iconColor: AppTheme.indigoAura,
                      title: 'Visit on Instagram',
                      onTap: () => _launchUrl('https://instagram.com'),
                    ),
                    SettingsItemWidget(
                      icon: Icons.language,
                      iconColor: AppTheme.goldRadiance,
                      title: 'Visit on Website',
                      onTap: () => _launchUrl('https://example.com'),
                    ),
                    SettingsItemWidget(
                      icon: Icons.privacy_tip,
                      iconColor: AppTheme.goldRadiance,
                      title: 'Privacy Policy',
                      onTap: () => _launchUrl('https://example.com/privacy'),
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Sign Out Button
                Center(
                  child: TextButton(
                    onPressed: () => _showSignOutDialog(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 1.5.h),
                    ),
                    child: Text(
                      'Sign Out',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFFEF4444),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Version Info
                Center(
                  child: Text(
                    'Version 1.0.14',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar.withNavigation(
        context: context,
        currentIndex: 3,
      ),
    );
  }



  void _showHelpSupportModal() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Help & Support',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C2C2C),
                    ),
              ),
              SizedBox(height: 3.h),
              Text(
                'For quick response email us',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF2C2C2C),
                    ),
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F2E8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'hadost7@gmail.com',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFFFF6B35),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.goldRadiance),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: AppTheme.goldRadiance),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _launchEmail('hadost7@gmail.com');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
                      child: Text(
                        'Send Email',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFeedbackModal({bool isFeatureSuggestion = false}) {
    HapticFeedback.lightImpact();
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final characterCount = feedbackController.text.length;
          final isSubmitEnabled = characterCount > 0;

          return Dialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isFeatureSuggestion
                            ? 'Feature Suggestion'
                            : 'Send Feedback',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2C2C2C),
                            ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: AppTheme.goldRadiance),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: isSubmitEnabled
                                ? () {
                                    Navigator.pop(context);
                                    _submitFeedback(feedbackController.text);
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSubmitEnabled
                                  ? const Color(0xFFFF6B35)
                                  : Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  color: isSubmitEnabled
                                      ? Colors.white
                                      : Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "We'd love to hear your thoughts about the app. Your feedback helps us improve!",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF2C2C2C),
                        ),
                  ),
                  SizedBox(height: 2.h),
                  TextField(
                    controller: feedbackController,
                    maxLines: 6,
                    maxLength: 500,
                    decoration: InputDecoration(
                      hintText: 'Your Feedback',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppTheme.goldRadiance),
                      ),
                      counterText: '',
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                  SizedBox(height: 1.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$characterCount/500',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSignOutDialog() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sign Out',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C2C2C),
                    ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Your total japa will be saved but daily analytics will be deleted.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF2C2C2C),
                    ),
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _handleSignOut();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
                      child: Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    HapticFeedback.lightImpact();
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Support Request',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _submitFeedback(String feedback) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Thank you for your feedback!'),
        backgroundColor: AppTheme.goldRadiance,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleWriteReview() {
    HapticFeedback.lightImpact();
    // Platform-specific app store URLs would go here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening app store...'),
        backgroundColor: AppTheme.goldRadiance,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleShareApp() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share functionality coming soon'),
        backgroundColor: const Color(0xFFFF6B35),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleSignOut() async {
    HapticFeedback.mediumImpact();

    try {
      // Check if user is currently signed in
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        // User is already signed out, just navigate to login
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login-screen',
            (route) => false,
          );
        }
        return;
      }

      // Clear daily analytics (keeps total japa) - this is non-critical
      try {
        await JapaStorageService.clearDailyAnalytics();
      } catch (analyticsError) {
        // Log but don't fail the sign out process
        debugPrint('Failed to clear daily analytics: $analyticsError');
      }

      // Sign out from Google Sign In first
      try {
        await GoogleSignIn().signOut();
      } catch (googleError) {
        // Log Google sign out error but continue with Firebase sign out
        debugPrint('Google sign out error: $googleError');
      }

      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      if (mounted) {
        // Navigate to login screen and clear navigation stack
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint('Sign out error: $e');

      // Try to navigate to login anyway, even if sign out failed
      if (mounted) {
        try {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login-screen',
            (route) => false,
          );
        } catch (navError) {
          // If navigation also fails, show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error signing out. Please restart the app.'),
              backgroundColor: const Color(0xFFEF4444),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }
}
