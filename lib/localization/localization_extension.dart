import 'package:flutter/material.dart';
import 'package:otzaria/localization/app_strings.dart';
import 'package:otzaria/localization/localization_provider.dart';

/// Extension for easy access to localization in BuildContext
extension LocalizationExt on BuildContext {
  /// Get the current LocalizationProvider
  LocalizationProvider get loc =>
      Provider.of<LocalizationProvider>(this, listen: false);

  /// Get current locale
  String get currentLocale => loc.currentLocale;

  /// Check if Hebrew
  bool get isHebrew => loc.isHebrew;

  /// Check if English
  bool get isEnglish => loc.isEnglish;

  /// Get text direction
  TextDirection get textDirection => loc.textDirection;

  /// Get translated string
  String tr(String key) => _translate(key, loc.currentLocale);

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
      return AppStrings._englishStrings[key] ?? key;
    }
    // Default to Hebrew
    return AppStrings._hebrewStrings[key] ?? key;
  }
}

import 'package:provider/provider.dart';
