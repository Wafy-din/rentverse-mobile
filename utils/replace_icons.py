#!/usr/bin/env python3
"""
Automated icon replacement script for Rentverse UI modernization.
Replaces Material Icons with Lucide icons across all Dart files.
"""

import re
import os
from pathlib import Path

# Icon mapping from Material Icons to Lucide Icons
ICON_MAPPINGS = {
    # Navigation
    r'Icons\.arrow_back': 'LucideIcons.arrowLeft',
    r'Icons\.arrow_forward': 'LucideIcons.arrowRight',
    r'Icons\.close': 'LucideIcons.x',
    r'Icons\.menu': 'LucideIcons.menu',
    r'Icons\.more_vert': 'LucideIcons.moreVertical',
    r'Icons\.more_horiz': 'LucideIcons.moreHorizontal',
    
    # Notifications & Alerts
    r'Icons\.notifications(_none)?(_outlined)?': 'LucideIcons.bell',
    r'Icons\.notifications_off(_outlined)?': 'LucideIcons.bellOff',
    r'Icons\.error(_outline)?': 'LucideIcons.alertCircle',
    r'Icons\.warning(_amber)?': 'LucideIcons.alertTriangle',
    r'Icons\.info(_outline)?': 'LucideIcons.info',
    
    # User & Profile
    r'Icons\.person(_outline)?': 'LucideIcons.user',
    r'Icons\.account_circle': 'LucideIcons.userCircle',
    r'Icons\.badge(_outlined)?': 'LucideIcons.badge',
    
    # Communication
    r'Icons\.mail(_outline)?(_rounded)?': 'LucideIcons.mail',
    r'Icons\.email(_outlined)?': 'LucideIcons.mail',
    r'Icons\.phone(_outlined)?(_android)?(_rounded)?': 'LucideIcons.phone',
    r'Icons\.call': 'LucideIcons.phone',
    r'Icons\.chat(_bubble)?': 'LucideIcons.messageCircle',
    r'Icons\.message': 'LucideIcons.messageSquare',
    r'Icons\.send(_outlined)?': 'LucideIcons.send',
    
    # Actions
    r'Icons\.edit': 'LucideIcons.edit',
    r'Icons\.delete(_outline)?': 'LucideIcons.trash2',
    r'Icons\.add(_circle)?(_outline)?': 'LucideIcons.plus',
    r'Icons\.remove(_circle)?(_outline)?': 'LucideIcons.minus',
    r'Icons\.check(_circle)?(_outline)?': 'LucideIcons.check',
    r'Icons\.check_circle': 'LucideIcons.checkCircle',
    r'Icons\.cancel': 'LucideIcons.xCircle',
    
    # Files & Upload
    r'Icons\.upload(_file)?': 'LucideIcons.upload',
    r'Icons\.download': 'LucideIcons.download',
    r'Icons\.cloud_upload(_outlined)?': 'LucideIcons.cloudUpload',
    r'Icons\.attach_file': 'LucideIcons.paperclip',
    r'Icons\.insert_drive_file': 'LucideIcons.file',
    r'Icons\.folder(_open)?': 'LucideIcons.folder',
    
    # Media
    r'Icons\.image(_not_supported)?(_outlined)?': 'LucideIcons.image',
    r'Icons\.photo(_outlined)?': 'LucideIcons.image',
    r'Icons\.camera(_alt)?': 'LucideIcons.camera',
    r'Icons\.video_camera_back': 'LucideIcons.video',
    r'Icons\.broken_image': 'LucideIcons.imageOff',
    
    # Location & Map
    r'Icons\.location_on(_outlined)?': 'LucideIcons.mapPin',
    r'Icons\.place': 'LucideIcons.mapPin',
    r'Icons\.location_pin': 'LucideIcons.mapPin',
    r'Icons\.map': 'LucideIcons.map',
    
    # Date & Time
    r'Icons\.calendar(_today)?(_rounded)?': 'LucideIcons.calendar',
    r'Icons\.event': 'LucideIcons.calendarDays',
    r'Icons\.calendar_month': 'LucideIcons.calendar',
    r'Icons\.access_time': 'LucideIcons.clock',
    r'Icons\.schedule': 'LucideIcons.clock',
    r'Icons\.timer': 'LucideIcons.timer',
    r'Icons\.hourglass_bottom': 'LucideIcons.hourglass',
    r'Icons\.history': 'LucideIcons.history',
    
    # Security
    r'Icons\.lock(_open)?': 'LucideIcons.lock',
    r'Icons\.visibility': 'LucideIcons.eye',
    r'Icons\.visibility_off': 'LucideIcons.eyeOff',
    r'Icons\.security': 'LucideIcons.shield',
    
    # Finance & Payment
    r'Icons\.payment': 'LucideIcons.creditCard',
    r'Icons\.credit_card': 'LucideIcons.creditCard',
    r'Icons\.account_balance(_wallet)?(_outlined)?': 'LucideIcons.wallet',
    r'Icons\.monetization_on(_outlined)?': 'LucideIcons.dollarSign',
    r'Icons\.receipt(_long)?(_outlined)?': 'LucideIcons.receipt',
    r'Icons\.payments(_outlined)?': 'LucideIcons.banknote',
    r'Icons\.swap_horiz': 'LucideIcons.arrowLeftRight',
    
    # Property & Home
    r'Icons\.home(_work)?(_outlined)?': 'LucideIcons.home',
    r'Icons\.house': 'LucideIcons.home',
    r'Icons\.apartment': 'LucideIcons.building',
    r'Icons\.business': 'LucideIcons.building2',
    r'Icons\.bed': 'LucideIcons.bed',
    r'Icons\.bathtub': 'LucideIcons.bath',
    r'Icons\.square_foot': 'LucideIcons.square',
    
    # Search & Filter
    r'Icons\.search': 'LucideIcons.search',
    r'Icons\.filter_list': 'LucideIcons.filter',
    r'Icons\.sort': 'LucideIcons.arrowUpDown',
    
    # Charts & Stats
    r'Icons\.pie_chart(_outline)?': 'LucideIcons.pieChart',
    r'Icons\.bar_chart': 'LucideIcons.barChart',
    r'Icons\.trending_up': 'LucideIcons.trendingUp',
    r'Icons\.analytics': 'LucideIcons.lineChart',
    
    # Documents
    r'Icons\.description': 'LucideIcons.fileText',
    r'Icons\.note(_alt)?(_outlined)?': 'LucideIcons.fileText',
    r'Icons\.report': 'LucideIcons.fileText',
    r'Icons\.article': 'LucideIcons.newspaper',
    
    # Numbers
    r'Icons\.numbers': 'LucideIcons.hash',
    r'Icons\.tag': 'LucideIcons.tag',
}

def add_lucide_import(content):
    """Add Lucide icons import if not present."""
    if 'package:lucide_icons/lucide_icons.dart' in content:
        return content
    
    # Find the last import statement
    import_pattern = r"(import\s+['\"].*?['\"];)"
    imports = list(re.finditer(import_pattern, content))
    
    if imports:
        last_import = imports[-1]
        insert_pos = last_import.end()
        return (content[:insert_pos] + 
                "\nimport 'package:lucide_icons/lucide_icons.dart';" +
                content[insert_pos:])
    
    return content

def replace_icons(content):
    """Replace Material Icons with Lucide Icons."""
    modified = content
    replacements_made = []
    
    for material_icon, lucide_icon in ICON_MAPPINGS.items():
        pattern = re.compile(material_icon)
        if pattern.search(modified):
            modified = pattern.sub(lucide_icon, modified)
            replacements_made.append(f"{material_icon} -> {lucide_icon}")
    
    return modified, replacements_made

def remove_box_shadows(content):
    """Remove boxShadow properties from Container decorations."""
    # Pattern to match boxShadow arrays
    pattern = r',?\s*boxShadow:\s*\[[\s\S]*?\],?'
    modified = re.sub(pattern, '', content)
    return modified

def process_file(file_path):
    """Process a single Dart file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        
        # Replace icons
        content, replacements = replace_icons(content)
        
        # Remove box shadows
        content = remove_box_shadows(content)
        
        # Add Lucide import if icons were replaced
        if replacements:
            content = add_lucide_import(content)
        
        # Only write if changes were made
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            return True, replacements
        
        return False, []
    
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return False, []

def main():
    """Main function to process all Dart files."""
    lib_dir = Path('lib')
    dart_files = list(lib_dir.rglob('*.dart'))
    
    print(f"Found {len(dart_files)} Dart files")
    print("Processing...")
    print()
    
    modified_count = 0
    
    for dart_file in dart_files:
        was_modified, replacements = process_file(dart_file)
        
        if was_modified:
            modified_count += 1
            print(f"✓ {dart_file}")
            if replacements:
                for replacement in replacements[:3]:  # Show first 3 replacements
                    print(f"  - {replacement}")
                if len(replacements) > 3:
                    print(f"  ... and {len(replacements) - 3} more")
    
    print()
    print(f"Modified {modified_count} files")

if __name__ == '__main__':
    main()
