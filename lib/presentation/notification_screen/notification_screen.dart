import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isPushNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F2E8),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Notification',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
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
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Push Notifications Section
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(13),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Push Notifications',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF2C2C2C),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Switch(
                        value: _isPushNotificationsEnabled,
                        onChanged: (value) {
                          HapticFeedback.lightImpact();
                          setState(() => _isPushNotificationsEnabled = value);
                          _handlePushNotificationToggle(value);
                        },
                        activeColor: const Color(0xFFFF6B35),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                // Daily Reminders Section
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(13),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Daily Reminders',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: const Color(0xFF2C2C2C),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              _showAddReminderDialog();
                            },
                            icon: Icon(Icons.add, size: 18.sp),
                            label: Text(
                              'Add',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6B35),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 1.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 3.h),

                      // Empty State
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 60.sp,
                              color: Colors.grey[300],
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'No reminders set',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              "Tap 'Add' to create your first reminder",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 2.h),
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

  void _handlePushNotificationToggle(bool enabled) {
    if (enabled) {
      // Request notification permission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Push notifications enabled'),
          backgroundColor: const Color(0xFFFF6B35),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Push notifications disabled'),
          backgroundColor: Colors.grey[700],
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showAddReminderDialog() {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Reminder',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C2C2C),
                    ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Reminder functionality coming soon!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF2C2C2C),
                    ),
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Close',
                      style: TextStyle(color: Color(0xFFFF6B35)),
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
}
