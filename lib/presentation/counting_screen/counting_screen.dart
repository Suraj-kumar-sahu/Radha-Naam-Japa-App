import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/animated_radha_text_widget.dart';
import './widgets/circular_progress_widget.dart';
import './widgets/save_japa_button_widget.dart';

/// Counting Screen - Immersive full-screen japa counting experience
/// Provides tap-anywhere functionality with real-time audio and visual feedback
class CountingScreen extends StatefulWidget {
  const CountingScreen({super.key});

  @override
  State<CountingScreen> createState() => _CountingScreenState();
}

class _CountingScreenState extends State<CountingScreen>
    with TickerProviderStateMixin {
  // Core counting state
  int _currentCount = 0;
  int _sessionStartTime = 0;
  String _sessionDuration = "00:00:00";
  Timer? _sessionTimer;

  // Audio state
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMuted = false;
  bool _isAudioInitialized = false;

  // Animation state for राधा text
  final List<AnimatedRadhaTextData> _radhaAnimations = [];
  int _animationIdCounter = 0;

  // Controllers
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

  /// Initialize audio player with Radha sound
  Future<void> _initializeAudio() async {
    try {
      // Using a royalty-free spiritual chant sound
      // In production, replace with actual "Radha" audio file
      await _audioPlayer.setSource(AssetSource('sounds/radha_chant.mp3'));
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      setState(() => _isAudioInitialized = true);
    } catch (e) {
      // Silent fail - audio is optional
      debugPrint('Audio initialization failed: $e');
    }
  }

  /// Initialize pulse animation for Save button
  void _initializePulseAnimation() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  /// Start session timer
  void _startSessionTimer() {
    _sessionStartTime = DateTime.now().millisecondsSinceEpoch;
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final elapsed = DateTime.now().millisecondsSinceEpoch - _sessionStartTime;
      final hours = (elapsed ~/ 3600000).toString().padLeft(2, '0');
      final minutes = ((elapsed % 3600000) ~/ 60000).toString().padLeft(2, '0');
      final seconds = ((elapsed % 60000) ~/ 1000).toString().padLeft(2, '0');
      setState(() => _sessionDuration = "$hours:$minutes:$seconds");
    });
  }

  /// Handle tap anywhere on screen
  Future<void> _handleTap(TapDownDetails details) async {
    // Increment count
    setState(() => _currentCount++);

    // Play audio if not muted
    if (!_isMuted && _isAudioInitialized) {
      try {
        await _audioPlayer.stop();
        await _audioPlayer.resume();
      } catch (e) {
        debugPrint('Audio playback error: $e');
      }
    }

    // Trigger haptic feedback
    HapticFeedback.lightImpact();

    // Create animated राधा text at tap location
    _createRadhaAnimation(details.globalPosition);
  }

  /// Create animated राधा text at tap position
  void _createRadhaAnimation(Offset position) {
    final animationId = _animationIdCounter++;
    setState(() {
      _radhaAnimations.add(AnimatedRadhaTextData(
        id: animationId,
        position: position,
      ));
    });

    // Remove animation after completion
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _radhaAnimations.removeWhere((anim) => anim.id == animationId);
        });
      }
    });
  }

  /// Toggle audio mute state
  void _toggleMute() {
    setState(() => _isMuted = !_isMuted);
  }

  /// Show save confirmation modal
  Future<void> _showSaveConfirmation() async {
    final shouldSave = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildSaveConfirmationDialog(),
    );

    if (shouldSave == true && mounted) {
      _saveSession();
    }
  }

  /// Build save confirmation dialog
  Widget _buildSaveConfirmationDialog() {
    final theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'End Japa Session?',
        style: theme.textTheme.titleLarge,
      ),
      content: Text(
        'Are you sure you want to end this session and save your progress?',
        style: theme.textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Cancel',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  /// Save session and return to caller with session data
  void _saveSession() {
    final malas = _currentCount ~/ 108;
    final remainingJapas = _currentCount % 108;

    final sessionData = {
      'totalCount': _currentCount,
      'malas': malas,
      'remainingJapas': remainingJapas,
      'duration': _sessionDuration,
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Return the session data to whoever pushed CountingScreen
    Navigator.pop(context, sessionData);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar.minimal(
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            size: 24,
          ),
          onPressed: () => _showSaveConfirmation(),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: _isMuted ? 'volume_off' : 'volume_up',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              size: 24,
            ),
            onPressed: _toggleMute,
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: GestureDetector(
        onTapDown: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Session info header
                  _buildSessionHeader(theme),

                  // Circular progress indicator
                  Expanded(
                    child: Center(
                      child: CircularProgressWidget(
                        currentCount: _currentCount,
                        onTap: () {}, // Handled by parent GestureDetector
                      ),
                    ),
                  ),

                  // Save button
                  SaveJapaButtonWidget(
                    pulseController: _pulseController,
                    onPressed: _showSaveConfirmation,
                  ),

                  SizedBox(height: 3.h),
                ],
              ),
            ),

            // Animated राधा texts
            ..._radhaAnimations.map((data) => AnimatedRadhaTextWidget(
                  key: ValueKey(data.id),
                  position: data.position,
                )),
          ],
        ),
      ),
    );
  }

  /// Build session info header
  Widget _buildSessionHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Column(
        children: [
          // Session timer
          Text(
            _sessionDuration,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),

          // Current count display
          Text(
            _currentCount.toString(),
            style: theme.textTheme.displayLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
              fontSize: 48.sp,
            ),
          ),
          SizedBox(height: 0.5.h),

          // Mala progress text
          Text(
            '${_currentCount ~/ 108} Malas + ${_currentCount % 108} Japas',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Data class for animated राधा text
class AnimatedRadhaTextData {
  final int id;
  final Offset position;

  AnimatedRadhaTextData({
    required this.id,
    required this.position,
  });
}
