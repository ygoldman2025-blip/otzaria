#!/usr/bin/env python3
"""
Fix all StatefulWidget screens to listen to language changes via BlocBuilder
"""
import re
import os

screens_to_fix = [
    "lib/tabs/reading_screen.dart",
    "lib/navigation/about_screen.dart",
    "lib/text_book/view/page_shape/page_shape_screen.dart",
    "lib/text_book/view/combined_view/combined_book_screen.dart",
    "lib/text_book/view/splited_view/splited_view_screen.dart",
    "lib/text_book/view/commentators_list_screen.dart",
    "lib/text_book/view/selected_line_links_view.dart",
    "lib/personal_notes/view/personal_notes_screen.dart",
    "lib/pdf_book/pdf_book_screen.dart",
    "lib/settings/settings_screen.dart",
    "lib/printing/printing_screen.dart",
]

def add_imports(content):
    """Add flutter_bloc and settings_bloc imports if missing"""
    if "import 'package:flutter_bloc/flutter_bloc.dart';" not in content:
        # Find the last import line
        last_import_match = None
        for match in re.finditer(r'^import ', content, re.MULTILINE):
            last_import_match = match
        
        if last_import_match:
            end_pos = content.find('\n', last_import_match.start())
            content = (content[:end_pos+1] + 
                      "import 'package:flutter_bloc/flutter_bloc.dart';\n" +
                      content[end_pos+1:])
    
    if "import 'package:otzaria/settings/settings_bloc.dart';" not in content:
        # Find the last import line
        last_import_match = None
        for match in re.finditer(r'^import ', content, re.MULTILINE):
            last_import_match = match
        
        if last_import_match:
            end_pos = content.find('\n', last_import_match.start())
            content = (content[:end_pos+1] + 
                      "import 'package:otzaria/settings/settings_bloc.dart';\n" +
                      content[end_pos+1:])
    
    return content

def wrap_build_method(content):
    """Wrap the build method with BlocBuilder"""
    # Find the build method
    build_pattern = r'(@override\s+)?Widget build\(BuildContext context\)\s*\{([^}]*?)return\s+(\w+\()'
    
    def replacer(match):
        override = match.group(1) or "@override\n  "
        method_body = match.group(2)
        return_stmt = match.group(3)
        
        # Check if already wrapped
        if "BlocBuilder<SettingsBloc" in content[match.start():match.start()+500]:
            return match.group(0)  # Already wrapped
        
        return f"""{override}
  Widget build(BuildContext context) {{
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {{
        return {return_stmt}"""
    
    content = re.sub(build_pattern, replacer, content, flags=re.DOTALL)
    
    # Find the closing brace and add closing for BlocBuilder
    # This is a simple approach - find the last closing of Scaffold/Container/etc
    # and add closing braces
    
    return content

def fix_file(filepath):
    """Fix a single file"""
    if not os.path.exists(filepath):
        print(f"File not found: {filepath}")
        return False
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    
    # Add imports
    content = add_imports(content)
    
    # Wrap build method - more careful approach
    # Find @override Widget build pattern
    pattern = r'(@override\s+)?Widget build\(BuildContext context\)\s*\{'
    match = re.search(pattern, content)
    
    if match and "BlocBuilder<SettingsBloc" not in content:
        # Find the start of the build method
        start_pos = match.end()
        
        # Find the opening "return" statement
        return_match = re.search(r'\breturn\b', content[start_pos:start_pos+500])
        if return_match:
            return_pos = start_pos + return_match.start()
            indent = "    "
            
            # Insert BlocBuilder wrapper before return
            before_return = content[:return_pos]
            after_return = content[return_pos+6:]  # +6 for "return"
            
            wrapped = f"{before_return}{indent}return BlocBuilder<SettingsBloc, SettingsState>(\n{indent}  builder: (context, state) {{\n{indent}    return{after_return}"
            
            # Now find the matching closing brace for the build method
            # and add closing braces for BlocBuilder
            lines = wrapped.split('\n')
            new_lines = []
            brace_count = 0
            found_builder = False
            closing_index = -1
            
            for i, line in enumerate(lines):
                new_lines.append(line)
                
                if "builder: (context, state) {" in line:
                    found_builder = True
                    brace_count = 1
                elif found_builder:
                    brace_count += line.count('{') - line.count('}')
                    if brace_count == 0 and '}' in line:
                        closing_index = i
                        break
            
            if closing_index > 0:
                # Add closing braces before the final closing brace
                insert_pos = closing_index
                indent_str = "      "
                new_lines.insert(insert_pos, f"{indent_str}      }},\n{indent_str}    );\n{indent_str}  }}")
            
            content = '\n'.join(new_lines)
    
    if content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"✓ Fixed: {filepath}")
        return True
    else:
        print(f"- Already fixed or no changes: {filepath}")
        return False

# Fix all files
for screen in screens_to_fix:
    try:
        fix_file(screen)
    except Exception as e:
        print(f"✗ Error fixing {screen}: {e}")

print("\nDone!")
