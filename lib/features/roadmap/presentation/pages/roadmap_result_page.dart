import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/roadmap.dart';
import '../viewmodels/roadmap_result_viewmodel.dart';
import '../widgets/roadmap_timeline.dart';
import 'package:ftes/core/widgets/bottom_navigation_bar.dart';

class RoadmapResultPage extends StatelessWidget {
  final Roadmap roadmap;

  const RoadmapResultPage({
    super.key,
    required this.roadmap,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RoadmapResultViewModel(roadmap: roadmap),
      child: Consumer<RoadmapResultViewModel>(
        builder: (context, vm, _) {
          final theme = Theme.of(context);

          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFF),
            appBar: AppBar(
              backgroundColor: theme.scaffoldBackgroundColor,
              systemOverlayStyle: theme.appBarTheme.systemOverlayStyle,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                color: theme.iconTheme.color,
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Lộ Trình Học Tập Của Bạn',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              elevation: 0,
              centerTitle: false,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Kỹ Năng Hiện Tại',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: vm.currentSkills
                        .map(
                          (skill) => Chip(
                        label: Text(skill),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF7C8AFF)),
                      ),
                    )
                        .toList(),
                  ),
                  const SizedBox(height: 32),

                  // --- Timeline title ---
                  Text(
                    'Hành Trình Học Tập',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Các cột mốc quan trọng để bạn phát triển kỹ năng và sự nghiệp.',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  RoadmapTimeline(skills: vm.skillsRoadMap),

                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      // margin bottom: 10


                      backgroundColor: const Color(0xFF265DFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 10),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.flash_on, color: Colors.white),
                    label: const Text(
                      'Bắt đầu học ngay',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            bottomNavigationBar: AppBottomNavigationBar(selectedIndex: 2),
          );
        },
      ),
    );
  }
}
