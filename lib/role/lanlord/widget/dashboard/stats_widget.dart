import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class StatItem {
  const StatItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.delta,
  });

  final IconData icon;
  final String title;
  final String value;
  final String delta;
}

class StatsWidget extends StatelessWidget {
  const StatsWidget({
    super.key,
    required this.items,
    this.periods = const ['Monthly'],
    this.selectedPeriod,
    this.onPeriodChanged,
  });

  final List<StatItem> items;
  final List<String> periods;
  final String? selectedPeriod;
  final ValueChanged<String?>? onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    final periodValue =
        selectedPeriod ?? (periods.isNotEmpty ? periods.first : '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Stats',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const Spacer(),
            if (periods.isNotEmpty)
              DropdownButton<String>(
                value: periodValue,
                items: periods
                    .map(
                      (p) => DropdownMenuItem<String>(value: p, child: Text(p)))
                    .toList(),
                onChanged: onPeriodChanged,
                underline: const SizedBox.shrink(),
                style: const TextStyle(fontSize: 12, color: Colors.black87),
                iconSize: 18,
                borderRadius: BorderRadius.circular(10))]),
        Row(
          children:
              items
                  .map(
                    (item) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: _StatCard(item: item))))
                  .toList()
                ..last = Expanded(child: _StatCard(item: items.last)))]);
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.item});

  final StatItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6FBF6),
                  borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  item.icon,
                  color: const Color(0xFF00BFA6),
                  size: 18)),
              const Spacer(),
              Icon(LucideIcons.moreVertical, size: 18, color: Colors.black54)]),
          const SizedBox(height: 10),
          Text(
            item.title,
            style: const TextStyle(fontSize: 13, color: Colors.black87)),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                item.value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700)),
              const Spacer(),
              Text(
                item.delta,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF00BFA6)))])]));
  }
}
