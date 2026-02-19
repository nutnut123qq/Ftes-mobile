import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A modern 3D outline button with neumorphism-style design
/// Features a shadow layer behind the button
/// When pressed, the face layer moves down and shadow shrinks for 3D effect
class OutlineButton3D extends StatefulWidget {
  /// The text to display on the button
  final String text;

  /// Callback function when button is pressed
  final VoidCallback? onPressed;

  /// Border radius for the button (default: 22)
  final double borderRadius;

  /// Border width (default: 2.0)
  final double borderWidth;

  /// Blue color for border and shadow (default: Colors.blue)
  final Color borderColor;

  /// Spacing between button and shadow layer (default: 4.0)
  final double shadowOffset;

  /// Button width (optional, will wrap content if not specified)
  final double? width;

  /// Button height (default: 56.0)
  final double height;

  /// Padding inside the button (default: EdgeInsets.symmetric(horizontal: 32, vertical: 16))
  final EdgeInsetsGeometry? padding;

  /// Font size for the text (default: 16.0)
  final double? fontSize;

  /// Auto-size button width to fit text content (default: false)
  /// When true, button will automatically adjust width to fit text
  /// Note: Height is always independent and uses the height parameter
  final bool autoSize;

  const OutlineButton3D({
    super.key,
    this.text = 'Outline',
    this.onPressed,
    this.borderRadius = 22.0,
    this.borderWidth = 2.0,
    this.borderColor = Colors.blue,
    this.shadowOffset = 4.0,
    this.width,
    this.height = 56.0,
    this.padding,
    this.fontSize,
    this.autoSize = false,
  });

  @override
  State<OutlineButton3D> createState() => _OutlineButton3DState();
}

class _OutlineButton3DState extends State<OutlineButton3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _pressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      _animationController.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed != null) {
      _animationController.reverse();
      widget.onPressed?.call();
    }
  }

  void _handleTapCancel() {
    if (widget.onPressed != null) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: widget.borderColor,
      fontSize: widget.fontSize ?? 16,
      fontWeight: FontWeight.w600, // Semi-bold
      letterSpacing: 0.5,
    );

    final paddingValue =
        widget.padding ??
        const EdgeInsets.symmetric(horizontal: 32, vertical: 16);

    // Calculate text size if autoSize is enabled or width is not specified
    // Note: fontSize and height are independent - fontSize only affects text size
    double? calculatedWidth;

    if (widget.autoSize || widget.width == null) {
      final textPainter = TextPainter(
        text: TextSpan(text: widget.text, style: textStyle),
        textDirection: TextDirection.ltr,
        maxLines: 2,
      );

      // Use a large maxWidth for initial layout if width is not specified
      final maxWidth = widget.width ?? double.infinity;
      if (maxWidth.isFinite && maxWidth > 0) {
        textPainter.layout(
          maxWidth:
              maxWidth - paddingValue.horizontal - (widget.borderWidth * 2),
        );
      } else {
        // If no width constraint, layout with a reasonable max width
        textPainter.layout(
          maxWidth: 300 - paddingValue.horizontal - (widget.borderWidth * 2),
        );
      }

      final textSize = textPainter.size;

      // Auto-calculate width if not specified or autoSize is true
      // Height is always independent and uses the height parameter
      if (widget.width == null || widget.autoSize) {
        calculatedWidth =
            textSize.width + paddingValue.horizontal + (widget.borderWidth * 2);
      }
    }

    final actualWidth = widget.width ?? calculatedWidth;
    // Height is always independent - use the height parameter directly
    final actualHeight = widget.height;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: SizedBox(
        width: actualWidth,
        height: actualHeight + widget.shadowOffset,
        child: Stack(
          children: [
            // Shadow layer (bottom layer) - shrinks when pressed
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _pressAnimation,
                builder: (context, child) {
                  // Calculate shadow height: reduces to 0 when pressed
                  final shadowHeight =
                      actualHeight * (1 - _pressAnimation.value);
                  return Container(
                    height: shadowHeight,
                    decoration: BoxDecoration(
                      color: widget.borderColor,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                  );
                },
              ),
            ),
            // Main button (top layer) - moves down when pressed
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _pressAnimation,
                builder: (context, child) {
                  // Calculate translation: moves down by shadowOffset when pressed
                  final faceTranslationY =
                      _pressAnimation.value * widget.shadowOffset;
                  return Transform.translate(
                    offset: Offset(0, faceTranslationY),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: null, // Handled by GestureDetector
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius,
                        ),
                        child: Container(
                          height: actualHeight,
                          width: actualWidth,
                          padding: paddingValue,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              widget.borderRadius,
                            ),
                            border: Border.all(
                              color: widget.borderColor,
                              width: widget.borderWidth,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.text,
                              style: textStyle,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
