import 'package:dotted_border/dotted_border.dart';
import 'package:folio/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class EmptyCard extends StatefulWidget {
  const EmptyCard({
    super.key,
    required this.text,
  });

  final String text;

  @override
  State<EmptyCard> createState() => _EmptyCardState();
}

class _EmptyCardState extends State<EmptyCard> {
  bool hold = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onLongPressDown: (_) => setState(() => hold = true),
      onLongPressEnd: (_) => setState(() => hold = false),
      onLongPressCancel: () => setState(() => hold = false),
      child: AnimatedScale(
        scale: hold ? 1.018 : 1.0,
        curve: Curves.easeInOutBack,
        duration: const Duration(milliseconds: 300),
        child: Container(
          height: 444,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: const BorderRadius.all(Radius.circular(24)),
          ),
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: const Radius.circular(20),
              color: colorScheme.primary.withValues(alpha: 0.4),
              dashPattern: const [6, 6],
              padding: const EdgeInsets.all(20),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72.0,
                    height: 72.0,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      size: 32.0,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.of(context).text.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
