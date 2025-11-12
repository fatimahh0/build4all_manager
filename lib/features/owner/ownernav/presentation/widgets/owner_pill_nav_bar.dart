import 'package:flutter/material.dart';

class OwnerPillNavItem {
  final Widget icon;
  final String label;
  const OwnerPillNavItem({required this.icon, required this.label});
}

class OwnerPillNavBar extends StatelessWidget {
  final List<OwnerPillNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const OwnerPillNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: cs.outlineVariant.withOpacity(.35)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: List.generate(items.length, (i) {
            final selected = i == currentIndex;
            final item = items[i];
            return Expanded(
              child: _PillItem(
                label: item.label,
                icon: item.icon,
                selected: selected,
                onTap: () => onTap(i),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _PillItem extends StatelessWidget {
  final String label;
  final Widget icon;
  final bool selected;
  final VoidCallback onTap;

  const _PillItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? cs.primary.withOpacity(.10) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Emoji or Icon, caller decides
            SizedBox(height: 24, width: 24, child: FittedBox(child: icon)),
            const SizedBox(height: 6),
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: tt.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: selected ? cs.primary : cs.onSurface.withOpacity(.65),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
