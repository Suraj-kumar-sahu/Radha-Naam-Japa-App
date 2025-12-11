import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool _isLightTheme = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          'App Settings',
          style: theme.textTheme.titleLarge?.copyWith(
            color: const Color(0xFF2C2C2C),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF5F2E8),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            children: [
              // Theme Setting
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(13),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B35).withAlpha(26),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.light_mode,
                            color: const Color(0xFFFF6B35),
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Light Theme',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2C2C2C),
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _isLightTheme,
                      onChanged: (value) {
                        HapticFeedback.lightImpact();
                        setState(() => _isLightTheme = value);
                      },
                      activeColor: const Color(0xFFFF6B35),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              // Language Setting
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(13),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _showLanguageSelection();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B35).withAlpha(26),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.language,
                              color: const Color(0xFFFF6B35),
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Language',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF2C2C2C),
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                _selectedLanguage,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Select Language',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C2C2C),
                    ),
              ),
              SizedBox(height: 2.h),
              ListTile(
                title: Text('English'),
                trailing: _selectedLanguage == 'English'
                    ? Icon(Icons.check, color: Color(0xFFFF6B35))
                    : null,
                onTap: () {
                  setState(() => _selectedLanguage = 'English');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Hindi (Coming Soon)'),
                enabled: false,
                textColor: Colors.grey,
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }
}
