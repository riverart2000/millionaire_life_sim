import 'package:flutter/material.dart';

class TemplateMenuItem {
  const TemplateMenuItem({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}

class TemplateTopMenu extends StatelessWidget {
  const TemplateTopMenu({
    super.key,
    required this.items,
    required this.activeItemId,
    required this.onItemSelected,
  });

  final List<TemplateMenuItem> items;
  final String activeItemId;
  final ValueChanged<String> onItemSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 600;
        return Wrap(
          alignment: WrapAlignment.start,
          spacing: isCompact ? 4 : 12,
          runSpacing: isCompact ? 4 : 8,
          children: items.map((item) {
            final isActive = item.id == activeItemId;
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icon,
                    size: isCompact ? 16 : 18,
                  ),
                  SizedBox(width: isCompact ? 4 : 8),
                  Text(item.label),
                ],
              ),
              selected: isActive,
              onSelected: (_) => onItemSelected(item.id),
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: isActive
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurface,
              ),
              showCheckmark: false,
              padding: EdgeInsets.symmetric(
                vertical: isCompact ? 6 : 8,
                horizontal: isCompact ? 8 : 12,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

