import 'package:flutter/material.dart';
import 'package:rentverse/features/property/domain/entity/list_property_entity.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AccessoriseWidget extends StatelessWidget {
  const AccessoriseWidget({super.key, required this.attributes});

  final List<PropertyAttributeEntity> attributes;

  @override
  Widget build(BuildContext context) {
    final attributeItems = attributes
        .where((attr) => attr.attributeType != null)
        .map(_mapAttribute)
        .where((data) => data != null)
        .cast<_AccessoriseData>()
        .toList();

    final items = attributeItems;

    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Wrap(
        spacing: 20,
        runSpacing: 12,
        children: items
            .map(
              (item) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(item.icon, size: 18, color: Colors.teal),
                  const SizedBox(width: 6),
                  Text(
                    item.value.isEmpty
                        ? item.label
                        : '${item.value} ${item.label}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600))]))
            .toList()));
  }

  _AccessoriseData? _mapAttribute(PropertyAttributeEntity attr) {
    final type = attr.attributeType;
    if (type == null) return null;

    final slug = type.slug.toLowerCase();
    final iconKey = type.iconUrl.toLowerCase();
    final value = attr.value.isNotEmpty ? attr.value : '-';

    return _AccessoriseData(
      label: type.label,
      value: value,
      icon: _iconFor(slug, iconKey));
  }

  IconData _iconFor(String slug, String iconKey) {
    switch (slug) {
      case 'bedroom':
        return LucideIcons.bed;
      case 'bathroom':
        return LucideIcons.bath;
      case 'furnishing':
        return LucideIcons.armchair;
      case 'area':
      case 'size':
      case 'sqft':
        return LucideIcons.square;
      default:
        switch (iconKey) {
          case 'bed':
            return LucideIcons.bed;
          case 'bath':
            return LucideIcons.bath;
          case 'sofa':
            return LucideIcons.armchair;
          default:
            return LucideIcons.info;
        }
    }
  }
}

class _AccessoriseData {
  const _AccessoriseData({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}
