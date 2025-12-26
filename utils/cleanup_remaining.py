#!/usr/bin/env python3
"""
Second pass - handle remaining edge cases and boxShadows more aggressively.
"""

import re
import os
from pathlib import Path

def remove_box_shadows_aggressive(content):
    """Remove boxShadow properties more aggressively."""
    # Pattern 1: Multi-line boxShadow
    pattern1 = r',?\s*boxShadow:\s*\[[\s\S]*?\]'
    content = re.sub(pattern1, '', content)
    
    # Pattern 2: Single line boxShadow
    pattern2 = r',?\s*boxShadow:\s*const\s*\[[\s\S]*?\]'
    content = re.sub(pattern2, '', content)
    
    # Pattern 3: BoxShadow with specific patterns
    pattern3 = r',?\s*boxShadow:\s*\[\s*BoxShadow\([^]]+\)\s*\]'
    content = re.sub(pattern3, '', content)
    
    # Clean up double commas
    content = re.sub(r',\s*,', ',', content)
    
    # Clean up trailing commas before closing braces/brackets
    content = re.sub(r',\s*\)', ')', content)
    content = re.sub(r',\s*\]', ']', content)
    
    return content

def replace_remaining_icons(content):
    """Replace any remaining Material Icons patterns."""
    replacements = {
        r'Icons\.settings': 'LucideIcons.settings',
        r'Icons\.logout': 'LucideIcons.logOut',
        r'Icons\.verified': 'LucideIcons.badgeCheck',
        r'Icons\.star(_border)?(_outline)?': 'LucideIcons.star',
        r'Icons\.favorite(_border)?': 'LucideIcons.heart',
        r'Icons\.share': 'LucideIcons.share2',
        r'Icons\.bookmark(_border)?': 'LucideIcons.bookmark',
        r'Icons\.refresh': 'LucideIcons.refreshCw',
        r'Icons\.sync': 'LucideIcons.refreshCw',
        r'Icons\.help(_outline)?': 'LucideIcons.helpCircle',
        r'Icons\.question_mark': 'LucideIcons.helpCircle',
        r'Icons\.expand_more': 'LucideIcons.chevronDown',
        r'Icons\.expand_less': 'LucideIcons.chevronUp',
        r'Icons\.chevron_right': 'LucideIcons.chevronRight',
        r'Icons\.chevron_left': 'LucideIcons.chevronLeft',
        r'Icons\.keyboard_arrow_down': 'LucideIcons.chevronDown',
        r'Icons\.keyboard_arrow_up': 'LucideIcons.chevronUp',
        r'Icons\.keyboard_arrow_right': 'LucideIcons.chevronRight',
        r'Icons\.keyboard_arrow_left': 'LucideIcons.chevronLeft',
        r'Icons\.done': 'LucideIcons.check',
        r'Icons\.clear': 'LucideIcons.x',
        r'Icons\.block': 'LucideIcons.ban',
        r'Icons\.flag': 'LucideIcons.flag',
        r'Icons\.thumb_up': 'LucideIcons.thumbsUp',
        r'Icons\.thumb_down': 'LucideIcons.thumbsDown',
        r'Icons\.visibility_outlined': 'LucideIcons.eye',
        r'Icons\.comment': 'LucideIcons.messageSquare',
        r'Icons\.reply': 'LucideIcons.reply',
        r'Icons\.forward': 'LucideIcons.forward',
        r'Icons\.save': 'LucideIcons.save',
        r'Icons\.print': 'LucideIcons.printer',
        r'Icons\.copy': 'LucideIcons.copy',
        r'Icons\.paste': 'LucideIcons.clipboard',
        r'Icons\.cut': 'LucideIcons.scissors',
        r'Icons\.undo': 'LucideIcons.undo',
        r'Icons\.redo': 'LucideIcons.redo',
        r'Icons\.zoom_in': 'LucideIcons.zoomIn',
        r'Icons\.zoom_out': 'LucideIcons.zoomOut',
        r'Icons\.fullscreen': 'LucideIcons.maximize',
        r'Icons\.fullscreen_exit': 'LucideIcons.minimize',
        r'Icons\.play_arrow': 'LucideIcons.play',
        r'Icons\.pause': 'LucideIcons.pause',
        r'Icons\.stop': 'LucideIcons.square',
        r'Icons\.skip_next': 'LucideIcons.skipForward',
        r'Icons\.skip_previous': 'LucideIcons.skipBack',
        r'Icons\.volume_up': 'LucideIcons.volume2',
        r'Icons\.volume_down': 'LucideIcons.volume1',
        r'Icons\.volume_off': 'LucideIcons.volumeX',
        r'Icons\.brightness_high': 'LucideIcons.sun',
        r'Icons\.brightness_low': 'LucideIcons.moon',
        r'Icons\.wifi': 'LucideIcons.wifi',
        r'Icons\.bluetooth': 'LucideIcons.bluetooth',
        r'Icons\.battery_full': 'LucideIcons.battery',
        r'Icons\.signal_cellular_alt': 'LucideIcons.signal',
    }
    
    modified = content
    for pattern, replacement in replacements.items():
        modified = re.sub(pattern, replacement, modified)
    
    return modified

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

def process_file(file_path):
    """Process a single Dart file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        
        # Remove box shadows aggressively
        content = remove_box_shadows_aggressive(content)
        
        # Replace remaining icons
        content = replace_remaining_icons(content)
        
        # Add Lucide import if needed
        if 'Icons.' in content and 'LucideIcons' in content:
            content = add_lucide_import(content)
        
        # Only write if changes were made
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            return True
        
        return False
    
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return False

def main():
    """Main function."""
    # List of files that still need processing
    files_to_process = [
        'lib/features/auth/presentation/pages/profile_pages.dart',
        'lib/features/auth/presentation/pages/trust_index_page.dart',
        'lib/features/chat/presentation/pages/chat_list_page.dart',
        'lib/features/chat/presentation/pages/chat_room_page_view.dart',
        'lib/role/lanlord/widget/my_property/property_components.dart',
        'lib/role/lanlord/widget/dashboard/property_being_proposed.dart',
        'lib/role/lanlord/widget/dashboard/rented_property.dart',
        'lib/role/lanlord/widget/dashboard/stats_widget.dart',
        'lib/role/lanlord/widget/dashboard/your_trust_index.dart',
        'lib/role/lanlord/presentation/pages/booking_detail.dart',
        'lib/role/tenant/presentation/pages/nav/rent.dart',
        'lib/role/tenant/presentation/pages/property/booking_property.dart',
        'lib/role/tenant/presentation/pages/rent/detail_active_rent.dart',
        'lib/role/tenant/presentation/pages/rent/midtrans_payment_page.dart',
        'lib/role/tenant/presentation/pages/rent/receipt_booking.dart',
        'lib/role/tenant/presentation/widget/detail_property/accessorise_widget.dart',
        'lib/role/tenant/presentation/widget/detail_property/amenities_widget.dart',
        'lib/role/tenant/presentation/widget/property/search_and_sort_widget_in_property.dart',
        'lib/role/tenant/presentation/widget/review/review_widget.dart',
        'lib/role/tenant/presentation/widget/midtrans/card_property.dart',
        'lib/role/tenant/presentation/widget/property/list_property.dart',
        'lib/role/tenant/presentation/widget/receipt_booking/nav_bar_receipt.dart',
    ]
    
    modified_count = 0
    
    for file_path in files_to_process:
        if os.path.exists(file_path):
            if process_file(file_path):
                modified_count += 1
                print(f"✓ {file_path}")
        else:
            print(f"✗ File not found: {file_path}")
    
    print(f"\nModified {modified_count} files")

if __name__ == '__main__':
    main()
