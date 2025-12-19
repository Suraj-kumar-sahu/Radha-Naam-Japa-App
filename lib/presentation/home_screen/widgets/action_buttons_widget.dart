import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';
import '../../../theme/app_theme.dart';

class ActionButtonsWidget extends StatefulWidget {
  final VoidCallback onStartJapa;
  final VoidCallback onKidsMode;

  const ActionButtonsWidget({
    super.key,
    required this.onStartJapa,
    required this.onKidsMode,
  });

  @override
  State<ActionButtonsWidget> createState() => _ActionButtonsWidgetState();
}

class _ActionButtonsWidgetState extends State<ActionButtonsWidget>
    with TickerProviderStateMixin {
  late AnimationController _firstController;
  late AnimationController _secondController;
  late Animation<double> _firstAnimation;
  late Animation<double> _secondAnimation;

  @override
  void initState() {
    super.initState();

    // First button animation - faster gas flow
    _firstController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _firstAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _firstController, curve: Curves.easeInOut),
    );

    // Second button animation - slightly different timing for variety
    _secondController = AnimationController(
      duration: const Duration(seconds: 2, milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _secondAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _secondController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sacred Naam Japa Experience - Gas-like Floating Animation
        AnimatedBuilder(
          animation: _firstAnimation,
          builder: (context, child) {
            // Calculate light position around the border
            double progress = _firstAnimation.value;
            double containerWidth = 90.w; // Approximate width
            double containerHeight = 25.h; // Approximate height
            double borderRadius = 16;

            // Define lengths of each segment
            double lengthTop = containerWidth - 2 * borderRadius;
            double lengthTopRightCorner = pi * borderRadius / 2;
            double lengthRight = containerHeight - 2 * borderRadius;
            double lengthBottomRightCorner = pi * borderRadius / 2;
            double lengthBottom = containerWidth - 2 * borderRadius;
            double lengthBottomLeftCorner = pi * borderRadius / 2;
            double lengthLeft = containerHeight - 2 * borderRadius;
            double lengthTopLeftCorner = pi * borderRadius / 2;

            double perimeter = lengthTop + lengthTopRightCorner + lengthRight + lengthBottomRightCorner + lengthBottom + lengthBottomLeftCorner + lengthLeft + lengthTopLeftCorner;
            double currentPos = progress * perimeter;

            double left, top;
            if (currentPos < lengthTop) {
              // Top side
              left = borderRadius + currentPos;
              top = 0;
            } else if (currentPos < lengthTop + lengthTopRightCorner) {
              // Top-right corner
              double cornerProgress = (currentPos - lengthTop) / lengthTopRightCorner;
              double angle = -pi / 2 + cornerProgress * (pi / 2);
              left = (containerWidth - borderRadius) + borderRadius * cos(angle);
              top = borderRadius + borderRadius * sin(angle);
            } else if (currentPos < lengthTop + lengthTopRightCorner + lengthRight) {
              // Right side
              double pos = currentPos - (lengthTop + lengthTopRightCorner);
              left = containerWidth - borderRadius;
              top = borderRadius + pos;
            } else if (currentPos < lengthTop + lengthTopRightCorner + lengthRight + lengthBottomRightCorner) {
              // Bottom-right corner
              double cornerProgress = (currentPos - (lengthTop + lengthTopRightCorner + lengthRight)) / lengthBottomRightCorner;
              double angle = 0 + cornerProgress * (pi / 2);
              left = (containerWidth - borderRadius) + borderRadius * cos(angle);
              top = (containerHeight - borderRadius) + borderRadius * sin(angle);
            } else if (currentPos < lengthTop + lengthTopRightCorner + lengthRight + lengthBottomRightCorner + lengthBottom) {
              // Bottom side
              double pos = currentPos - (lengthTop + lengthTopRightCorner + lengthRight + lengthBottomRightCorner);
              left = containerWidth - borderRadius - pos;
              top = containerHeight - borderRadius;
            } else if (currentPos < lengthTop + lengthTopRightCorner + lengthRight + lengthBottomRightCorner + lengthBottom + lengthBottomLeftCorner) {
              // Bottom-left corner
              double cornerProgress = (currentPos - (lengthTop + lengthTopRightCorner + lengthRight + lengthBottomRightCorner + lengthBottom)) / lengthBottomLeftCorner;
              double angle = pi / 2 + cornerProgress * (pi / 2);
              left = borderRadius + borderRadius * cos(angle);
              top = (containerHeight - borderRadius) + borderRadius * sin(angle);
            } else if (currentPos < lengthTop + lengthTopRightCorner + lengthRight + lengthBottomRightCorner + lengthBottom + lengthBottomLeftCorner + lengthLeft) {
              // Left side
              double pos = currentPos - (lengthTop + lengthTopRightCorner + lengthRight + lengthBottomRightCorner + lengthBottom + lengthBottomLeftCorner);
              left = borderRadius;
              top = containerHeight - borderRadius - pos;
            } else {
              // Top-left corner
              double cornerProgress = (currentPos - (lengthTop + lengthTopRightCorner + lengthRight + lengthBottomRightCorner + lengthBottom + lengthBottomLeftCorner + lengthLeft)) / lengthTopLeftCorner;
              double angle = pi + cornerProgress * (pi / 2);
              left = borderRadius + borderRadius * cos(angle);
              top = borderRadius + borderRadius * sin(angle);
            }

            return Container(
              padding: EdgeInsets.all(1.5.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.cosmicBlackMist.withOpacity(0.9), // Dark base
                    AppTheme.purpleMist.withOpacity(0.4 + _firstAnimation.value * 0.1), // App theme purple
                    Color(0xFF6B46C1).withOpacity(0.3 + _firstAnimation.value * 0.1), // Existing purple
                    AppTheme.indigoAura.withOpacity(0.2 + _firstAnimation.value * 0.1), // App theme indigo
                  ],
                  stops: [
                    0.0,
                    0.4 + _firstAnimation.value * 0.2,
                    0.7 + _firstAnimation.value * 0.1,
                    1.0
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.indigoAura.withOpacity(0.4),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.indigoAura.withOpacity(0.15 + _firstAnimation.value * 0.05),
                    blurRadius: 10 + _firstAnimation.value * 5,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                  BoxShadow(
                    color: Color(0xFF6B46C1).withOpacity(0.1 + _firstAnimation.value * 0.05), // Existing purple shadow
                    blurRadius: 16 + _firstAnimation.value * 8,
                    spreadRadius: 1,
                    offset: Offset(0, 4),
                  ),
                  // Divine border light effect
                  BoxShadow(
                    color: AppTheme.indigoAura.withOpacity(0.3 + _firstAnimation.value * 0.2),
                    blurRadius: 4 + _firstAnimation.value * 2,
                    spreadRadius: 0.5 + _firstAnimation.value * 0.5,
                    offset: Offset(0, 0),
                  ),
                  BoxShadow(
                    color: Color(0xFF6B46C1).withOpacity(0.2 + _firstAnimation.value * 0.15),
                    blurRadius: 6 + _firstAnimation.value * 3,
                    spreadRadius: 0.3 + _firstAnimation.value * 0.3,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Lotus Pattern Background
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 25.h,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // Center petal
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 15.w,
                              height: 20.h,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(7.5.w),
                                  topRight: Radius.circular(7.5.w),
                                ),
                              ),
                            ),
                          ),
                          // Left petals
                          Positioned(
                            bottom: 1.h,
                            left: 20.w,
                            child: Transform.rotate(
                              angle: 0.3,
                              child: Container(
                                width: 12.w,
                                height: 18.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6.w),
                                    topRight: Radius.circular(6.w),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 2.h,
                            left: 10.w,
                            child: Transform.rotate(
                              angle: 0.6,
                              child: Container(
                                width: 10.w,
                                height: 16.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.w),
                                    topRight: Radius.circular(5.w),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Right petals
                          Positioned(
                            bottom: 1.h,
                            right: 20.w,
                            child: Transform.rotate(
                              angle: -0.3,
                              child: Container(
                                width: 12.w,
                                height: 18.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6.w),
                                    topRight: Radius.circular(6.w),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 2.h,
                            right: 10.w,
                            child: Transform.rotate(
                              angle: -0.6,
                              child: Container(
                                width: 10.w,
                                height: 16.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.w),
                                    topRight: Radius.circular(5.w),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Main Content
                  Column(
                    children: [
                      // Centered Description
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.8.h),
                        child: Column(
                          children: [
                            Icon(
                              Icons.brightness_7,
                              color: Color(0xFF8B5CF6),
                              size: 5.w,
                            ),
                            SizedBox(height: 0.8.h),
                            Text(
                              'Begin your spiritual journey with Radha Naam Japa',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                                height: 1.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      // Attractive Start Button
                      Transform.scale(
                        scale: 1.0 + (_firstAnimation.value * 0.05),
                        child: GestureDetector(
                          onTap: widget.onStartJapa,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.2.h),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFF8C42).withOpacity(0.9), // Orange
                                  Color(0xFFFFA500).withOpacity(0.8), // Dark orange
                                  Color(0xFFFF6B35).withOpacity(0.95), // Darker orange
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFFF8C42).withOpacity(0.3),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                  offset: Offset(0, 2),
                                ),
                                BoxShadow(
                                  color: Color(0xFFFFA500).withOpacity(0.4),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 4.w,
                                ),
                                SizedBox(width: 1.2.w),
                                Text(
                                  'Start Naam Japa',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 1.5.h),
        // Divine Play for Little Souls - Gas-like Floating Animation
        AnimatedBuilder(
          animation: _secondAnimation,
          builder: (context, child) {
            // Calculate light position around the border
            double progress = _secondAnimation.value;
            double containerWidth = 90.w; // Approximate width
            double containerHeight = 25.h; // Approximate height
            double borderRadius = 16;

            // Define lengths of each segment
            double lengthTop = containerWidth - 2 * borderRadius;
            double lengthTopRightCorner = pi * borderRadius / 2;
            double lengthRight = containerHeight - 2 * borderRadius;
            double lengthBottomRightCorner = pi * borderRadius / 2;
            double lengthBottom = containerWidth - 2 * borderRadius;
            double lengthBottomLeftCorner = pi * borderRadius / 2;
            double lengthLeft = containerHeight - 2 * borderRadius;
            double lengthTopLeftCorner = pi * borderRadius / 2;

            double perimeter = lengthTop + lengthTopRightCorner + lengthRight + lengthBottomRightCorner + lengthBottom + lengthBottomLeftCorner + lengthLeft + lengthTopLeftCorner;
            double currentPos = progress * perimeter;

            double left, top;
            if (currentPos < lengthTop) {
              // Top side
              left = borderRadius + currentPos;
              top = 0;
            } else if (currentPos < lengthTop + lengthTopRightCorner) {
              // Top-right corner
              double cornerProgress = (currentPos - lengthTop) / lengthTopRightCorner;
              double angle = -pi / 2 + cornerProgress * (pi / 2);
              left = (containerWidth - borderRadius) + borderRadius * cos(angle);
              top = borderRadius + borderRadius * sin(angle);
            } else if (currentPos < lengthTop + lengthTopRightCorner + lengthRight) {
              // Right side
              double pos = currentPos - (lengthTop + lengthTopRightCorner);
              left = containerWidth - borderRadius;
              top = borderRadius + pos;
            } else if (currentPos < lengthTop + lengthTopRightCorner + lengthRight + lengthBottomRightCorner) {
              // Bottom-right corner
              double cornerProgress = (currentPos - (lengthTop + lengthTopRightCorner + lengthRight)) / lengthBottomRightCorner;
              double angle = 0 + cornerProgress * (pi / 2);
              left = (containerWidth - borderRadius) + borderRadius * cos(angle);
              top = (containerHeight - borderRadius) + borderRadius * sin(angle);
            } else if (currentPos < lengthTop + lengthTopRightCorner + lengthRight + lengthBottomRightCorner + lengthBottom) {
              // Bottom side
              double pos = currentPos - (lengthTop + lengthTopRightCorner + lengthRight + lengthBottomRightCorner);
              left = containerWidth - borderRadius - pos;
              top = containerHeight - borderRadius;
            } else if (currentPos < lengthTop + lengthTopRightCorner + lengthRight + lengthBottomRightCorner + lengthBottom + lengthBottomLeftCorner) {
              // Bottom-left corner
              double cornerProgress = (currentPos - (lengthTop + lengthTopRightCorner + lengthRight + lengthBottomRightCorner + lengthBottom)) / lengthBottomLeftCorner;
              double angle = pi / 2 + cornerProgress * (pi / 2);
              left = borderRadius + borderRadius * cos(angle);
              top = (containerHeight - borderRadius) + borderRadius * sin(angle);
            } else if (currentPos < lengthTop + lengthTopRightCorner + lengthRight + lengthBottomRightCorner + lengthBottom + lengthBottomLeftCorner + lengthLeft) {
              // Left side
              double pos = currentPos - (lengthTop + lengthTopRightCorner + lengthRight + lengthBottomRightCorner + lengthBottom + lengthBottomLeftCorner);
              left = borderRadius;
              top = containerHeight - borderRadius - pos;
            } else {
              // Top-left corner
              double cornerProgress = (currentPos - (lengthTop + lengthTopRightCorner + lengthRight + lengthBottomRightCorner + lengthBottom + lengthBottomLeftCorner + lengthLeft)) / lengthTopLeftCorner;
              double angle = pi + cornerProgress * (pi / 2);
              left = borderRadius + borderRadius * cos(angle);
              top = borderRadius + borderRadius * sin(angle);
            }

            return Container(
              padding: EdgeInsets.all(1.5.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    AppTheme.cosmicBlackMist.withOpacity(0.9), // Dark base
                    Color(0xFF2D1B69).withOpacity(0.4 + _secondAnimation.value * 0.1), // Existing deep purple
                    AppTheme.purpleMist.withOpacity(0.3 + _secondAnimation.value * 0.1), // App theme purple
                    Color(0xFF6B46C1).withOpacity(0.2 + _secondAnimation.value * 0.1), // Existing soft violet
                    AppTheme.indigoAura.withOpacity(0.15 + _secondAnimation.value * 0.1), // App theme indigo
                  ],
                  stops: [
                    0.0,
                    0.3 + _secondAnimation.value * 0.2,
                    0.6 + _secondAnimation.value * 0.1,
                    0.8 + _secondAnimation.value * 0.1,
                    1.0
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color(0xFF8B5CF6).withOpacity(0.4), // Light violet border
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF8B5CF6).withOpacity(0.15 + _secondAnimation.value * 0.05),
                    blurRadius: 10 + _secondAnimation.value * 5,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                  BoxShadow(
                    color: AppTheme.purpleMist.withOpacity(0.1 + _secondAnimation.value * 0.05), // App theme shadow
                    blurRadius: 16 + _secondAnimation.value * 8,
                    spreadRadius: 1,
                    offset: Offset(0, 4),
                  ),
                  // Divine border light effect
                  BoxShadow(
                    color: Color(0xFF8B5CF6).withOpacity(0.3 + _secondAnimation.value * 0.2),
                    blurRadius: 4 + _secondAnimation.value * 2,
                    spreadRadius: 0.5 + _secondAnimation.value * 0.5,
                    offset: Offset(0, 0),
                  ),
                  BoxShadow(
                    color: Color(0xFF6B46C1).withOpacity(0.2 + _secondAnimation.value * 0.15),
                    blurRadius: 6 + _secondAnimation.value * 3,
                    spreadRadius: 0.3 + _secondAnimation.value * 0.3,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Lotus Pattern Background
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 30.h,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // Center petal
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 18.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(9.w),
                                  topRight: Radius.circular(9.w),
                                ),
                              ),
                            ),
                          ),
                          // Left petals
                          Positioned(
                            bottom: 1.h,
                            left: 15.w,
                            child: Transform.rotate(
                              angle: 0.3,
                              child: Container(
                                width: 15.w,
                                height: 22.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(7.5.w),
                                    topRight: Radius.circular(7.5.w),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 2.h,
                            left: 5.w,
                            child: Transform.rotate(
                              angle: 0.6,
                              child: Container(
                                width: 12.w,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6.w),
                                    topRight: Radius.circular(6.w),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Right petals
                          Positioned(
                            bottom: 1.h,
                            right: 15.w,
                            child: Transform.rotate(
                              angle: -0.3,
                              child: Container(
                                width: 15.w,
                                height: 22.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(7.5.w),
                                    topRight: Radius.circular(7.5.w),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 2.h,
                            right: 5.w,
                            child: Transform.rotate(
                              angle: -0.6,
                              child: Container(
                                width: 12.w,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6.w),
                                    topRight: Radius.circular(6.w),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Main Content
                  Column(
                    children: [
                      // Centered Description
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.8.h),
                        child: Column(
                          children: [
                            Icon(
                              Icons.child_care,
                              color: Color(0xFF8B5CF6), // Light violet
                              size: 5.w,
                            ),
                            SizedBox(height: 0.8.h),
                            Text(
                              'Naam Japa with Game: Kids\' Way to Playful Devotion',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                                height: 1.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      // Attractive Start Button
                      Transform.scale(
                        scale: 1.0 + (_secondAnimation.value * 0.05),
                        child: GestureDetector(
                          onTap: widget.onKidsMode,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFFFF4500).withOpacity(0.9), // Red-orange (more reddish)
                                  Color(0xFFFF4500).withOpacity(0.9), // Red-orange
                                  Color(0xFFFF0000).withOpacity(0.9), // Red (center)
                                  Color(0xFFFF4500).withOpacity(0.9), // Red-orange
                                  Color(0xFFFF4500).withOpacity(0.9), // Red-orange (more reddish)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                // Reduced divine glowy effect layers
                                BoxShadow(
                                  color: Color(0xFFFFD700).withOpacity(0.3), // Golden divine glow (reduced opacity)
                                  blurRadius: 12,
                                  spreadRadius: 1.5,
                                  offset: Offset(0, 0),
                                ),
                                BoxShadow(
                                  color: Color(0xFFFF0000).withOpacity(0.4), // Red base glow (reduced opacity)
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                  offset: Offset(0, 2),
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.2), // White divine aura (reduced opacity)
                                  blurRadius: 15,
                                  spreadRadius: 0.5,
                                  offset: Offset(0, 0),
                                ),
                                BoxShadow(
                                  color: Color(0xFFFFD700).withOpacity(0.15), // Golden outer glow (reduced opacity)
                                  blurRadius: 18,
                                  spreadRadius: 0.3,
                                  offset: Offset(0, 0),
                                ),
                                BoxShadow(
                                  color: Color(0xFFFF0000).withOpacity(0.2), // Red inner shadow (reduced opacity)
                                  blurRadius: 6,
                                  spreadRadius: 0.5,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.games_rounded,
                                  color: Colors.white,
                                  size: 4.w,
                                ),
                                SizedBox(width: 1.2.w),
                                Text(
                                  'Naam Japa with Game',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
