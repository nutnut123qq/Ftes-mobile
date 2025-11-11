import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/text_styles.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/constants/home_constants.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/course_card_widget.dart';

class CourseSearchPage extends StatefulWidget {
  const CourseSearchPage({super.key});

  @override
  State<CourseSearchPage> createState() => _CourseSearchPageState();
}

class _CourseSearchPageState extends State<CourseSearchPage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      final vm = Provider.of<HomeViewModel>(context, listen: false);
      vm.searchCoursesSuggestions(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Tìm khóa học', style: AppTextStyles.heading3.copyWith(color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, vm, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: HomeConstants.searchPlaceholder,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _controller.clear();
                              vm.searchCoursesSuggestions('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              if (vm.isSearching)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: CircularProgressIndicator(),
                ),
              Expanded(
                child: vm.searchSuggestions.isEmpty
                    ? Center(
                        child: Text(
                          _controller.text.isEmpty ? 'Nhập để tìm kiếm khóa học' : HomeConstants.noCoursesAvailable,
                          style: AppTextStyles.body1.copyWith(color: AppColors.textLight),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: vm.searchSuggestions.length,
                        itemBuilder: (context, index) {
                          final course = vm.searchSuggestions[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: CourseCardWidget(course: course, onTap: () {
                              if (course.slugName != null && course.slugName!.isNotEmpty) {
                                Navigator.pushNamed(
                                  context,
                                  AppConstants.routeCourseDetail,
                                  // Route expects either a Course in {'course': ...} or a String slug.
                                  // Pass slug string for consistency with other places.
                                  arguments: course.slugName,
                                );
                              }
                            }),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}


