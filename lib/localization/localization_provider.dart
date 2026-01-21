import 'package:flutter/material.dart';

/// Provides localization support for the app
/// Maintains app locale state and provides access to translations
class LocalizationProvider extends ChangeNotifier {
  String _currentLocale = 'he';

  String get currentLocale => _currentLocale;

  /// Check if current language is Hebrew
  bool get isHebrew => _currentLocale == 'he';

  /// Check if current language is English
  bool get isEnglish => _currentLocale == 'en';

  /// Get text direction based on current locale
  TextDirection get textDirection => isHebrew ? TextDirection.rtl : TextDirection.ltr;

  /// Switch to Hebrew
  void setHebrew() {
    if (_currentLocale != 'he') {
      _currentLocale = 'he';
      notifyListeners();
    }
  }

  /// Switch to English
  void setEnglish() {
    if (_currentLocale != 'en') {
      _currentLocale = 'en';
      notifyListeners();
    }
  }

  /// Toggle between Hebrew and English
  void toggleLanguage() {
    _currentLocale = isHebrew ? 'en' : 'he';
    notifyListeners();
  }

  /// Set locale from string
  void setLocale(String locale) {
    if (locale == 'he' || locale == 'en') {
      _currentLocale = locale;
      notifyListeners();
    }
  }

  /// Initialize from saved locale
  void initializeLocale(String? savedLocale) {
    if (savedLocale == 'en') {
      _currentLocale = 'en';
    } else if (savedLocale == 'he') {
      _currentLocale = 'he';
    }
  }
}
