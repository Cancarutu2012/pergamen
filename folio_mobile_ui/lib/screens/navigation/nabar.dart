import 'package:flutter/material.dart';
import 'package:folio_mobile_ui/screens/navigation/navbar_item.dart';

class Navbar extends StatelessWidget {
  const Navbar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.items,
  });

  final int selectedIndex;
  final void Function(int index) onSelected;
  final List<NavItem> items;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 12.0),
        child: Container(
          height: 72.0,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(36.0),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: isDark ? 0.15 : 0.35),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: List.generate(
              items.length,
              (index) => Expanded(
                child: NavbarItem(
                  item: items[index],
                  active: index == selectedIndex,
                  onTap: () => onSelected(index),
                  itemsCount: items.length,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
