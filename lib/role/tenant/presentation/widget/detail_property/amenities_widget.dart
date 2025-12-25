import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AmenitiesWidget extends StatelessWidget {
  const AmenitiesWidget({super.key, this.amenities = const []});

  final List<String> amenities;

  @override
  Widget build(BuildContext context) {
    if (amenities.isEmpty) return const SizedBox.shrink();

    final items = amenities
        .where((a) => a.trim().isNotEmpty)
        .map((a) => a.trim())
        .toList();

    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Features',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 18,
            runSpacing: 12,
            children: items
                .map(
                  (amenity) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _iconForAmenity(amenity),
                        size: 16,
                        color: Colors.teal),
                      const SizedBox(width: 6),
                      Text(
                        _formatAmenityLabel(amenity),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600))]))
                .toList())]));
  }

  IconData _iconForAmenity(String raw) {
    final key = raw.toLowerCase();
    switch (key) {
      case 'pool':
      case 'swimming_pool':
        return LucideIcons.waves;
      case 'wifi':
        return LucideIcons.wifi;
      case 'ac':
      case 'air_conditioner':
      case 'air_conditioning':
        return LucideIcons.wind;
      case 'garden':
        return LucideIcons.trees;
      case 'kitchen':
        return LucideIcons.chefHat;
      default:
        return LucideIcons.check;
    }
  }

  String _formatAmenityLabel(String value) {
    if (value.isEmpty) return '';
    return value[0].toUpperCase() + value.substring(1);
  }
}
