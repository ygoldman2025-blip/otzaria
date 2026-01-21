import 'package:flutter/material.dart';
import 'package:otzaria/localization/app_strings.dart';

/// Simple static helper for translations without BuildContext
class Translate {
  // Prevent instantiation
  Translate._();

  /// Translate a string for the given locale
  static String t(String key, String locale) {
    if (locale == 'en') {
      return AppStrings._englishStrings[key] ?? key;
    }
    return AppStrings._hebrewStrings[key] ?? key;
  }

  /// Translate using Hebrew (default)
  static String he(String key) => AppStrings._hebrewStrings[key] ?? key;

  /// Translate using English
  static String en(String key) => AppStrings._englishStrings[key] ?? key;

  /// Get all Hebrew strings
  static Map<String, String> getAllHebrew() =>
      Map.unmodifiable(AppStrings._hebrewStrings);

  /// Get all English strings
  static Map<String, String> getAllEnglish() =>
      Map.unmodifiable(AppStrings._englishStrings);
}
