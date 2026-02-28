import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A modern 3D tab bar with gradient and shadow effects
/// Features swipe gesture support and 3D press animation
class TabBar3D extends StatefulWidget {
  /// List of tab labels
  final List<String> tabs;

  /// Currently selected tab index
  final int selectedIndex;

  /// Callback when tab is changed
  final ValueChanged<int> onTabChanged;

  /// Active tab color (default: Color(0xFF0961F5))
  final Color activeColor;

  /// Inactive tab color (default: Color(0xFFF8F9FA))
  final Color inactiveColor;

  /// Active tab text color (default: Colors.white)
  final Color activeTextColor;

  /// Inactive tab text color (default: Color(0xFF666666))
  final Color inactiveTextColor;

  /// Border radius for tabs (default: 12.0)
  final double borderRadius;

  /// Spacing between button and shadow layer (default: 4.0)
  final double shadowOffset;

  /// Tab height (default: 48.0)
  final double height;

  /// Font size for tab text (default: 14.0)
  final double fontSize;

  /// Enable swipe gesture to change tabs (default: true)
  final bool enableSwipe;

  const TabBar3D({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
    this.activeColor = const Color(0xFF0961F5),
    this.inactiveColor = const Color(0xFFF8F9FA),
    this.activeTextColor = Colors.white,
    this.inactiveTextColor = const Color(0xFF666666),
    this.borderRadius = 12.0,
    this.shadowOffset = 4.0,
    this.height = 48.0,
    this.fontSize = 14.0,
    this.enableSwipe = true,
  });

  @override
  State<TabBar3D> createState() => _TabBar3DState();
}

class _TabBar3DState extends State<TabBar3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressAnimationController;
  late Animation<double> _pressAnimation;
  int? _pressedTabIndex;
  double _dragStartX = 0;
  double _dragDeltaX = 0;

  @override
  void initState() {
    super.initState();
    _pressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _pressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pressAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pressAnimationController.dispose();
    super.dispose();
  }

  void _handleTabTap(int index) {
    if (index != widget.selectedIndex) {
      widget.onTabChanged(index);
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapDown(int index, TapDownDetails details) {
    setState(() {
      _pressedTabIndex = index;
    });
    _pressAnimationController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(int index, TapUpDetails details) {
    setState(() {
      _pressedTabIndex = null;
    });
    _pressAnimationController.reverse();
    // Always handle tap, not just when already selected
    _handleTabTap(index);
  }

  void _handleTapCancel(int index) {
    setState(() {
      _pressedTabIndex = null;
    });
    _pressAnimationController.reverse();
  }

  void _handleDragStart(DragStartDetails details) {
    _dragStartX = details.globalPosition.dx;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _dragDeltaX = details.globalPosition.dx - _dragStartX;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!widget.enableSwipe) {
      _dragDeltaX = 0;
      return;
    }

    const swipeThreshold = 50.0;
    final velocity = details.velocity.pixelsPerSecond.dx;

    if (_dragDeltaX.abs() > swipeThreshold || velocity.abs() > 500) {
      if (_dragDeltaX > 0 && widget.selectedIndex > 0) {
        // Swipe right - go to previous tab
        widget.onTabChanged(widget.selectedIndex - 1);
        HapticFeedback.lightImpact();
      } else if (_dragDeltaX < 0 &&
          widget.selectedIndex < widget.tabs.length - 1) {
        // Swipe left - go to next tab
        widget.onTabChanged(widget.selectedIndex + 1);
        HapticFeedback.lightImpact();
      }
    }

    _dragDeltaX = 0;
  }

  Color _getShadowColor(Color color) {
    return Color.fromRGBO(
      (color.red * 0.7).round().clamp(0, 255),
      (color.green * 0.7).round().clamp(0, 255),
      (color.blue * 0.7).round().clamp(0, 255),
      1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: widget.enableSwipe ? _handleDragStart : null,
      onHorizontalDragUpdate: widget.enableSwipe ? _handleDragUpdate : null,
      onHorizontalDragEnd: widget.enableSwipe ? _handleDragEnd : null,
      behavior: HitTestBehavior.translucent, // Allow taps to pass through
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: widget.inactiveColor,
          borderRadius: BorderRadius.circular(widget.borderRadius + 2),
          border: Border.all(color: Colors.black, width: 0.5),
        ),
        child: Row(
          children: widget.tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = widget.selectedIndex == index;
            final isPressed = _pressedTabIndex == index;

            return Expanded(
              child: _buildTabItem(
                tab: tab,
                index: index,
                isSelected: isSelected,
                isPressed: isPressed,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required String tab,
    required int index,
    required bool isSelected,
    required bool isPressed,
  }) {
    final textColor = isSelected
        ? widget.activeTextColor
        : widget.inactiveTextColor;
    final shadowColor = _getShadowColor(widget.activeColor);

    return GestureDetector(
      onTapDown: (details) => _handleTapDown(index, details),
      onTapUp: (details) => _handleTapUp(index, details),
      onTapCancel: () => _handleTapCancel(index),
      child: AnimatedBuilder(
        animation: _pressAnimation,
        builder: (context, child) {
          final pressValue = isPressed ? _pressAnimation.value : 0.0;
          final faceTranslationY = pressValue * widget.shadowOffset;
          final shadowHeight = widget.height * (1 - pressValue);

          return SizedBox(
            height: widget.height + widget.shadowOffset,
            child: Stack(
              children: [
                // Shadow layer (only for selected tab)
                if (isSelected)
                  Positioned(
                    bottom: 0,
                    left: 4,
                    right: 4,
                    child: Container(
                      height: shadowHeight,
                      decoration: BoxDecoration(
                        color: shadowColor,
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius,
                        ),
                      ),
                    ),
                  ),
                // Main tab (top layer)
                Positioned(
                  top: 0,
                  left: 4,
                  right: 4,
                  child: Transform.translate(
                    offset: Offset(0, faceTranslationY),
                    child: Container(
                      height: widget.height,
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [
                                  widget.activeColor,
                                  widget.activeColor.withValues(alpha: 0.85),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              )
                            : null,
                        color: isSelected ? null : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          tab,
                          style: TextStyle(
                            color: textColor,
                            fontSize: widget.fontSize,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
