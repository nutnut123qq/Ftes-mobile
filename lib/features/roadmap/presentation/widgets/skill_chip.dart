import 'package:flutter/material.dart';

class SkillChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SkillChip({super.key, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilterChip(
      selected: selected,
      label: Text(label),
      onSelected: (_) => onTap(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      labelStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: selected ? Colors.white : theme.colorScheme.onSurface,
      ),
      side: BorderSide(
        color: selected ? Colors.transparent : theme.dividerColor,
      ),
      selectedColor: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surfaceContainerHighest.withAlpha(135),
      showCheckmark: false,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}
