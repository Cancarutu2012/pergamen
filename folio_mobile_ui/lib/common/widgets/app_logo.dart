import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:folio/models/settings.dart';
import 'package:folio_mobile_ui/screens/settings/app_icon_data.dart';
import 'package:provider/provider.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.materialYou = false,
    this.size,
  });

  final bool materialYou;
  final double? size;

  @override
  Widget build(BuildContext context) {
    if (materialYou) {
      return SvgPicture.asset(
        'assets/svg/menu_icons/monochrome.svg',
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.primary,
          BlendMode.srcIn,
        ),
      );
    }

    try {
      final settings = Provider.of<SettingsProvider>(context);
      final option = AppIconData.getById(settings.appIcon);
      return AppIconWidget(
        option: option,
        size: size ?? 48.0,
        borderRadius: (size ?? 48.0) * 0.22,
        showShadow: false,
      );
    } catch (_) {
      return Image.asset(
        'assets/icons/ic_rounded.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }
  }
}
