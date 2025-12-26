import 'package:flutter/material.dart';
import 'package:rentverse/common/utils/network_utils.dart';
import 'package:rentverse/features/bookings/domain/entity/res/booking_response_entity.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CardProperty extends StatelessWidget {
  const CardProperty({
    super.key,
    required this.property,
    required this.billingPeriod,
    this.startDate,
  });

  final BookingPropertySummaryEntity? property;
  final String billingPeriod;
  final DateTime? startDate;

  @override
  Widget build(BuildContext context) {
    final p = property;
    final img = p?.imageUrl;
    final resolvedImg = img != null
        ? makeDeviceAccessibleUrl(img) ?? img
        : null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 90,
              height: 90,
              child: resolvedImg != null && resolvedImg.isNotEmpty
                  ? Image.network(
                      resolvedImg,
                      width: 120,
                      height: 88,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        width: 120,
                        height: 88,
                        color: Colors.grey.shade200,
                        child: Icon(LucideIcons.imageOff,
                          color: Colors.grey)))
                  : _placeholder())),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p?.title ?? 'Property',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(LucideIcons.mapPin, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        p?.address ?? '-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12)))]),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _chip(LucideIcons.calendar, _fmtDate(startDate)),
                    _chip(LucideIcons.clock, billingPeriod)])]))]));
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade200,
      child: Icon(LucideIcons.image, color: Colors.grey));
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12))]));
  }
}

String _fmtDate(DateTime? date) {
  if (date == null) return '-';
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
