import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otzaria/localization/app_strings.dart';
import 'package:otzaria/settings/settings_state.dart';
import 'package:otzaria/settings/settings_bloc.dart';

/// Extension for easy access to localization in BuildContext
extension LocalizationExt on BuildContext {
  /// Get the current language from SettingsBloc
  String get _currentLanguage {
    try {
      final settings = read<SettingsBloc>().state;
      return settings.language;
    } catch (_) {
      return 'he'; // Default to Hebrew if bloc not available
    }
  }

  /// Get current locale
  String get currentLocale => _currentLanguage;

  /// Check if Hebrew
  bool get isHebrew => _currentLanguage == 'he';

  /// Check if English
  bool get isEnglish => _currentLanguage == 'en';

  /// Get text direction
  TextDirection get textDirection => isHebrew ? TextDirection.rtl : TextDirection.ltr;

  /// Get translated string
  String tr(String key) => _translate(key, _currentLanguage);

  /// Get translated string with formatting (supports %s, %d, etc.)
  String trFormat(String key, List<dynamic> args) {
    final template = tr(key);
    var result = template;
    for (final arg in args) {
      result = result.replaceFirst('%s', arg.toString(), 0);
    }
    return result;
  }

  /// Translate a string for a specific locale
  static String _translate(String key, String locale) {
    if (locale == 'en') {
      return AppStrings.getEnglish(key);
    }
    // Default to Hebrew
    return AppStrings.getHebrew(key);
  }
}
