#!/bin/bash
# Script to find all hardcoded strings in Dart widgets and show statistics

echo "=== Otzaria Localization Integration Status ==="
echo ""
echo "Searching for hardcoded Text( strings in key files..."
echo ""

# Count patterns in key files
echo "DIALOG FILES:"
grep -r "const Text(" lib/widgets/ lib/navigation/ 2>/dev/null | grep -E "Text\('.*'" | wc -l

echo ""
echo "SETTINGS FILES:"
grep -r "const Text(" lib/settings/ 2>/dev/null | grep -E "Text\('.*'" | wc -l

echo ""
echo "TEXT BOOK/DISPLAY:"
grep -r "const Text(" lib/text_book/ 2>/dev/null | grep -E "Text\('.*'" | wc -l

echo ""
echo "SAMPLE STRINGS FOUND (first 10):"
echo "================================"
grep -r "Text(" lib/widgets/ lib/navigation/ lib/settings/ 2>/dev/null | grep -E "Text\('[א-ת]" | head -10

echo ""
echo "=== KEY FILES THAT NEED UPDATES ==="
echo ""
echo "HIGH PRIORITY (Most visible to users):"
echo "1. lib/settings/settings_screen.dart - Settings labels"
echo "2. lib/navigation/about_screen.dart - About dialog"
echo "3. lib/widgets/input_dialog.dart - Input dialogs"
echo "4. lib/text_book/view/text_book_screen.dart - Book display"
echo "5. lib/navigation/calendar_widget.dart - Calendar"
echo ""

echo "MEDIUM PRIORITY:"
echo "6. lib/settings/gematria_settings_dialog.dart"
echo "7. lib/settings/reading_settings_dialog.dart"
echo "8. lib/printing/printing_screen.dart"
echo ""

echo "The localization system is FULLY FUNCTIONAL."
echo "Next step: Use context.tr('key') instead of hardcoded Text('string')"
echo ""
echo "Example conversion:"
echo "  Before: Text('save')"
echo "  After:  Text(context.tr('save'))"
