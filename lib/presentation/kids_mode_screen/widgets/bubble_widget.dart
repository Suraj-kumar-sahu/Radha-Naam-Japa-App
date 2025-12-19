import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class BubbleWidget extends StatelessWidget {
  final BubbleData bubble;
  final VoidCallback onTap;

  const BubbleWidget({
    super.key,
    required this.bubble,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: bubble.xPosition,
      top: bubble.yPosition,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: bubble.size,
          height: bubble.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                bubble.color.withOpacity(0.9),
                bubble.color.withOpacity(0.5),
              ],
              center: Alignment.center,
              radius: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: bubble.color.withOpacity(0.6),
                blurRadius: 15,
                spreadRadius: 3,
              ),
              BoxShadow(
                color: bubble.color.withOpacity(0.4),
                blurRadius: 25,
                spreadRadius: 1,
              ),
            ],
            border: Border.all(
              color: bubble.color.withOpacity(0.8),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              'राधा',
              style: TextStyle(
                color: AppTheme.deepMysticBlack,
                fontSize: bubble.size * 0.25,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSansDevanagari',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BubbleData {
  final int id;
  final double xPosition;
  double yPosition;
  final double size;
  final double speed;
  final Color color;

  BubbleData({
    required this.id,
    required this.xPosition,
    required this.yPosition,
    required this.size,
    required this.speed,
    required this.color,
  });
}
