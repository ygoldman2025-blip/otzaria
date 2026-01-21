# Otzaria Localization Migration Guide

This guide helps you convert hardcoded strings in the app to use the new translation system.

## Quick Start: Converting Your First Widget

### Before (Hardcoded Strings)

```dart
class BookmarkButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text('Add Bookmark'),  // ❌ Hardcoded English
    );
  }
}
```

### After (Using Translations)

```dart
import 'package:otzaria/localization/localization_extension.dart';

class BookmarkButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(context.tr('addBookmark')),  // ✅ Localized
    );
  }
}
```

## Step-by-Step Migration Process

### Step 1: Identify Strings to Translate

Search for hardcoded strings in your file:
- Look for `'some text'` or `"some text"` in Text(), Tooltip(), etc.
- Skip technical terms and biblical words
- Look for repetitive strings that should be constants

### Step 2: Add to app_strings.dart

Open `lib/localization/app_strings.dart` and find the right section:

```dart
// Step 1: Add constant (in the class directly)
static const String addBookmark = 'Add Bookmark';
static const String removeBookmark = 'Remove Bookmark';
static const String myBookmarks = 'My Bookmarks';

// Step 2: Add Hebrew translation
static const Map<String, String> _hebrewStrings = {
  'addBookmark': 'הוסף סימניה',
  'removeBookmark': 'הסר סימניה',
  'myBookmarks': 'הסימניות שלי',
};

// Step 3: Add English translation
static const Map<String, String> _englishStrings = {
  'addBookmark': 'Add Bookmark',
  'removeBookmark': 'Remove Bookmark',
  'myBookmarks': 'My Bookmarks',
};
```

### Step 3: Replace in Your Widget

```dart
// Find all hardcoded strings:
Text('Add Bookmark')     // ❌ OLD
Text('הוסף סימניה')      // ❌ OLD

// Replace with:
Text(context.tr('addBookmark'))  // ✅ NEW
```

## Finding All Strings to Translate

### Using Find in Files

1. Open VS Code's Find in Files (Ctrl+Shift+F)
2. Search for common patterns:
   ```
   Text\(.*'        // Finds Text('...')
   Text\(.*"        // Finds Text("...")
   label: .*'       // Finds label: '...'
   tooltip: .*'     // Finds tooltip: '...'
   ```

3. Exclude already-translated files:
   - Skip `lib/localization/`
   - Skip `lib/settings/` (already configured)
   - Skip test files if you want

### Common Locations to Translate

Priority order for migration:

1. **High Priority:**
   - Navigation labels
   - Dialog titles and buttons
   - Error messages
   - Common button labels

2. **Medium Priority:**
   - Tooltips and help text
   - List item headers
   - Filter and sort labels
   - Setting descriptions

3. **Low Priority:**
   - Debug messages
   - Temporary UI text
   - Internal comments

## Example: Translating a Whole Component

### Before: Bookmarks Widget with Hardcoded Strings

```dart
class BookmarksView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookmarks'),  // ❌
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Genesis 1:1'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              tooltip: 'Delete Bookmark',  // ❌
              onPressed: () {},
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Bookmark',  // ❌
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### After: Using Translations

```dart
import 'package:otzaria/localization/localization_extension.dart';

class BookmarksView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('myBookmarks')),  // ✅
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Genesis 1:1'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              tooltip: context.tr('deleteNote'),  // ✅
              onPressed: () {},
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: context.tr('addBookmark'),  // ✅
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
```

## Common Translation Patterns

### Pattern 1: String Interpolation

**Before:**
```dart
Text('Found ${results.length} results')  // ❌ Can't translate
```

**After:**
```dart
// Add to app_strings.dart:
// 'searchResults': 'Found {count} results'

// Use in widget:
Text(context.tr('searchResults').replaceFirst('{count}', '${results.length}'))

// Or better yet, create a method:
String getSearchResultsText(int count) =>
  count == 1 ? '1 result' : '$count results';
```

### Pattern 2: Conditional Text

**Before:**
```dart
Text(isDarkMode ? 'Dark Mode' : 'Light Mode')  // ❌ Partially hardcoded
```

**After:**
```dart
Text(context.tr(isDarkMode ? 'darkMode' : 'lightMode'))  // ✅
```

### Pattern 3: Pluralization

**Before:**
```dart
Text(bookCount == 1 ? 'Book' : 'Books')  // ❌ Partially hardcoded
```

**After:**
```dart
// Option 1: Keep simple (most common case)
Text(bookCount == 1 ? context.tr('book') : context.tr('books'))

// Option 2: Create helper
String pluralize(String singularKey, String pluralKey, int count) =>
  count == 1 ? context.tr(singularKey) : context.tr(pluralKey);
```

## Testing Your Translations

### Test Checklist

- [ ] App builds without errors
- [ ] Switch language in Settings
- [ ] All UI text updates to new language
- [ ] Text direction changes (RTL for Hebrew, LTR for English)
- [ ] No white space or broken layouts
- [ ] All button labels are readable
- [ ] All error messages are translated
- [ ] Dialog content is translated

### Quick Test Script

```dart
// Add to a dev widget to verify all strings exist:
import 'package:otzaria/localization/app_strings.dart';

void testAllStringsExist() {
  final hebrewStrings = AppStrings._hebrewStrings;
  final englishStrings = AppStrings._englishStrings;
  
  final allKeys = {...hebrewStrings.keys, ...englishStrings.keys};
  
  for (final key in allKeys) {
    assert(hebrewStrings.containsKey(key), 'Missing Hebrew: $key');
    assert(englishStrings.containsKey(key), 'Missing English: $key');
    assert(hebrewStrings[key]!.isNotEmpty, 'Empty Hebrew: $key');
    assert(englishStrings[key]!.isNotEmpty, 'Empty English: $key');
  }
  
  print('✅ All strings are properly translated!');
}
```

## Handling Special Cases

### Case 1: Strings that Come from Backend/User Input

Don't translate these - they're dynamic content:

```dart
// ❌ DON'T translate:
Text(bookTitle)        // User's book title
Text(authorName)       // Person's name
Text(userComment)      // User's note

// ✅ Only translate the label:
Text('Title: $bookTitle')  // Part 1: translate "Title"
```

### Case 2: Technical Abbreviations

```dart
// These usually don't need translation:
Text('PDF')            // Standard abbreviation
Text('HTML')           // Standard abbreviation
Text('RTL')            // Technical term
Text('תנך')            // Biblical term - keep as is
```

### Case 3: Mixed Content

```dart
// Before:
Text('Please cite as: ${book.citation}')  // ❌ Mixed

// After - translate only the UI part:
// Add 'citationLabel': 'Please cite as:' to translations
Text('${context.tr("citationLabel")}: ${book.citation}')  // ✅
```

## Common Issues and Solutions

### Issue: Text not updating when language changes?

**Solution:** Make sure you're using `context.tr()` which rebuilds the widget when locale changes.

```dart
// ❌ Won't rebuild
String text = Translate.he('myString');
Text(text)

// ✅ Will rebuild  
Text(context.tr('myString'))
```

### Issue: Hebrew text looks garbled?

**Solution:** Check that you're using proper Hebrew font:
- Default: FrankRuhlCLM (set in settings)
- Ensure fonts are in `fonts/` directory
- Check `pubspec.yaml` for font configuration

### Issue: Text overflow with translated text?

**Solution:** The translated text might be longer. Use:
```dart
Text(
  context.tr('myString'),
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
```

### Issue: String key not found, shows key instead of text?

**Solution:** The key exists in app_strings.dart constant but not in one of the maps.

```dart
// Check both maps have the key:
'myKey': 'My String',  // In _hebrewStrings
'myKey': 'My String',  // In _englishStrings  ← Both must exist!
```

## Best Practices Checklist

- [ ] Use consistent camelCase for all translation keys
- [ ] Add both Hebrew AND English translations at the same time
- [ ] Test both languages before committing
- [ ] Group related translations in app_strings.dart (comments help)
- [ ] Never hardcode strings that users see
- [ ] Use extension method `context.tr()` in widgets
- [ ] Use `Translate` static helper when BuildContext unavailable
- [ ] Review existing translations before adding new ones (avoid duplication)
- [ ] Keep biblical terms and proper nouns untranslated
- [ ] Run `flutter analyze` to catch any unused/missing strings

## Quick Command Reference

```bash
# Find all hardcoded strings in widgets
grep -r "Text(" lib/ | grep -E "['\"]\s*[a-zA-Z]" | head -20

# Count total translatable strings
grep -c "'.*':" lib/localization/app_strings.dart

# Check for untranslated strings (search for raw strings in widgets)
grep -r "Text\(" lib/widgets lib/screens | grep -v "context.tr\|Translate\." | head -20
```

## Next Steps

1. Start with high-priority files
2. Add 5-10 strings at a time to app_strings.dart
3. Update corresponding widget files
4. Test both languages
5. Commit with clear message: "i18n: Translate [component name]"
6. Gradually migrate the entire app

---

**Progress Tracking:** Keep track of which files have been migrated to make it easier to spot remaining hardcoded strings.
