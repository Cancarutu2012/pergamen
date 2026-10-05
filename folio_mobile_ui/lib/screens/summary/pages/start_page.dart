import 'package:folio/api/providers/user_provider.dart';
import 'package:folio/models/settings.dart';
import 'package:folio/theme/colors/colors.dart';
import 'package:folio_mobile_ui/screens/summary/summary_screen.i18n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartBody extends StatelessWidget {
  const StartBody({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = Provider.of<UserProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);

    final nameParts = user.displayName?.split(" ") ?? ["?"];
    final firstName = !settings.presentationMode
        ? (nameParts.length > 1 ? nameParts[1] : nameParts[0])
        : "János";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 110.0,
              height: 110.0,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 48.0,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              'greeting'.i18n.fill([firstName]),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w900,
                color: AppColors.of(context).text,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'title_start'.i18n,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
                color: AppColors.of(context).text.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
