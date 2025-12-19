import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import './widgets/animated_radha_text_widget.dart';
import './widgets/circular_progress_widget.dart';
import './widgets/flower_rain_widget.dart';
import './widgets/save_japa_button_widget.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../theme/app_theme.dart';
import '../save_confirmation_modal/save_confirmation_modal.dart';
import '../../services/japa_storage_service.dart';

class CountingScreen extends StatefulWidget {
  const CountingScreen({super.key});

  @override
  State<CountingScreen> createState() => _CountingScreenState();
}

class _CountingScreenState extends State<CountingScreen>
    with TickerProviderStateMixin {
  int _currentCount = 0;
  int _sessionStartTime = 0;
  String _sessionDuration = "00:00:00";
  Timer? _sessionTimer;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMuted = false;
  bool _isAudioInitialized = false;

  final List<AnimatedRadhaTextData> _radhaAnimations = [];
  final List<FlowerRainData> _flowerRainAnimations = [];
  int _animationIdCounter = 0;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _initializeAudio();
    _startSessionTimer();
    _initializePulseAnimation();
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _audioPlayer.dispose();
    _pulseController.dispose();
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

  void _initializePulseAnimation() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
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

  Future<void> _handleTap(TapDownDetails details) async {
    final previousCount = _currentCount;
    setState(() => _currentCount++);
    if (!_isMuted && _isAudioInitialized) {
      try {
        await _audioPlayer.stop();
        await _audioPlayer.resume();
      } catch (e) {}
    }
    HapticFeedback.lightImpact();
    _createRadhaAnimation(details.globalPosition);

    // Check if a mala is completed
    if (previousCount % 108 != 0 && _currentCount % 108 == 0) {
      _createFlowerRain();
    }
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

  void _createFlowerRain() {
    final animationId = _animationIdCounter++;
    final screenSize = MediaQuery.of(context).size;
    final centerPosition = Offset(screenSize.width / 2, screenSize.height / 2);

    setState(() {
      _flowerRainAnimations.add(FlowerRainData(
        id: animationId,
        centerPosition: centerPosition,
        screenWidth: screenSize.width,
        screenHeight: screenSize.height,
      ));
    });
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _flowerRainAnimations.removeWhere((anim) => anim.id == animationId);
        });
      }
    });
  }

  /// 🌟 UPDATED: Use the SaveConfirmationModal Bottom Sheet
  Future<void> _showSaveConfirmation() async {
    // Use the static .show method from your modal widget
    final shouldSave = await SaveConfirmationModal.show(
      context,
      sessionCount: _currentCount,
      onConfirm: () {
        // The modal handles navigation pop, we handle logic here
      },
    );

    // If modal returns true (confirmed), save and exit
    if (shouldSave == true && mounted) {
      _saveSession();
    } else if (mounted) {
      // Exit without saving, but show summary
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
    // Force dark theme colors for immersive experience
    final theme = AppTheme.darkTheme; 

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
      body: GestureDetector(
        onTapDown: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            // Background Gradient (Subtle)
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
                    child: Center(
                      child: CircularProgressWidget(
                        currentCount: _currentCount,
                        onTap: () {},
                      ),
                    ),
                  ),
                  SaveJapaButtonWidget(
                    pulseController: _pulseController,
                    onPressed: _showSaveConfirmation,
                  ),
                  SizedBox(height: 3.h),
                ],
              ),
            ),
            ..._radhaAnimations.map((data) => AnimatedRadhaTextWidget(
                  key: ValueKey(data.id),
                  position: data.position,
                )),
            ..._flowerRainAnimations.map((data) => FlowerRainWidget(
                  key: ValueKey(data.id),
                  centerPosition: data.centerPosition,
                  screenWidth: data.screenWidth,
                  screenHeight: data.screenHeight,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          decoration: BoxDecoration(
            color: AppTheme.deepMysticBlack.withOpacity(0.8),
            borderRadius: BorderRadius.circular(25.sp),
            border: Border.all(
              color: AppTheme.goldRadiance.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.goldRadiance.withOpacity(0.1),
                blurRadius: 10.sp,
                spreadRadius: 1.sp,
              ),
            ],
          ),
          child: Text(
            _sessionDuration,
            style: AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.ashGray,
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedRadhaTextData {
  final int id;
  final Offset position;
  AnimatedRadhaTextData({required this.id, required this.position});
}

class FlowerRainData {
  final int id;
  final Offset centerPosition;
  final double screenWidth;
  final double screenHeight;
  FlowerRainData({
    required this.id,
    required this.centerPosition,
    required this.screenWidth,
    required this.screenHeight,
  });
}
