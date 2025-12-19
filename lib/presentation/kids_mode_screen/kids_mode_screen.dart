import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../theme/app_theme.dart';
import '../save_confirmation_modal/save_confirmation_modal.dart';
import './widgets/animated_radha_text_widget.dart';
import './widgets/bubble_widget.dart';
import '../../services/japa_storage_service.dart';

class KidsModeScreen extends StatefulWidget {
  const KidsModeScreen({super.key});

  @override
  State<KidsModeScreen> createState() => _KidsModeScreenState();
}

class _KidsModeScreenState extends State<KidsModeScreen>
    with TickerProviderStateMixin {
  int _currentCount = 0;
  int _sessionStartTime = 0;
  String _sessionDuration = "00:00:00";
  Timer? _sessionTimer;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMuted = false;
  bool _isAudioInitialized = false;

  late AnimationController _pulseController;

  final List<AnimatedRadhaTextData> _radhaAnimations = [];
  int _animationIdCounter = 0;

  final List<BubbleData> _bubbles = [];
  int _bubbleIdCounter = 0;
  Timer? _bubbleSpawner;
  final Random _random = Random();

  // Bubble colors
  final List<Color> _bubbleColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.cyan,
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _initializeAudio();
    _startSessionTimer();
    _startBubbleSpawner();
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _bubbleSpawner?.cancel();
    _pulseController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initializeAudio() async {
    try {
      await _audioPlayer.setSource(AssetSource('sounds/radha_chant.mp3'));
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      setState(() => _isAudioInitialized = true);
    } catch (e) {
      debugPrint('Audio initialization failed: $e');
    }
  }

  void _startSessionTimer() {
    _sessionStartTime = DateTime.now().millisecondsSinceEpoch;
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final elapsed = DateTime.now().millisecondsSinceEpoch - _sessionStartTime;
      final hours = (elapsed ~/ 3600000).toString().padLeft(2, '0');
      final minutes = ((elapsed % 3600000) ~/ 60000).toString().padLeft(2, '0');
      final seconds = ((elapsed % 60000) ~/ 1000).toString().padLeft(2, '0');
      if (mounted) setState(() => _sessionDuration = "$hours:$minutes:$seconds");
    });
  }

  void _startBubbleSpawner() {
    _bubbleSpawner = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (mounted) _spawnBubbles();
    });
  }

  void _spawnBubble() {
    final screenWidth = MediaQuery.of(context).size.width;
    final bubbleSize = _random.nextDouble() * 60 + 40; // 40-100 size
    final xPosition = _random.nextDouble() * (screenWidth - bubbleSize);
    final speed = _random.nextDouble() * 2 + 1; // 1-3 speed
    final color = _bubbleColors[_random.nextInt(_bubbleColors.length)];

    final bubble = BubbleData(
      id: _bubbleIdCounter++,
      xPosition: xPosition,
      yPosition: -bubbleSize,
      size: bubbleSize,
      speed: speed,
      color: color,
    );

    setState(() {
      _bubbles.add(bubble);
    });

    // Start falling animation
    _animateBubble(bubble);
  }

  void _spawnBubbles() {
    final bubbleCount = _random.nextInt(2) + 1; // 1-2 bubbles
    for (int i = 0; i < bubbleCount; i++) {
      _spawnBubble();
    }
  }

  void _animateBubble(BubbleData bubble) {
    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        bubble.yPosition += bubble.speed;
      });

      // Remove bubble if it goes off screen
      if (bubble.yPosition > MediaQuery.of(context).size.height) {
        setState(() {
          _bubbles.removeWhere((b) => b.id == bubble.id);
        });
        timer.cancel();
      }
    });
  }

  void _onBubbleTap(BubbleData bubble) {
    setState(() {
      _currentCount++;
      _bubbles.removeWhere((b) => b.id == bubble.id);
    });

    if (!_isMuted && _isAudioInitialized) {
      try {
        _audioPlayer.stop();
        _audioPlayer.resume();
      } catch (e) {}
    }

    HapticFeedback.lightImpact();
    _createRadhaAnimation(Offset(bubble.xPosition + bubble.size / 2, bubble.yPosition + bubble.size / 2));
  }

  void _createRadhaAnimation(Offset position) {
    final animationId = _animationIdCounter++;
    setState(() {
      _radhaAnimations.add(AnimatedRadhaTextData(id: animationId, position: position));
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _radhaAnimations.removeWhere((anim) => anim.id == animationId);
        });
      }
    });
  }

  Future<void> _showSaveConfirmation() async {
    final shouldSave = await SaveConfirmationModal.show(
      context,
      sessionCount: _currentCount,
      onConfirm: () {},
    );

    if (shouldSave == true && mounted) {
      _saveSession();
    } else if (mounted) {
      final sessionData = {
        'totalCount': _currentCount,
        'malas': _currentCount ~/ 108,
        'remainingJapas': _currentCount % 108,
        'duration': _sessionDuration,
        'timestamp': DateTime.now().toIso8601String(),
      };
      Navigator.pop(context, sessionData);
    }
  }

  Future<void> _saveSession() async {
    final malas = _currentCount ~/ 108;
    final remainingJapas = _currentCount % 108;

    await JapaStorageService.saveJapaSession(_currentCount);

    final sessionData = {
      'totalCount': _currentCount,
      'malas': malas,
      'remainingJapas': remainingJapas,
      'duration': _sessionDuration,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (mounted) {
      Navigator.pop(context, sessionData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepMysticBlack,
      appBar: CustomAppBar.minimal(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.ashGray),
          onPressed: () => _showSaveConfirmation(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isMuted ? Icons.volume_off : Icons.volume_up,
              color: AppTheme.ashGray,
            ),
            onPressed: () => setState(() => _isMuted = !_isMuted),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    AppTheme.purpleMist.withOpacity(0.2),
                    AppTheme.deepMysticBlack,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildSessionHeader(),
                Expanded(
                  child: Stack(
                    children: [
                      // Bubbles
                      ..._bubbles.map((bubble) => BubbleWidget(
                        bubble: bubble,
                        onTap: () => _onBubbleTap(bubble),
                      )),
                      // Radha animations
                      ..._radhaAnimations.map((data) => AnimatedRadhaTextWidget(
                        key: ValueKey(data.id),
                        position: data.position,
                      )),
                    ],
                  ),
                ),
                _buildJapaCounter(),
                _buildEndJapaButton(),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.deepMysticBlack.withOpacity(0.8),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: AppTheme.goldRadiance.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          _sessionDuration,
          style: AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.ashGray,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildJapaCounter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 0.5.h),
      child: Column(
        children: [
          Text(
            _currentCount.toString(),
            style: AppTheme.glowTextStyle.copyWith(fontSize: 36.sp),
          ),
          SizedBox(height: 0.2.h),
          Text(
            '${_currentCount ~/ 108} Malas + ${_currentCount % 108} Japas',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.goldRadiance,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndJapaButton() {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + (_pulseController.value * 0.05);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 80.w,
            constraints: const BoxConstraints(maxWidth: 400),
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: ElevatedButton(
              onPressed: _showSaveConfirmation,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: theme.colorScheme.primary.withValues(alpha: 0.4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'save',
                    color: theme.colorScheme.onPrimary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'End Japa',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedRadhaTextData {
  final int id;
  final Offset position;
  AnimatedRadhaTextData({required this.id, required this.position});
}
