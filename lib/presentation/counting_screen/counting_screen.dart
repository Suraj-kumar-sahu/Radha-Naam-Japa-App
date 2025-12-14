import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../theme/app_theme.dart'; // Import theme
import '../save_confirmation_modal/save_confirmation_modal.dart'; // Import the Modal
import './widgets/animated_radha_text_widget.dart';
import './widgets/circular_progress_widget.dart';
import './widgets/save_japa_button_widget.dart';
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
    setState(() => _currentCount++);
    if (!_isMuted && _isAudioInitialized) {
      try {
        await _audioPlayer.stop();
        await _audioPlayer.resume();
      } catch (e) {}
    }
    HapticFeedback.lightImpact();
    _createRadhaAnimation(details.globalPosition);
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
          ],
        ),
      ),
    );
  }

  Widget _buildSessionHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Column(
        children: [
          Text(
            _sessionDuration,
            style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.ashGray,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _currentCount.toString(),
            style: AppTheme.glowTextStyle.copyWith(fontSize: 48.sp),
          ),
          SizedBox(height: 0.5.h),
          Text(
            '${_currentCount ~/ 108} Malas + ${_currentCount % 108} Japas',
            style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.goldRadiance,
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedRadhaTextData {
  final int id;
  final Offset position;
  AnimatedRadhaTextData({required this.id, required this.position});
}