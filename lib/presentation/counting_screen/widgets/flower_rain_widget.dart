import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';

import '../../../theme/app_theme.dart';

class FlowerRainWidget extends StatefulWidget {
  final Offset centerPosition;
  final double screenWidth;
  final double screenHeight;

  const FlowerRainWidget({
    super.key,
    required this.centerPosition,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  State<FlowerRainWidget> createState() => _FlowerRainWidgetState();
}

class _FlowerRainWidgetState extends State<FlowerRainWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<String> _flowerEmojis = ['💐', '🌸', '💮', '🪷', '🌹', '🌷', '🌼', '🌻', '🌺'];
  final List<FlowerParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Create multiple flower particles
    for (int i = 0; i < 20; i++) {
      _particles.add(FlowerParticle(
        emoji: _flowerEmojis[_random.nextInt(_flowerEmojis.length)],
        angle: _random.nextDouble() * 2 * pi,
        speed: 0.5 + _random.nextDouble() * 1.5,
        size: 20 + _random.nextDouble() * 20,
        delay: 0.0, // All flowers start at once
      ));
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: _particles.map((particle) {
            final progress = (_animation.value - particle.delay).clamp(0.0, 1.0);
            final distance = progress * 400; // Maximum distance from center

            final x = widget.centerPosition.dx + cos(particle.angle) * distance * particle.speed;
            final y = widget.centerPosition.dy + sin(particle.angle) * distance * particle.speed;

            // Add some randomness to the movement
            final randomOffset = Offset(
              sin(progress * 10 + particle.angle) * 20,
              cos(progress * 10 + particle.angle) * 20,
            );

            final opacity = (1.0 - progress).clamp(0.0, 1.0);
            final scale = 0.5 + progress * 0.5;

            return Positioned(
              left: x + randomOffset.dx - particle.size / 2,
              top: y + randomOffset.dy - particle.size / 2,
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Text(
                    particle.emoji,
                    style: TextStyle(
                      fontSize: particle.size.sp,
                      shadows: [
                        Shadow(
                          color: Colors.white.withOpacity(0.8),
                          blurRadius: 4,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class FlowerParticle {
  final String emoji;
  final double angle;
  final double speed;
  final double size;
  final double delay;

  FlowerParticle({
    required this.emoji,
    required this.angle,
    required this.speed,
    required this.size,
    required this.delay,
  });
}
