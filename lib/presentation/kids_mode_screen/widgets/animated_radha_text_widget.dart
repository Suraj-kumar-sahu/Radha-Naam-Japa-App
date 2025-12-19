import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Animated राधा text that appears at bubble pop location and fades out
/// Creates engaging visual feedback for each bubble pop in kids mode
class AnimatedRadhaTextWidget extends StatefulWidget {
  final Offset position;

  const AnimatedRadhaTextWidget({
    super.key,
    required this.position,
  });

  @override
  State<AnimatedRadhaTextWidget> createState() =>
      _AnimatedRadhaTextWidgetState();
}

class _AnimatedRadhaTextWidgetState extends State<AnimatedRadhaTextWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _positionAnimation;

  // Colorful gradient colors for राधा text
  final List<Color> _radhaColors = [
    const Color(0xFFFF6B35), // Primary orange
    const Color(0xFFFF8E53), // Secondary orange
    const Color(0xFFD84315), // Hindi accent
    const Color(0xFFFF5722), // Deep orange
    const Color(0xFFFF9800), // Amber
    const Color(0xFF2196F3), // Blue
    const Color(0xFF4CAF50), // Green
    const Color(0xFF9C27B0), // Purple
    const Color(0xFFFFC107), // Yellow
    const Color(0xFFE91E63), // Pink
    const Color(0xFF00BCD4), // Cyan
    const Color(0xFF8BC34A), // Light Green
    const Color(0xFF3F51B5), // Indigo
    const Color(0xFFFF5722), // Deep Orange
    const Color(0xFF795548), // Brown
    const Color(0xFF607D8B), // Blue Grey
    const Color(0xFF9E9E9E), // Grey
    const Color(0xFFCDDC39), // Lime
    const Color(0xFF673AB7), // Deep Purple
    const Color(0xFF009688), // Teal
  ];

  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = (_radhaColors..shuffle()).first;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -50),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx - 30,
      top: widget.position.dy - 30,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: _positionAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Text(
                  'राधा',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: _selectedColor,
                    shadows: [
                      Shadow(
                        color: _selectedColor.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
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
