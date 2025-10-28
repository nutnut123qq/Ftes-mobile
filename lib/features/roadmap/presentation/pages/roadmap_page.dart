import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/skills.dart';
import '../viewmodels/roadmap_viewmodel.dart';
import '../widgets/skill_chip.dart';
import '../widgets/gradient_button.dart';
import './roadmap_result_page.dart';
import 'package:ftes/widgets/bottom_navigation_bar.dart';

class RoadmapPage extends StatelessWidget {
  const RoadmapPage({super.key});
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RoadmapViewModel(),
      child: Consumer<RoadmapViewModel>(
        builder: (context, vm, _) {
          final theme = Theme.of(context);

          return Scaffold(
            appBar: AppBar(
              backgroundColor: theme.scaffoldBackgroundColor,
              systemOverlayStyle: theme.appBarTheme.systemOverlayStyle,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                color: theme.iconTheme.color,
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Tạo Lộ Trình Cá Nhân Hóa',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              elevation: 0,
              centerTitle: false,
            ),
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 880),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Thông Tin & Mục Tiêu',
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // --- Progress Bar ---
                        LinearProgressIndicator(
                          value: 0,
                          backgroundColor: theme.colorScheme.surfaceVariant,
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        const SizedBox(height: 20),

                        // --- 2 Dropdown ---
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- Dropdown 1: Học kỳ ---
                            Flexible(
                              flex: 1,
                              child: _SelectCard(
                                label: 'Học kỳ',
                                child: DropdownButtonFormField<Semester>(
                                  initialValue: vm.semester,
                                  isExpanded: true,
                                  items: Semester.values
                                      .map(
                                        (s) => DropdownMenuItem(
                                      value: s,
                                      child: Text('Học kỳ ${s.index + 1}'),
                                    ),
                                  )
                                      .toList(),
                                  onChanged: vm.setSemester,
                                  decoration: _inputDecoration(context, 'Học kỳ'),
                                  validator: (value) {
                                    if (value == null) return 'Vui lòng chọn học kỳ';
                                    return null;
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            Flexible(
                              flex: 1,
                              child: _SelectCard(
                                label: 'Chuyên ngành',
                                child: DropdownButtonFormField<TargetMajor>(
                                  initialValue: vm.target,
                                  isExpanded: true,
                                  items: const [
                                    DropdownMenuItem(value: TargetMajor.javaDeep, child: Text('Java chuyên sâu')),
                                    DropdownMenuItem(value: TargetMajor.feDev, child: Text('FE Dev')),
                                    DropdownMenuItem(value: TargetMajor.beDev, child: Text('BE Dev')),
                                    DropdownMenuItem(value: TargetMajor.fullstackDev, child: Text('Full-stack Dev')),
                                    DropdownMenuItem(value: TargetMajor.mobileDev, child: Text('Mobile Dev')),
                                  ],
                                  onChanged: vm.setTarget,
                                  decoration: _inputDecoration(context, 'Chuyên ngành'),
                                  validator: (value) {
                                    if (value == null) return 'Vui lòng chọn chuyên ngành';
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          vm.selectedCountLabel,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: vm.allSkills
                              .map(
                                (s) => SkillChip(
                              label: s.label,
                              selected: vm.selectedSkillIds.contains(s.id),
                              onTap: () => vm.toggleSkill(s.id),
                            ),
                          )
                              .toList(),
                        ),

                        const SizedBox(height: 24),
                        GradientButton(
                          loading: vm.isBusy,
                          label: 'Tạo Lộ Trình Ngay',
                          onPressed: () {
                            final form = _formKey.currentState!;
                            if (form.validate()) {
                              vm.submit(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const RoadmapResultPage()),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ),
              ),
            ),
            bottomNavigationBar: AppBottomNavigationBar(selectedIndex: 2),
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}

class _SelectCard extends StatelessWidget {
  final String label;
  final Widget child;

  const _SelectCard({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
