import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PropertyRentDetailsCard extends StatelessWidget {
  const PropertyRentDetailsCard({
    super.key,
    required this.location,
    required this.startDate,
    required this.billingPeriod,
    required this.propertyType,
    required this.priceLabel,
  });

  final String location;
  final String startDate;
  final String billingPeriod;
  final String propertyType;
  final String priceLabel;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _item('Location', location, LucideIcons.mapPin, textStyle),
        const SizedBox(height: 8),
        _item('Start Date', startDate, LucideIcons.calendarDays, textStyle),
        const SizedBox(height: 8),
        _item('Billing Period', billingPeriod, LucideIcons.timer, textStyle),
        const SizedBox(height: 8),
        _item(
          'Property Type',
          propertyType,
          LucideIcons.home,
          textStyle,
        ),
        const SizedBox(height: 8),
        _item(
          'Price',
          priceLabel,
          LucideIcons.creditCard,
          textStyle,
          valueStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _item(
    String label,
    String value,
    IconData icon,
    TextStyle? baseStyle, {
    TextStyle? valueStyle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: baseStyle?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(value, style: valueStyle ?? baseStyle),
            ],
          ),
        ),
      ],
    );
  }
}
