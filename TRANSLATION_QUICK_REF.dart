// Quick Reference: Using Translations in Otzaria

// ============================================
// 1. ADD NEW TRANSLATION TO app_strings.dart
// ============================================
class AppStrings {
  static const String myNewString = 'My New String';
  
  static const Map<String, String> _hebrewStrings = {
    'myNewString': 'המחרוזת החדשה שלי',
  };
  
  static const Map<String, String> _englishStrings = {
    'myNewString': 'My New String',
  };
}

// ============================================
// 2. USE IN WIDGETS (3 METHODS)
// ============================================

// METHOD A: Using extension (RECOMMENDED in widgets with BuildContext)
import 'package:otzaria/localization/localization_extension.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(context.tr('myNewString'));
  }
}

// METHOD B: Using static Translate helper (no BuildContext needed)
import 'package:otzaria/localization/translate.dart';

Widget myWidget = Text(
  Translate.t('myNewString', currentLocale),  // Dynamic locale
  // Or: Translate.he('myNewString'),  // Hebrew only
  // Or: Translate.en('myNewString'),  // English only
);

// METHOD C: Using SettingsBloc (when you need other state)
BlocBuilder<SettingsBloc, SettingsState>(
  builder: (context, state) {
    final text = state.language == 'en'
        ? AppStrings._englishStrings['myNewString']
        : AppStrings._hebrewStrings['myNewString'];
    return Text(text ?? 'myNewString');
  },
)

// ============================================
// 3. PROGRAMMATIC LANGUAGE SWITCHING
// ============================================
context.read<SettingsBloc>().add(UpdateLanguage('en'));   // Switch to English
context.read<SettingsBloc>().add(UpdateLanguage('he'));   // Switch to Hebrew

// ============================================
// 4. CHECK CURRENT LANGUAGE (with BuildContext)
// ============================================
import 'package:otzaria/localization/localization_extension.dart';

bool isHebrew = context.isHebrew;      // true if Hebrew
bool isEnglish = context.isEnglish;    // true if English
String locale = context.currentLocale; // 'he' or 'en'
TextDirection dir = context.textDirection; // TextDirection.rtl or ltr

// ============================================
// 5. CHECK CURRENT LANGUAGE (with SettingsBloc)
// ============================================
BlocBuilder<SettingsBloc, SettingsState>(
  builder: (context, state) {
    if (state.language == 'en') {
      // English-specific logic
    }
    return Container();
  },
)

// ============================================
// 6. STRING NAMING CONVENTIONS
// ============================================
// Use camelCase for all string keys:
'save'               // Common actions
'cancel'
'myCustomButton'     // Custom buttons
'errorMessage'       // Messages
'profileTitle'       // Titles
'validationError'    // Errors
'hebrewBookLabel'    // Labels

// ============================================
// 7. WHAT TO TRANSLATE
// ============================================
✅ DO TRANSLATE:
  - All UI text (buttons, labels, menus)
  - Error and validation messages
  - Dialog titles and content
  - Tooltips and help text
  - Status messages

❌ DON'T TRANSLATE:
  - Biblical terms: תנך, גמרא, משנה, תלמוד, תורה, מדרש, etc.
  - App name: אוצריא
  - Technical terms or abbreviations
  - Names of people or places

// ============================================
// 8. PERSISTENCE
// ============================================
// Language choice is automatically saved and restored:
// 1. User changes language in Settings
// 2. UpdateLanguage event fired
// 3. SettingsRepository.updateLanguage() saves to storage
// 4. On app restart, language loaded automatically

// ============================================
// 9. RTL/LTR HANDLING
// ============================================
// Flutter handles text direction automatically:
// Hebrew (he) → RTL (Right-to-Left)
// English (en) → LTR (Left-to-Right)
// Just use context.tr() or Translate and you're done!

// ============================================
// 10. USEFUL IMPORTS
// ============================================
import 'package:otzaria/localization/localization_extension.dart';
import 'package:otzaria/localization/translate.dart';
import 'package:otzaria/localization/app_strings.dart';
import 'package:otzaria/settings/settings_bloc.dart';
import 'package:otzaria/settings/settings_event.dart';
