import 'package:flutter/material.dart';

class NavItem {
  final String title;
  final Widget icon;
  final Widget activeIcon;

  const NavItem(
      {required this.title, required this.icon, required this.activeIcon});
}

class NavbarItem extends StatelessWidget {
  const NavbarItem({
    super.key,
    required this.item,
    required this.active,
    required this.onTap,
    this.itemsCount = 4,
  });

  final NavItem item;
  final bool active;
  final void Function() onTap;
  final int itemsCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final activeColor = colorScheme.onSecondaryContainer;
    final inactiveColor = colorScheme.onSurfaceVariant;

    final double pillWidth =
        itemsCount >= 6 ? 48.0 : (itemsCount >= 5 ? 52.0 : 56.0);
    final double iconSize = itemsCount >= 6 ? 22.0 : 24.0;
    final double fontSize = itemsCount >= 6 ? 10.5 : 11.5;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.fastOutSlowIn,
            width: pillWidth,
            height: 32.0,
            decoration: BoxDecoration(
              color: active
                  ? colorScheme.secondaryContainer
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Center(
              child: IconTheme(
                data: IconThemeData(
                  color: active ? activeColor : inactiveColor,
                  size: iconSize,
                ),
                child: active ? item.activeIcon : item.icon,
              ),
            ),
          ),
          const SizedBox(height: 3.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              curve: Curves.fastOutSlowIn,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: itemsCount >= 6 ? 0.0 : 0.1,
                color: active
                    ? colorScheme.onSurface
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(
                  item.title,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
