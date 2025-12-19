import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';
import '../../../theme/app_theme.dart';
import '../../../services/japa_storage_service.dart';

class Flower {
  Offset position;
  Offset velocity;
  final double size;
  final int petalCount;
  final double glowOpacity;
  final int columnIndex; // Track which column this flower belongs to
  bool hasReachedBottom = false;
  double bottomY = 0; // Position when it reaches bottom
  int linePosition = -1; // Position in the line formation (-1 means not in line)
  bool isTransforming = false; // Whether it's part of the text transformation
  double transformationProgress = 0.0; // 0.0 to 1.0 for transformation animation

  Flower({
    required this.position,
    required this.velocity,
    required this.size,
    required this.petalCount,
    required this.glowOpacity,
    required this.columnIndex,
  });
}

class FlowerRainPainter extends CustomPainter {
  final double animationValue;
  static final List<Flower> flowers = [];
  final Random random = Random(42);

  FlowerRainPainter(this.animationValue) {
    // Initialize flowers if not already done
    if (flowers.isEmpty) {
      // Initialize with a default size, will be updated in paint
      _initializeFlowers(const Size(300, 200));
    }
  }

  void _initializeFlowers(Size canvasSize) {
    final flowerCount = 30 + random.nextInt(20); // 30-50 flowers for denser rain
    final columnSpacing = canvasSize.width / 10; // Divide width into 10 columns

    // Create weighted column distribution favoring center columns
    final List<int> columnWeights = [];
    for (int col = 0; col < 10; col++) {
      // Center columns (3,4,5,6) get more weight, edges get less
      final distanceFromCenter = (col - 4.5).abs();
      final weight = (10 - distanceFromCenter * 2).round().clamp(1, 10);
      for (int w = 0; w < weight; w++) {
        columnWeights.add(col);
      }
    }

    for (int i = 0; i < flowerCount; i++) {
      final columnIndex = columnWeights[random.nextInt(columnWeights.length)]; // Weighted random selection
      final baseX = columnIndex * columnSpacing + columnSpacing / 2; // Center of each column
      final xVariation = (random.nextDouble() - 0.5) * columnSpacing * 0.8; // Small variation within column

      flowers.add(Flower(
        position: Offset(
          baseX + xVariation, // Position in specific column with small variation
          random.nextDouble() * canvasSize.height - canvasSize.height * 0.5, // Start above canvas
        ),
        velocity: Offset(
          (random.nextDouble() - 0.5) * 10, // Minimal horizontal drift
          40 + random.nextDouble() * 30, // Downward velocity 40-70
        ),
        size: 6 + random.nextDouble() * 8, // Size 6-14 (bigger for better visibility)
        petalCount: 5 + random.nextInt(4), // 5-8 petals
        glowOpacity: 0.04 + random.nextDouble() * 0.08, // Glow opacity 0.04-0.12 (less glowy)
        columnIndex: columnIndex,
      ));
    }
  }

  void _updateFlowers(Size canvasSize) {
    // Update flower positions for rain effect
    for (final flower in flowers) {
      // Update position based on velocity
      flower.position += flower.velocity * 0.016; // Assuming 60fps

      // Reset flower to top when it goes off bottom
      if (flower.position.dy > canvasSize.height + flower.size) {
        final columnSpacing = canvasSize.width / 10;
        final baseX = flower.columnIndex * columnSpacing + columnSpacing / 2;
        final xVariation = (random.nextDouble() - 0.5) * columnSpacing * 0.8;

        flower.position = Offset(
          baseX + xVariation, // Reset to same column with variation
          -flower.size - random.nextDouble() * 50, // Start above canvas
        );
        // Slightly randomize velocity for variety
        flower.velocity = Offset(
          (random.nextDouble() - 0.5) * 10,
          40 + random.nextDouble() * 30,
        );
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Update physics every frame
    _updateFlowers(size);

    final center = Offset(size.width / 2, size.height / 2);
    final circleRadius = 25.w; // Same as the CircularPercentIndicator radius

    // Draw flowers (no clipping needed since they float inside)
    for (final flower in flowers) {
      var currentX = flower.position.dx;
      var currentY = flower.position.dy;

      // Handle collision with circular progress indicator
      final flowerPos = Offset(currentX, currentY);
      final distanceFromCenter = (flowerPos - center).distance;
      final minDistance = circleRadius + flower.size;

      if (distanceFromCenter < minDistance && distanceFromCenter > 0) {
        // Collision with circle - bounce away
        final collisionNormal = (flowerPos - center) / distanceFromCenter;
        final velocityAlongNormal = flower.velocity.dx * collisionNormal.dx +
                                  flower.velocity.dy * collisionNormal.dy;

        if (velocityAlongNormal < 0) { // Moving towards circle
          const restitution = 0.7;
          final impulse = -(1 + restitution) * velocityAlongNormal;

          flower.velocity += collisionNormal * impulse;

          // Move flower outside circle
          final overlap = minDistance - distanceFromCenter;
          currentX += collisionNormal.dx * overlap;
          currentY += collisionNormal.dy * overlap;
        }
      }

      flower.position = Offset(currentX, currentY);

      final flowerCenter = Offset(currentX, currentY);

      // Draw normal flower
      // Draw glow effect (shadow)
      final glowPaint = Paint()
        ..color = AppTheme.goldRadiance.withOpacity(flower.glowOpacity)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      // Draw flower petals with glow
      for (int j = 0; j < flower.petalCount; j++) {
        final angle = (j * 2 * pi / flower.petalCount) + animationValue * 2;
        final petalOffset = Offset(
          flowerCenter.dx + cos(angle) * flower.size * 0.7,
          flowerCenter.dy + sin(angle) * flower.size * 0.7,
        );

        // Draw glow
        canvas.drawCircle(petalOffset, flower.size * 0.7, glowPaint);

        // Draw main petal
        final petalPaint = Paint()
          ..color = AppTheme.goldRadiance.withOpacity(0.15 + flower.glowOpacity * 2)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(petalOffset, flower.size * 0.5, petalPaint);
      }

      // Draw center with glow
      canvas.drawCircle(flowerCenter, flower.size * 0.5, glowPaint);

      final centerPaint = Paint()
        ..color = AppTheme.goldRadiance.withOpacity(0.25 + flower.glowOpacity * 2)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(flowerCenter, flower.size * 0.35, centerPaint);
    }
  }



  @override
  bool shouldRepaint(FlowerRainPainter oldDelegate) => animationValue != oldDelegate.animationValue;
}

class JapaProgressCardWidget extends StatefulWidget {
  final int todayCount;
  final int dailyGoal;
  final Function(int) onTargetChanged;

  const JapaProgressCardWidget({
    super.key,
    required this.todayCount,
    required this.dailyGoal,
    required this.onTargetChanged,
  });

  @override
  State<JapaProgressCardWidget> createState() => _JapaProgressCardWidgetState();
}

class _JapaProgressCardWidgetState extends State<JapaProgressCardWidget>
    with TickerProviderStateMixin {
  int _totalJaps = 0;
  int _currentMalas = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _loadData();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.1, end: 0.5).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  Future<void> _loadData() async {
    final totalJaps = await JapaStorageService.getTotalJaps();
    final malas = await JapaStorageService.getMalasCompleted();
    setState(() {
      _totalJaps = totalJaps;
      _currentMalas = malas;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _showTargetSettings() {
    final TextEditingController controller = TextEditingController(text: widget.dailyGoal.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cosmicBlackMist,
        title: Text(
          'Set Target Japas',
          style: AppTheme.glowTextStyle,
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter target Japas',
            hintStyle: TextStyle(color: AppTheme.ashGray),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.goldRadiance),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.ashGray),
            ),
          ),
          TextButton(
            onPressed: () {
              final target = int.tryParse(controller.text) ?? widget.dailyGoal;
              widget.onTargetChanged(target);
              Navigator.of(context).pop();
            },
            child: Text(
              'Save',
              style: TextStyle(color: AppTheme.goldRadiance),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (widget.todayCount / widget.dailyGoal).clamp(0.0, 1.0);

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
          decoration: BoxDecoration(
            color: AppTheme.cosmicBlackMist,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.dustGold.withOpacity(0.2 + 0.3 * _glowAnimation.value), width: 2.0),
        boxShadow: [
          ...AppTheme.auraGlow,
          // Thin glowy border effect
          BoxShadow(
            color: AppTheme.goldRadiance.withOpacity(0.6 * _glowAnimation.value),
            blurRadius: 2,
            spreadRadius: 0.5,
          ),
          BoxShadow(
            color: AppTheme.goldRadiance.withOpacity(0.3 * _glowAnimation.value),
            blurRadius: 8,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: AppTheme.goldRadiance.withOpacity(0.1 * _glowAnimation.value),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 25.h,
            child: Stack(
              children: [
                // Flower rain background
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(double.infinity, double.infinity),
                      painter: FlowerRainPainter(_animation.value),
                    );
                  },
                ),
                Center(
                  child: Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      margin: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CircularPercentIndicator(
                        radius: 23.w,
                        lineWidth: 7.0,
                        percent: progress,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${widget.todayCount}',
                              style: AppTheme.glowTextStyle.copyWith(fontSize: 30.sp),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              "${widget.todayCount} / ${widget.dailyGoal} japs",
                              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.ashGray,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        progressColor: AppTheme.goldRadiance,
                        backgroundColor: AppTheme.purpleMist.withOpacity(0.3),
                        circularStrokeCap: CircularStrokeCap.round,
                        animation: true,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -12,
                  right: -12,
                  child: IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: AppTheme.goldRadiance,
                      size: 16.sp,
                    ),
                    onPressed: _showTargetSettings,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
