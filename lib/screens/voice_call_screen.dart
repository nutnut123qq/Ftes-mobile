import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../models/call_item.dart';
import '../models/chat_item.dart';

class VoiceCallScreen extends StatefulWidget {
  final String contactName;
  final String? contactAvatar;
  final CallType? callType;

  const VoiceCallScreen({
    super.key,
    required this.contactName,
    this.contactAvatar,
    this.callType,
  });

  @override
  State<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _timerController;
  late Animation<double> _pulseAnimation;
  
  Duration _callDuration = const Duration(minutes: 4, seconds: 50);
  bool _isCallActive = true;
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  bool _isVideoOn = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startCallTimer();
    _setSystemUI();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  void _startCallTimer() {
    _timerController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _timerController.addListener(() {
      if (_isCallActive) {
        setState(() {
          _callDuration = Duration(
            minutes: _callDuration.inMinutes,
            seconds: _callDuration.inSeconds + 1,
          );
        });
      }
    });

    _timerController.repeat();
  }

  void _setSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timerController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar
            _buildStatusBar(),
            // Back button
            _buildBackButton(),
            // Spacer
            const Spacer(),
            // Contact Avatar
            _buildContactAvatar(),
            const SizedBox(height: 24),
            // Contact Name
            _buildContactName(),
            const SizedBox(height: 8),
            // Call Duration
            _buildCallDuration(),
            const SizedBox(height: 100),
            // Control Buttons
            _buildControlButtons(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 44,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 21),
            child: Text(
              '9:41',
              style: TextStyle(
                fontFamily: 'Jost',
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 17,
                height: 11,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 0.5),
                  borderRadius: BorderRadius.circular(2.67),
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(1.33),
                      ),
                    ),
                    Positioned(
                      right: -2,
                      top: 2,
                      child: Container(
                        width: 1.33,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(0.67),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              const Icon(Icons.wifi, size: 16, color: Colors.black),
              const SizedBox(width: 5),
              const Icon(Icons.signal_cellular_4_bar, size: 16, color: Colors.black),
              const SizedBox(width: 14),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 35, top: 30),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 26,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactAvatar() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.person,
              color: AppColors.primary,
              size: 100,
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactName() {
    return Text(
      widget.contactName,
      style: AppTextStyles.heading2.copyWith(
        color: AppColors.textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildCallDuration() {
    return Text(
      _formatDuration(_callDuration),
      style: AppTextStyles.bodyText.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w700,
        fontSize: 13,
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Mute button
        _buildControlButton(
          icon: _isMuted ? Icons.mic_off : Icons.mic,
          isActive: _isMuted,
          onTap: () {
            setState(() {
              _isMuted = !_isMuted;
            });
          },
        ),
        // End call button
        _buildControlButton(
          icon: Icons.call_end,
          isActive: true,
          backgroundColor: AppColors.error,
          onTap: () {
            _endCall();
          },
        ),
        // Video call button
        _buildControlButton(
          icon: _isVideoOn ? Icons.videocam : Icons.videocam_off,
          isActive: _isVideoOn,
          onTap: () {
            setState(() {
              _isVideoOn = !_isVideoOn;
            });
          },
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    Color? backgroundColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          color: backgroundColor ?? (isActive ? AppColors.primary : Colors.white),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.white : AppColors.textPrimary,
          size: 24,
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds Minutes";
  }

  void _endCall() {
    setState(() {
      _isCallActive = false;
    });
    
    _timerController.stop();
    
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Call with ${widget.contactName} ended'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
