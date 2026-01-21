# Otzaria Localization Guide

This guide explains how to use the new localization/translation system in Otzaria.

## Overview

The Otzaria app now supports both Hebrew (עברית) and English. Users can switch between languages in the Settings screen.

## Architecture

### Key Files

1. **`lib/localization/app_strings.dart`** - Contains all translatable strings for both Hebrew and English
2. **`lib/localization/localization_provider.dart`** - Manages language state (Singleton provider)
3. **`lib/localization/localization_extension.dart`** - Extension for easy access to translations in BuildContext
4. **`lib/localization/translate.dart`** - Static translation helper (no BuildContext needed)
5. **`lib/settings/settings_state.dart`** - Stores language preference in app state
6. **`lib/settings/settings_repository.dart`** - Persists language choice to storage
7. **`lib/app.dart`** - Applies the selected locale to the Material app

## Adding New Translations

### Step 1: Add to AppStrings

Edit `lib/localization/app_strings.dart` and add your new translation pair:

```dart
// In the constants section
static const String myNewString = 'My New String';

// In the _hebrewStrings map
'myNewString': 'המחרוזת החדשה שלי',

// In the _englishStrings map  
'myNewString': 'My New String',
```

**Important Notes:**
- Keep biblical and technical terms untranslated (e.g., תנך, גמרא, משנה, תלמוד)
- Use camelCase for the constant names
- Always add to BOTH the constant definition AND both language maps

### Step 2: Use in Your Widget

#### Option A: Using BuildContext (Recommended in Widgets)

```dart
import 'package:otzaria/localization/localization_extension.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(context.tr('myNewString'));
  }
}
```

#### Option B: Using Static Helper (No BuildContext)

```dart
import 'package:otzaria/localization/translate.dart';

// Get text for current locale
String text = Translate.t('myNewString', settingsState.language);

// Or directly in Hebrew
String heText = Translate.he('myNewString');

// Or directly in English
String enText = Translate.en('myNewString');
```

#### Option C: Using SettingsBloc State

```dart
BlocBuilder<SettingsBloc, SettingsState>(
  builder: (context, state) {
    final text = state.language == 'en' 
        ? AppStrings._englishStrings['myNewString']
        : AppStrings._hebrewStrings['myNewString'];
    return Text(text ?? 'myNewString');
  },
)
```

## Language Switching

### User Perspective

1. Open Settings (Ctrl+,)
2. Go to the "הגדרות עיצוב" (Design Settings) section
3. Click the "שפה" (Language) dropdown
4. Select either "עברית" (Hebrew) or "English"
5. The app UI updates immediately

### Programmatic Language Switch

```dart
// Switch to English
context.read<SettingsBloc>().add(UpdateLanguage('en'));

// Switch to Hebrew
context.read<SettingsBloc>().add(UpdateLanguage('he'));
```

## RTL/LTR Support

The app automatically handles text direction based on the selected language:
- Hebrew (`he`) = RTL (Right-to-Left)
- English (`en`) = LTR (Left-to-Right)

Flutter's Material Design handles this automatically when you set the locale properly.

## Persisting Language Choice

Language preference is automatically saved to storage via `SettingsRepository`:

1. When user changes language in Settings
2. `UpdateLanguage` event is dispatched to `SettingsBloc`
3. `SettingsRepository.updateLanguage()` saves to persistent storage
4. On app restart, the chosen language is loaded from `SettingsRepository.loadSettings()`

## Checking Current Language

### In Widgets with BuildContext

```dart
bool isHebrew = context.isHebrew;  // true if current language is Hebrew
bool isEnglish = context.isEnglish; // true if current language is English
String currentLocale = context.currentLocale; // 'he' or 'en'
TextDirection dir = context.textDirection; // RTL or LTR
```

### With SettingsBloc

```dart
BlocBuilder<SettingsBloc, SettingsState>(
  builder: (context, state) {
    if (state.language == 'en') {
      // Show English-specific UI
    } else {
      // Show Hebrew-specific UI
    }
    return Container();
  },
)
```

## Translation Guidelines

### DO:
- ✅ Translate all UI labels, buttons, menu items, messages
- ✅ Translate validation messages and error messages
- ✅ Keep biblical terms like תנך, גמרא, משנה, תלמוד untranslated
- ✅ Keep app names and proper nouns in their original form
- ✅ Use professional Hebrew translation terms
- ✅ Test both Hebrew and English after adding translations

### DON'T:
- ❌ Don't hardcode strings in widgets (use translations instead)
- ❌ Don't translate technical terms or abbreviations
- ❌ Don't mix languages within a single string value
- ❌ Don't add translations only to one language

## Common Biblical/Technical Terms (Keep Untranslated)

- תנך (Tanakh/Hebrew Bible)
- גמרא (Gemara)
- משנה (Mishnah)
- תלמוד (Talmud)
- אוצריא (Otzaria - app name)
- תורה (Torah)
- מדרש (Midrash)
- הלכה (Halacha)
- אגדה (Aggadah)
- פירוש (Pirush/Commentary)
- ספרים (Sefarim - Jewish books, but translatable in general context)

## Testing the Localization

### Manual Testing Steps:

1. **Build and run the app**
   ```bash
   flutter run
   ```

2. **Navigate to Settings** (Ctrl+,)

3. **Change language** in the Language dropdown

4. **Verify:**
   - All UI text updates to the new language
   - Text direction changes (Hebrew = RTL, English = LTR)
   - Language choice is persistent across app restarts

5. **Check specific strings** you've added:
   - Make sure they appear in both languages
   - Verify spelling and grammar

### Finding Untranslated Strings

Look for strings that still appear in only one language after switching. They likely need to be added to `app_strings.dart`.

## Future Enhancements

- Add more languages (Spanish, French, Arabic, etc.)
- Implement localization for dates and numbers
- Add pluralization support
- Extract strings to translation management system (like gettext or Crowdin)

## Support

For questions about the localization system, refer to:
- `lib/localization/` - Core localization files
- `lib/settings/settings_bloc.dart` - Language state management
- `lib/app.dart` - Locale application to the Material app
