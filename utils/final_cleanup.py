#!/usr/bin/env python3
"""
Final cleanup - handle remaining edge cases with specific icon names.
"""

import re

def fix_file(filepath, replacements):
    """Fix a single file with specific replacements."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original = content
        for pattern, replacement in replacements:
            content = re.sub(pattern, replacement, content)
        
        if content != original:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            return True
        return False
    except Exception as e:
        print(f"Error: {e}")
        return False

# Fix accessorise_widget.dart
if fix_file('lib/role/tenant/presentation/widget/detail_property/accessorise_widget.dart', [
    (r'Icons\.chair_alt', 'LucideIcons.armchair'),
]):
    print("✓ accessorise_widget.dart")

# Fix amenities_widget.dart
if fix_file('lib/role/tenant/presentation/widget/detail_property/amenities_widget.dart', [
    (r'Icons\.pool', 'LucideIcons.waves'),
    (r'Icons\.ac_unit', 'LucideIcons.wind'),
    (r'Icons\.park_outlined', 'LucideIcons.trees'),
    (r'Icons\.kitchen', 'LucideIcons.chefHat'),
]):
    print("✓ amenities_widget.dart")

# Fix search_and_sort_widget_in_property.dart
if fix_file('lib/role/tenant/presentation/widget/property/search_and_sort_widget_in_property.dart', [
    (r'Icons\.tune', 'LucideIcons.sliders'),
    (r'LucideLucideIcons\.mapPin', 'LucideIcons.mapPin'),
]):
    print("✓ search_and_sort_widget_in_property.dart")

# Fix booking_property.dart
if fix_file('lib/role/tenant/presentation/pages/property/booking_property.dart', [
    (r'Icons\.arrow_drop_down', 'LucideIcons.chevronDown'),
    (r'LucideLucideIcons\.mapPin', 'LucideIcons.mapPin'),
]):
    print("✓ booking_property.dart")

print("\nDone!")
