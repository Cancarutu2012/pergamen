import 'dart:io';
import 'package:flutter/services.dart';

class AppIconService {
  static const MethodChannel _channel =
      MethodChannel('app.pergamen.students/app_icon');

  static Future<bool> setAppIcon(String iconId) async {
    if (!Platform.isAndroid && !Platform.isIOS) return false;
    try {
      final success = await _channel.invokeMethod<bool>('setAppIcon', {
        'iconName': iconId,
      });
      return success ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<String> getCurrentIcon() async {
    if (!Platform.isAndroid && !Platform.isIOS) return 'default';
    try {
      final iconName = await _channel.invokeMethod<String>('getCurrentIcon');
      return iconName ?? 'default';
    } catch (_) {
      return 'default';
    }
  }
}
