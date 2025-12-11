import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sizer/sizer.dart';

import '../../services/japa_storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showProfileInLeaderboard = true;
  bool _isLoading = true;

  // User data from Firebase
  String _userName = "";
  String _userEmail = "";
  String _userInitial = "";
  int _totalJaps = 0;
  int _malasCompleted = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Load user data from Firebase Auth and SharedPreferences
  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        _userName = user.displayName ?? "User";
        _userEmail = user.email ?? "";
        _userInitial = _userName.isNotEmpty ? _userName[0].toUpperCase() : "U";
      });
    }

    // Load japa statistics
    final totalJaps = await JapaStorageService.getTotalJaps();
    final malas = await JapaStorageService.getMalasCompleted();
    final showProfile = await JapaStorageService.getShowProfileInLeaderboard();

    setState(() {
      _totalJaps = totalJaps;
      _malasCompleted = malas;
      _showProfileInLeaderboard = showProfile;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F2E8),
        body: Center(
          child: CircularProgressIndicator(
            color: const Color(0xFFFF6B35),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F2E8),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF2C2C2C)),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Profile',
          style: theme.textTheme.titleLarge?.copyWith(
            color: const Color(0xFF2C2C2C),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF5F2E8),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(5.w),
            child: Column(
              children: [
                SizedBox(height: 2.h),

                // Profile Avatar
                Container(
                  width: 25.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB91C5C),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _userInitial,
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // User Name
                Text(
                  _userName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),

                SizedBox(height: 0.5.h),

                // User Email
                Text(
                  _userEmail,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),

                SizedBox(height: 4.h),

                // Statistics Card
                Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(13),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            context,
                            'Total Japs',
                            _totalJaps.toString(),
                          ),
                          Container(
                            width: 1,
                            height: 50,
                            color: Colors.grey[300],
                          ),
                          _buildStatItem(
                            context,
                            'Malas Completed',
                            _malasCompleted.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                // Privacy Section
                Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(13),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Privacy',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2C2C2C),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Show profile picture in leaderboard',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF2C2C2C),
                              ),
                            ),
                          ),
                          Switch(
                            value: _showProfileInLeaderboard,
                            onChanged: (value) async {
                              HapticFeedback.lightImpact();
                              await JapaStorageService
                                  .setShowProfileInLeaderboard(value);
                              setState(() => _showProfileInLeaderboard = value);
                            },
                            activeColor: const Color(0xFFFF6B35),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2C2C2C),
              ),
        ),
      ],
    );
  }
}
