#!/usr/bin/env python3
"""
Script to fix LucideIcons errors in the Flutter project.
Fixes:
1. Incorrect icon names (edit_outlined -> edit, lock_outline -> lock, etc.)
2. LucideLucideIcons typo -> LucideIcons
3. Removes const keyword from non-constant icon expressions
"""

import os
import re
from pathlib import Path

# Icon name mappings from incorrect to correct
ICON_MAPPINGS = {
    'edit_outlined': 'edit',
    'lock_outline': 'lock',
    'bed_outlined': 'bed',
    'bath_outlined': 'bath',
    'calendar_outlined': 'calendar',
    'calendarDays_available_outlined': 'calendarDays',
    'calendarDays_busy_outlined': 'calendarDays',
    'cloudUpload': 'cloudUpload',
    'bookmark_added_outlined': 'bookmark',
    'badgeCheck_outlined': 'badgeCheck',
    'creditCards_outlined': 'creditCard',
    'building_outlined': 'building',
    'mapPin_outlined': 'mapPin',
    'star_rounded': 'star',
}

def fix_file(filepath):
    """Fix LucideIcons errors in a single file."""
    # Skip if it's a directory
    if not filepath.is_file():
        return False
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    
    # Fix 1: Replace LucideLucideIcons with LucideIcons
    content = content.replace('LucideLucideIcons', 'LucideIcons')
    
    # Fix 2: Replace incorrect icon names
    for old_name, new_name in ICON_MAPPINGS.items():
        # Match LucideIcons.old_name
        content = re.sub(
            rf'LucideIcons\.{re.escape(old_name)}\b',
            f'LucideIcons.{new_name}',
            content
        )
    
    # Fix 3: Remove const from Icon(LucideIcons.xxx) expressions
    # Pattern: const Icon(LucideIcons.xxx
    content = re.sub(
        r'\bconst\s+Icon\s*\(\s*LucideIcons\.',
        'Icon(LucideIcons.',
        content
    )
    
    # Fix 4: Remove const from GradientIcon(icon: LucideIcons.xxx) expressions
    content = re.sub(
        r'\bconst\s+GradientIcon\s*\(\s*icon:\s*LucideIcons\.',
        'GradientIcon(icon: LucideIcons.',
        content
    )
    
    # Only write if content changed
    if content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        return True
    return False

def main():
    """Main function to process all Dart files."""
    project_root = Path(__file__).parent
    lib_dir = project_root / 'lib'
    
    if not lib_dir.exists():
        print(f"Error: {lib_dir} does not exist")
        return
    
    # Find all .dart files
    dart_files = list(lib_dir.rglob('*.dart'))
    
    print(f"Found {len(dart_files)} Dart files")
    fixed_count = 0
    
    for dart_file in dart_files:
        if fix_file(dart_file):
            print(f"Fixed: {dart_file.relative_to(project_root)}")
            fixed_count += 1
    
    print(f"\nTotal files fixed: {fixed_count}")

if __name__ == '__main__':
    main()
