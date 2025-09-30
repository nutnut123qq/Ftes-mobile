import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../utils/constants.dart';
import '../routes/app_routes.dart';

class MyCourseOngoingVideoScreen extends StatefulWidget {
  final String lessonTitle;
  final String courseTitle;
  final String videoUrl;
  final int currentTime;
  final int totalTime;

  const MyCourseOngoingVideoScreen({
    Key? key,
    required this.lessonTitle,
    required this.courseTitle,
    required this.videoUrl,
    this.currentTime = 0,
    this.totalTime = 0,
  }) : super(key: key);

  @override
  State<MyCourseOngoingVideoScreen> createState() => _MyCourseOngoingVideoScreenState();
}

class _MyCourseOngoingVideoScreenState extends State<MyCourseOngoingVideoScreen> {
  bool _isPlaying = false;
  double _progress = 0.22; // 22% progress (140/630)
  int _currentTime = 274; // 04:34 in seconds
  int _totalTime = 2194; // 36:34 in seconds

  @override
  void initState() {
    super.initState();
    // Ensure valid time values
    _currentTime = widget.currentTime >= 0 ? widget.currentTime : 274;
    _totalTime = widget.totalTime > 0 ? widget.totalTime : 2194;
    // Keep portrait orientation for now
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);
  }

  @override
  void dispose() {
    // Reset to portrait orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Main background
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
            ),
            
            // Left side progress bar
            Positioned(
              left: 20,
              top: 100,
              bottom: 100,
              child: Container(
                width: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Color(0xFFE8F1FF),
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    // Progress fill
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 8,
                        height: MediaQuery.of(context).size.height * 0.22, // 22% of available height
                        decoration: BoxDecoration(
                          color: Color(0xFF167F71), // Teal color
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    // Progress indicator triangle
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.22 - 8,
                      left: -4,
                      child: Container(
                        width: 0,
                        height: 0,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Colors.transparent,
                              width: 8,
                            ),
                            right: BorderSide(
                              color: Colors.transparent,
                              width: 8,
                            ),
                            bottom: BorderSide(
                              color: Colors.white,
                              width: 8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Current time display (rotated 90 degrees clockwise) - moved to right of progress bar
            Positioned(
              left: 35,
              top: 120,
              child: Transform.rotate(
                angle: 1.5708, // +90 degrees in radians (clockwise)
                child: Text(
                  _formatTime(_currentTime),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Jost',
                  ),
                ),
              ),
            ),
            
            // Total time display (rotated 90 degrees clockwise) - moved to right of progress bar
            Positioned(
              left: 35,
              bottom: 120,
              child: Transform.rotate(
                angle: 1.5708, // +90 degrees in radians (clockwise)
                child: Text(
                  _formatTime(_totalTime),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Jost',
                  ),
                ),
              ),
            ),
            
            // Fullscreen icon at bottom left
            Positioned(
              left: 20,
              bottom: 50,
              child: Container(
                width: 24,
                height: 24,
                child: Icon(
                  Icons.fullscreen,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            
            // Three dots menu at bottom right (rotated 90 degrees)
            Positioned(
              right: 20,
              bottom: 50,
              child: Transform.rotate(
                angle: 1.5708, // +90 degrees in radians (clockwise)
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppConstants.routeChatMessages),
                  child: Container(
                    width: 24,
                    height: 24,
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            
            // Top right chevron icon
            Positioned(
              top: 50,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 30,
                  height: 30,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
            
            // Right side course title (vertical text)
            Positioned(
              right: 20,
              top: 100,
              bottom: 100,
              child: Center(
                child: Transform.rotate(
                  angle: 1.5708, // +90 degrees in radians (clockwise)
                  child: Container(
                    width: 200,
                    height: 30,
                    child: Text(
                      widget.courseTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Jost',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            
            
            // Home indicator at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 134,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Color(0xFFE2E6EA),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    // Handle invalid values
    if (seconds < 0) {
      return '00:00';
    }
    
    try {
      int minutes = seconds ~/ 60;
      int remainingSeconds = seconds % 60;
      return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    } catch (e) {
      return '00:00';
    }
  }

}