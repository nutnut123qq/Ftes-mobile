import 'package:flutter/material.dart';
import 'package:ftes/utils/text_styles.dart';
import 'mentor_card.dart';
import 'mentor_data.dart';

class MentorCarousel extends StatefulWidget {
  const MentorCarousel({super.key});

  @override
  State<MentorCarousel> createState() => _MentorCarouselState();
}

class _MentorCarouselState extends State<MentorCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Đội ngũ FTES Mentors',
            textAlign: TextAlign.center,
            style: AppTextStyles.h3.copyWith(
              color: const Color(0xFF202244),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // --- Carousel ---
        SizedBox(
          height: 230,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index % topMentors.length);
            },
            itemBuilder: (context, index) {
              final mentor = topMentors[index % topMentors.length];
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.25)).clamp(0.85, 1.0);
                  }
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: MentorCard(mentor: mentor),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // --- Indicator ---
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            topMentors.length,
                (i) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == _currentPage
                    ? Colors.blueAccent
                    : Colors.blueAccent.withAlpha(68),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
